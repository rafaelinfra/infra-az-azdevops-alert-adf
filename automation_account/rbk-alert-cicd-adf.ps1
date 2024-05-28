## TRAZENDO PARAMETROS DA ESTEIRA DO ADF ##

param (
    [Parameter(Mandatory=$false)]
    [object] $WebhookData
)

az extension add --name azure-devops --allow-preview true

$object = $WebhookData.RequestBody | ConvertFrom-Json

###### ----------- CONVERSÃO DOS TYPES VINDOS DO ADF --------------- ###############

$intLimitMax = [int]$object.LimitMax
$intVtemp = [int]$object.Vtemp
$intTimeSleep = [int]$object.TimeSleep

###### -----------  CONEXÃO COM AZURE DEVOPS --------------- ###############

$azuredevops = Get-AutomationVariable -Name 'TKAZUREDEVOPSADF' ## necessário um token do devops
$uri_login = Get-AutomationVariable -Name 'URIWEBROOKTEAMS' ## Url do MS Teams

echo  $azuredevops | az devops login --org https://xxxxxx.azure.com/xxxxxxxx ## Inclusa o link da sua organização

$condicao = $true
$temporizador = 0
$Limite = $intLimitMax

###### -----------  Função para codificar strings --------------- ###############

function Encode-String {
    param($value)
    [System.Web.HttpUtility]::HtmlEncode($value)
}

###### ----------- Função para enviar o card para o Microsoft Teams --------------- ###############

function Send-TeamsCard {
    param(
        [string]$name,
        [int]$Limite,
        [string]$Result,
        [string]$buildId,
        [string]$Status,
        [Datetime]$start,
        [int]$Temporizador,
        [string]$request,
        [string]$body_descript = ""
    )

    $header = @{
        "Accept" = "text/json"
        "Content-Type" = "application/json"
    }
    
    Write-Output "Verificando o Webhook do Microsoft Teams ......."
    Start-Sleep -Seconds 2
    Write-Output "Iniciando envio de Card"
    
    $body = @{
        "type"= "message"
        "attachments"= @(
            @{
                "contentType"= "application/vnd.microsoft.card.adaptive"
                "content"= @{
                    "type"= "AdaptiveCard"
                    "body"= @(
                        @{
                            "type"= "Image"
                            "url"= "https://www.creditsafe.com/content/dam/in/logos/Azure%20DevOps_550x550.png"
                            "altText"= "AzureDevops"
                            "size"= "medium"
                            "horizontalAlignment"= "left"
                        }
                        @{
                            "type"= "TextBlock"
                            "size"= "extraLarge"
                            "weight"= "Bolder"
                            "text"= "Status CI/CD - $name"
                        }
                        @{
                            "type"= "TextBlock"
                            "size"= "large"
                            "weight"= "Bolder"
                            "text"= "$(Encode-String ATENÇÃO)"
                            "color"= "attention"
                        }
                        @{
                            "type"= "TextBlock"
                            "text"= "$(Encode-String Olá)"
                        }
                        @{
                            "type"= "TextBlock"
                            "text"= "<at>Alex</at>, <at>xxxxxx</at>, <at>yyyyyy</at>, <at>aaaaaa</at>, <at>sssss</at>, <at>gggggggg</at>" ## Determine o nome das pessoas que você quer que receba o Alerta
                            "wrap"= $true
                        }
                        @{
                            "type"= "TextBlock"
                            "text"= "$body_descript"
                            "wrap"= $true
                        }
                        @{
                            "type"= "Container"
                            "items"= @(
                                    @{
                                        "type"= "TextBlock"
                                        "text"= "Esteira iniciada por: $request"
                                        "size"= "small"
                                        "weight"= "lighter"
                                        "color"= "light"
                                        "wrap"= $true
                                    }
                                    @{
                                        "type"= "TextBlock"
                                        "text"= "Esteira iniciada: $start"
                                        "size"= "small"
                                        "weight"= "lighter"
                                        "color"= "light"
                                        "wrap"= $true
                                    }
                                    @{
                                        "type"= "TextBlock"
                                        "text"= "Tempo da $(Encode-String execução): $temporizador"
                                        "size"= "small"
                                        "weight"= "lighter"
                                        "color"= "light"
                                        "wrap"= $true
                                    }
                                    @{
                                        "type"= "TextBlock"
                                        "text"= "Status da $(Encode-String execução): $Status"
                                        "size"= "small"
                                        "weight"= "lighter"
                                        "color"= "light"
                                        "wrap"= $true
                                    }
                                    @{
                                        "type"= "TextBlock"
                                        "text"= "Resultado da $(Encode-String execução) = $Result"
                                        "size"= "small"
                                        "weight"= "lighter"
                                        "color"= "light"
                                        "wrap"= $true
                                    }
                            )
                        } 
                    )
                    "actions"= @(
                        @{
                            "type"= "Action.OpenUrl"
                            "title"= "Azure Devops"
                            "url"= "https://xxxxxx.azure.com/xxxxxxx/xxxxx/_build/results?buildId=$buildId&view=results" ### inclusa org/projeto
                        }
                    )
                    "$schema"= "http://adaptivecards.io/schemas/adaptive-card.json"
                    "version"= "1.0"
                    "msteams"= @{
                        "entities"= @(
                            @{
                                "type"= "mention"
                                "text"= "<at>xxxxxxxxxx</at>" #### nome que receberá o card
                                "mentioned"= @{
                                    "id"= "yyyyyyyyyyyyyyyy" #### email relacionado ao nome
                                    "name"= "xxxxxxxxxx" ### nome a ser mencionado
                                }
                            }
                            @{
                                "type"= "mention"
                                "text"= "<at>xxxxxxxxxx</at>" #### nome que receberá o card
                                "mentioned"= @{
                                    "id"= "yyyyyyyyyyyyyyyy" #### email relacionado ao nome
                                    "name"= "xxxxxxxxxx" ### nome a ser mencionado
                                }
                            }
                            @{
                                "type"= "mention"
                                "text"= "<at>xxxxxxxxxx</at>" #### nome que receberá o card
                                "mentioned"= @{
                                    "id"= "yyyyyyyyyyyyyyyy" #### email relacionado ao nome
                                    "name"= "xxxxxxxxxx" ### nome a ser mencionado
                                }
                            }
                            @{
                                "type"= "mention"
                                "text"= "<at>xxxxxxxxxx</at>" #### nome que receberá o card
                                "mentioned"= @{
                                    "id"= "yyyyyyyyyyyyyyyy" #### email relacionado ao nome
                                    "name"= "xxxxxxxxxx" ### nome a ser mencionado
                                }
                            }
                            @{
                                "type"= "mention"
                                "text"= "<at>xxxxxxxxxx</at>" #### nome que receberá o card
                                "mentioned"= @{
                                    "id"= "yyyyyyyyyyyyyyyy" #### email relacionado ao nome
                                    "name"= "xxxxxxxxxx" ### nome a ser mencionado
                                }
                            }
                            @{
                                "type"= "mention"
                                "text"= "<at>xxxxxxxxxx</at>" #### nome que receberá o card
                                "mentioned"= @{
                                    "id"= "yyyyyyyyyyyyyyyy" #### email relacionado ao nome
                                    "name"= "xxxxxxxxxx" ### nome a ser mencionado
                                }
                            }
                        )
                    }
                }
            }
        )
    }

    try {
        Invoke-RestMethod -Method Post $uri_login -Headers $header -Body ($body | ConvertTo-Json -Depth 10)
        Write-Output "Card enviado com sucesso"
    } catch {
        Write-Output "Erro ao enviar o card: $_"
    }
}

