Set-Location ..\project
npm install
& "..\nuget.exe" restore
& "C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe"
gulp setup