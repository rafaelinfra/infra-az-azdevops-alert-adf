param (
    [parameter(Mandatory = $false)] [string] $webhook
    )

$baseuri = $webhook
$header = @{
    "Accept" = "text/json"
    "Content-Type" = "application/json"
}

Write-Output "Iniciando conexão com o Webhook"
$uri_login = $baseuri
$body = @{"LimitMax"="3";
          "Vtemp"="3";
          "PipeId"="203";
          "TimeSleep"="10"
         } | ConvertTo-Json
Invoke-RestMethod -Method Post $uri_login -Headers $header -Body $body
