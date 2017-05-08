$ErrorActionPreference = "Stop"

Remove-Item .\sitecore\* -Force
Remove-Item .\project\* -Force

#Path to your sitecore zip with the full Sitecore
$sitecorePackagePath = '.\Sitecore 8.2 rev. 170407.zip'

if(-not (Test-path $sitecorePackagePath))
{
	Write-Error "you need to have sitecore package file before you proceed!"
}

Expand-Archive -Path $sitecorePackagePath -DestinationPath .\Sitecore

#Download nuget.exe and package sitecore in a nuget package
$nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
Invoke-WebRequest -Uri $nugetUrl -OutFile .\nuget.exe
.\nuget.exe pack

#create project folder and sitecore solution
mkdir project 
Set-Location project
yo helix pentiahelix SUGCON.2017

#set configuration files in project



