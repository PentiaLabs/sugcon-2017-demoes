$ErrorActionPreference = "Stop"
$oldPreference = $VerbosePreference
$VerbosePreference = "continue"

Write-Verbose -Message "Remove sitecore folder if it exists"
if(Test-Path ".\sitecore")
{
	Remove-Item .\sitecore\* -Force -Recurse
}

Write-Verbose -Message "Remove project folder if it exists"
if(Test-Path ".\project")
{
	Remove-Item .\project\* -Force -Recurse
}
else
{
	New-Item -ItemType Directory -Path project
}

Write-Verbose -Message "Remove nuget.exe"
if(Test-Path ".\nuget.exe")
{
	Remove-Item nuget.exe -Force
}

#Path to your sitecore zip with the full Sitecore download from here: https://dev.sitecore.net/~/media/203A8170D4664A41A8900E7AFEFC803F.ashx 
$sitecorePackagePath = '.\Sitecore 8.2 rev. 170407.zip'

if(-not (Test-path $sitecorePackagePath))
{
	Write-Error "you need to have sitecore package file before you proceed!"
}

Write-Verbose -Message "Extract sitecore package to .\Sitecore"
Expand-Archive -Path $sitecorePackagePath -DestinationPath .\Sitecore

#Download nuget.exe and package sitecore in a nuget package
Write-Verbose -Message "Downloading nuget.exe"
$nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
Invoke-WebRequest -Uri $nugetUrl -OutFile .\nuget.exe -Verbose
.\nuget.exe pack

#create project folder and sitecore solution
Write-Verbose -Message "Create project folder and run the helix generator"
Set-Location project
#install yeoman 'npm install -g yo'
#install helix generator 'npm install generator-helix -g'
yo helix pentiahelix SUGCON.2017

#attach databases
Set-Location ..\
& ".\AttachDatabases.ps1"

#set configuration files in project

$VerbosePreference = $oldPreference