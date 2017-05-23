#Requires -RunAsAdministrator
$destination = "$PSScriptRoot\Databases"
Copy-Item  -Path "$PSScriptRoot\Sitecore\Sitecore 8.2 rev. 170407\Databases\*" -Destination $destination -Verbose

$dbs = @("Analytics", "Master", "Web", "Core")
Import-Module SQLPS

foreach ($db in $dbs) {
    if (Test-Path -Path "$destination\Sitecore.$db.ldf") {
        $dbName = "SUGCON.Website.local.$db"
        Rename-item "$destination\Sitecore.$db.ldf" -NewName "$dbName.ldf" -ErrorAction Ignore
        Rename-item "$destination\Sitecore.$db.mdf" -NewName "$dbName.mdf" -ErrorAction Ignore
    }
}

Remove-Item "$destination\Sitecore.*" -Verbose
foreach ($db in $dbs) {
    $dbName = "SUGCON.Website.local.$db"
    $attachSQLCmd = @"
IF DB_ID('$dbName') IS NULL
BEGIN 
CREATE DATABASE [$dbName] ON (FILENAME = '$destination\$dbName.mdf'), (FILENAME = '$destination\$dbName.ldf') FOR ATTACH;
END
"@
      
    Invoke-Sqlcmd -Query $attachSQLCmd -ServerInstance "$env:COMPUTERNAME" -Verbose
}

$createSqlUserCmd = @"
USE [master]
GO
CREATE LOGIN [sugcon_website_login] WITH PASSWORD=N'b', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [sugcon_website_login]
GO
USE [SUGCON.Website.local.Analytics]
GO
DROP USER [sugcon_website_login]
CREATE USER [sugcon_website_login] FOR LOGIN [sugcon_website_login]
GO
USE [SUGCON.Website.local.Analytics]
GO
ALTER ROLE [db_owner] ADD MEMBER [sugcon_website_login]
GO
USE [SUGCON.Website.local.Core]
GO
DROP USER [sugcon_website_login]
CREATE USER [sugcon_website_login] FOR LOGIN [sugcon_website_login]
GO
USE [SUGCON.Website.local.Core]
GO
ALTER ROLE [db_owner] ADD MEMBER [sugcon_website_login]
GO
USE [SUGCON.Website.local.Master]
GO
DROP USER [sugcon_website_login]
CREATE USER [sugcon_website_login] FOR LOGIN [sugcon_website_login]
GO
USE [SUGCON.Website.local.Master]
GO
ALTER ROLE [db_owner] ADD MEMBER [sugcon_website_login]
GO
USE [SUGCON.Website.local.Web]
GO
DROP USER [sugcon_website_login]
CREATE USER [sugcon_website_login] FOR LOGIN [sugcon_website_login]
GO
USE [SUGCON.Website.local.Web]
GO
ALTER ROLE [db_owner] ADD MEMBER [sugcon_website_login]
GO
"@

Invoke-Sqlcmd -Query $createSqlUserCmd -ServerInstance "$env:COMPUTERNAME" -Verbose
set-location $destination