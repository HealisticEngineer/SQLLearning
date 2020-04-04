# free from installing more software
# define information to use
$ServerInstance = "$env:computername"
$Database = "Master"
$ConnectionTimeout = 30
$Query1 = "SELECT name, create_date FROM sys.databases"
$Query2 = "SELECT name FROM sys.syslogins"
$conn = new-object System.Data.SqlClient.SQLConnection

# define connection string
$ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $ServerInstance, $Database, $ConnectionTimeout
$conn.ConnectionString = $ConnectionString
$conn.Open()
# queries
$cmd1 = New-Object system.Data.SqlClient.SqlCommand($Query1, $conn)
$cmd2 = New-Object system.Data.SqlClient.SqlCommand($Query2, $conn)
$da1 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd1)
$da2 = New-Object System.Data.SqlClient.SqlDataAdapter($cmd2)
# object to fill
$datadatabases = New-Object System.Data.DataSet
$datalogins = New-Object System.Data.DataSet
[void]$da1.Fill($datadatabases)
[void]$da2.Fill($datalogins)
$conn.Close()
$datadatabases.Tables[0] | ft 
$datalogins.Tables[0] | ft 



# example two statement with no return value
$cmdText = "create database demo2"
$conn = New-Object System.Data.SQLClient.SQLConnection 
$ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $ServerInstance, $Database, $ConnectionTimeout
$conn.ConnectionString = $ConnectionString
$conn.Open() 
$Command = New-Object System.Data.SQLClient.SQLCommand 
# Set the SqlCommand's connection to the SqlConnection object above. 
$Command.Connection = $conn 
# Set the SqlCommand's command text to the query value passed in. 
$Command.CommandText = $cmdText 
write-Host "Executing SQL Command..." 
# Execute the command against the database without returning results (NonQuery). 
$Command.ExecuteNonQuery() 
# Close the currently open connection. 
$conn.Close() 
