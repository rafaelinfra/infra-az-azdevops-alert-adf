# infra-az-azdevops-alert-adf
Processo criado para alertar no teams caso o adf de alguma falha durante seu processo de CI/CD


## ITENS NECESSÁRIOS PARA O FUNCIONAMENTO ####
- link de um webhook do automationaccount, esse link deve ser deixado como váriavel para que não fique exposto
- o ID do pipeline que quer acompanhar
- Service connection
- Uma "equipes" no microsoft teams, e instalar o connector "Incoming Webhook"
- Utilizar o webhook do teams dentro do automation account.

## Sequencia de funcionamento
- 1º - Pipeline utilizando a task da pasta Azure_devops
- 2º - A task serve para enviar as informações do pipeline que estão na parte no Body do script InvolkeWebhoook.ps1
- 3º - Ao final do script, será iniciado um runbook no automation account, que tem como modelo o descrito na pasta automation_account
- 4º - Esse script fará a consulta do pipeline, verificando seu status de acordo com o que é especificado no body.
- 5º - No caso do temporizado passar do limite definido ele enviará um card para o teams para alertar o time, isso ocorrerá também caso o pipeline finalize complete com status de Completed porém com resultado interno a ele como Failed.
- 6º - No caso de ocorrer no tempo antes do limite definido, o runbook finalizará.