###### ----------- BLOCO WHILE PARA TEMPORIZAÇÃO --------------- ###############

while($condicao){

    $definition = az pipelines runs list --project prj-pco --pipeline-ids $object.PipeId --top 1 --query-order StartTimeDesc -o json | ConvertFrom-Json
    
    $Result = $definition.result
    $name = $definition.definition.name
    $request = $definition.requestedBy.displayname
    $buildId = $definition.id
    $start = [DateTime]::ParseExact($definition.startTime, "MM/dd/yyyy HH:mm:ss", $null).AddHours(-3)

    ###### ----------- CONDIÇÃO DE TEMPORIZAÇÃO --------------- ###############

    if( ($definition.Status -eq 'InProgress') -and ($Temporizador -le $Limite) -and ($Result -ne 'failed')){
        $Temporizador +=$intVtemp
        $condicao = $true
        Write-Output "Aguardando $intVtemp min para nova conferencia de status... Status atual:" $definition.Status
        Start-Sleep -Seconds $intTimeSleep
    }

    ###### ----------- CONDIÇÃO DE CONCLUSÃO COM FALHA NO MEIO DO PROCESSO --------------- ###############

    elseif (($definition.Status -eq 'completed') -and ($Result -eq 'failed')) {
        Write-Output "Status da esteira:" $definition.Status
        Write-Output "Resultado da execução: $Result" 
        Send-TeamsCard -name $name -Limite $Limite -Result $Result -buildId $buildId -request $request -start $start -temporizador $temporizador -Status $definition.Status -body_descript "Durante a $(Encode-String execução) da esteira do **data factory** = $name ocorreram **falhas**, acesse o link abaixo e verifique o motivo"
        $condicao = $false
    }

    ###### ----------- CONCLUSÃO COM FALHA TOTAL --------------- ###############

    elseif ($definition.Status -eq 'failed') {
        Write-Output "Status da esteira:" $definition.Status
        Send-TeamsCard -name $name -Limite $Limite -Result $Result -buildId $buildId -request $request -start $start -temporizador $temporizador -Status $definition.Status -body_descript "O tempo de $(Encode-String execução) da esteira do **data factory** = $name, $(Encode-String está) acima da **$(Encode-String média) esperada** ($Limite Min) , acesse o link abaixo e verifique o motivo"
        $condicao = $false
    }

    ###### ----------- CONCLUSÃO COM SUCESSO TOTAL --------------- ###############

    else {
        Write-Output "Status da Esteira:" $definition.Status
        $condicao = $false
    }
        
}