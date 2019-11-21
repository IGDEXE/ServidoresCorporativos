# Disponibilidade Servidores
# Ivo Dias

# Credencial
$contaEnvio = "envio@dominio.com.br"
$caminhoCredenciais = "\\$PSScriptRoot\Config"
$identificador = "SEC@311020190706"
$PasswordFile = "$caminhoCredenciais\$identificador.pass"
$key = Get-Content "$caminhoCredenciais\$identificador.key"
$credencialEnvio = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $contaEnvio, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)

# Opcoes do email
$To = "destino@dominio.com.br"
$from = $contaEnvio

# Configuracoes gerais
$ping = new-object system.net.networkinformation.ping # Configura o teste do PING
$listaServidores = "\\$PSScriptRoot\servidoresCorporativos.txt" # Define o caminho para a lista de servidores
Set-ExecutionPolicy Bypass -force # Atribui a permissao
$moduloDicionario = "\\$PSScriptRoot\DicionarioIPs.psm1" # Define o caminho do modulo
Unblock-File -Path $moduloDicionario # Desbloqueia o arquivo
Import-Module $moduloDicionario -Force # Carrega o modulo

# Faz as analises dos servidores
try {
    # Recebe os computadores de uma lista
    $servidores = get-content $listaServidores
    $CorpoEmail = "<h3>Servidores Corporativos</h3>"
    $CorpoEmail += "<table>"
    $CorpoEmail += "    <tr>"
    $CorpoEmail += "        <td class='colorn'>Servidores</td>"
    $CorpoEmail += "        <td class='colorn'>Disponibilidade</td>"
    $CorpoEmail += "    </tr>"
    foreach ($servidor in $servidores) {
        $nome = Dicionario-IPs $servidor
        $CorpoEmail += "    <tr>"
        $CorpoEmail += "        <td class='colorn'>$nome</td>"
        $Return = $ping.send("$servidor")
        $Return = $Return.Status
        if ($Return -eq "Success") {
            $CorpoEmail += "        <td class='Func'> </td>"
        } else {
            $CorpoEmail += "        <td class='Not'> </td>"
        }
        $CorpoEmail += "    </tr>"
    }
    $CorpoEmail += "</table>"
    $CorpoEmail += " "
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
    Write-Host "Deu ruim: $ErrorMessage"
}

# Escreve o Email
$Email = @"
<style>
    body { font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; color:#434242;}
    TABLE { font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
    TR {border-width: 1px;padding: 10px;border-style: solid;border-color: white; }
    TD {font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; border-width: 1px;padding: 10px;border-style: solid;border-color: white; background-color:#C3DDDB;}
    .Func {background-color:green; color:white;}
    .Not {background-color:red; color:white;}
    .colort{background-color:#58A09E; padding:20px; color:white; font-weight:bold;}
</style>
<body>
$CorpoEmail
</body>
"@

# Envia o e-mail
Write-Host "Enviando o CheckList"
        send-mailmessage `
            -To $To `
            -Subject "CheckList Servidores Corporativos $(Get-Date -format dd/MM/yyyy)" `
            -Body $Email `
            -BodyAsHtml `
            -Priority high `
            -UseSsl `
            -Port 587 `
            -SmtpServer 'smtp.office365.com' `
            -From $from `
            -Credential $credencialEnvio

Write-Host "Procedimento concluido"