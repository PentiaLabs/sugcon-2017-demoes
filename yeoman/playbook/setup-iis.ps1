#setup IIS
$website = "Sugcon.Website"
$hostName = "local.Sugcon-demo.nl"

Remove-WebAppPool -Name $website
New-WebAppPool -Name $website -Force

if(-not (Test-Path -Path "C:\websites\sugcon.local\Website"))
{
    mkdir C:\websites\sugcon.local\Website
}

if((Get-Website -Name Sugcon.Website | measure | Select-Object -ExpandProperty Count) -gt 0)
{
    Remove-Website -Name $website
}

New-Website -Name $website -PhysicalPath C:\websites\sugcon.local\Website -HostHeader $hostName -Force

$file = "$env:windir\System32\drivers\etc\hosts"
if(-not (Get-Content -Path $file -Raw).Contains($hostName))
{
	"`r`n127.0.0.1 $hostName" | Add-Content -PassThru $file
}