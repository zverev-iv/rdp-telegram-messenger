Param (
    [Parameter(Mandatory = $false, Position = 1, HelpMessage = "Bot token")]
    [string] $botToken = "ADD YOUR BOT TOKEN HERE",
    [Parameter(Mandatory = $false, Position = 2, HelpMessage = "Chat id")]
    [string] $chatId = "ADD YOUR CHAT ID HERE",
    [Parameter(Mandatory = $false, Position = 3, HelpMessage = "Enable TLS 1.2 (disable only if you have connection problems with tls/ssl connection)")]
    [bool] $enableTls12 = $true
)

if($enableTls12) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 #optional
}

$filter = @{
    Logname = 'Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational';
    Id = 1149
}

$evt = Get-WinEvent -FilterHashtable $filter -MaxEvents 1

$msg = @"
RDP LOGIN
Server: $($evt.MachineName)
From: $($evt.Properties[2].Value)
User: $($evt.Properties[1].Value)\$($evt.Properties[0].Value)
On: $($evt.TimeCreated.ToString("yyyy.MM.dd HH:mm:ss"))
"@

$chatUri = "https://api.telegram.org/bot$($botToken)/sendMessage"
$body = ConvertTo-Json -InputObject @{chat_id = $chatId; text = $msg } -Compress

Invoke-RestMethod -Uri $chatUri -Method Post -Body $body -ContentType 'application/json;charset=utf-8'