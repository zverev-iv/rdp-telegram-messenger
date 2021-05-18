[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 #optional
$event = Get-WinEvent -FilterHashtable @{Logname = 'Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational'; Id = 1149 } -MaxEvents 1

$message = "RDP LOGIN`nServer: $($event.MachineName) `nFrom: $($event.Properties[2].Value) `nUser: $($event.Properties[1].Value)\\$($event.Properties[0].Value) `nOn: $($event.TimeCreated.ToString("yyyy.MM.dd HH:mm:ss"))"

$botToken = 'ADD YOUR BOT TOKEN HERE'
$chatID = 'ADD YOUR CHAT ID HERE'

$telegramURI = ("https://api.telegram.org/bot" + $botToken + "/sendMessage")
$telegramJson = ConvertTo-Json -Compress @{chat_id = $chatID; text = $message }
$telegramResponse = Invoke-RestMethod -Uri $telegramURI -Method Post -ContentType 'application/json;charset=utf-8' -Body $telegramJson