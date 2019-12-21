# Create Cert for Encrypting
$splat =@{
    subject = "AlwaysEncryptedCert 1"
    CertStoreLocation = "Cert:CurrentUser\My"
    KeyExportPolicy = "Exportable"
    Type = "DocumentEncryptionCert"
    KeyUsage = "DataEncipherment"
    KeySpec = "KeyExchange"
}
$cert = New-SelfSignedCertificate @splat

# import SQLServer module this must exist on server if not download it with install-module command.
Import-Module "SqlServer"

# create connection to example database
$serverName = "$env:COMPUTERNAME" #name of sql server
$databaseName = "Example" # name of database
$connStr = "Server = " + $serverName + "; Database = " + $databaseName + "; Integrated Security = True"
$connection = New-Object Microsoft.SqlServer.Management.Common.ServerConnection
$connection.ConnectionString = $connStr
$connection.Connect()
$server = New-Object Microsoft.SqlServer.Management.Smo.Server($connection)
$database = $server.Databases[$databaseName]


# create column master key (CMK) using thumbprint
$cmkSettings = New-SqlCertificateStoreColumnMasterKeySettings -CertificateStoreLocation "CurrentUser" -Thumbprint $cert.Thumbprint

$cmkName = "CMK1"
$cmk = New-SqlColumnMasterKey -Name $cmkName -InputObject $database -ColumnMasterKeySettings $cmkSettings

# verifiy the change
$cmk | Select-Object -Property *

# create column encryption key (CEK)
$cekName = "CEK1"
$cek = New-SqlColumnEncryptionKey -Name $cekName  -InputObject $database -ColumnMasterKey $cmkName

# verifiy the change
$cek.ColumnEncryptionKeyValues  | Select-Object -Property *

# select columns to encrypet
# changes column to Latin1_General_BIN2
$ces = @()
$ces += New-SqlColumnEncryptionSettings -ColumnName "dbo.Senstive.Postcode" -EncryptionType "Deterministic" -EncryptionKey "CEK1"
$ces += New-SqlColumnEncryptionSettings -ColumnName "dbo.Senstive.BirthDate" -EncryptionType "Randomized" -EncryptionKey "CEK1"
Set-SqlColumnEncryption -InputObject $database -ColumnEncryptionSettings $ces -LogFileDirectory .

# verify encripyion
$serverName = "$env:COMPUTERNAME"
$databaseName = "Example"
$connStr = "Server = " + $serverName + "; Database = " + $databaseName + "; Integrated Security = True"
Invoke-Sqlcmd -Query "SELECT TOP(1) * FROM Senstive" -ConnectionString $connStr

# check how it looks with cert to decrypt
$connStr = $connStr + "; Column Encryption Setting = Enabled"
Invoke-Sqlcmd -Query "SELECT TOP(1) * FROM Senstive" -ConnectionString $connStr
