# Dicionario de IPs
# Ivo Dias

function Dicionario-IPs {
    param (
        [Parameter(Mandatory=$True)]
        $IP
    )
    # Faz a comparacao entre os IPs e os nomes de exibicao que temos
    $nome = "x" # Valor padrao

    # SP
    if ($IP -eq "255.255.255.1") { $nome = "Servidor SP1" }
    if ($IP -eq "255.255.255.2") { $nome = "Servidor SP2" }
    if ($IP -eq "255.255.255.3") { $nome = "Servidor SP3" }

    # BA
    if ($IP -eq "255.255.255.11") { $nome = "Servidor BA1" }
    if ($IP -eq "255.255.255.21") { $nome = "Servidor BA2" }
    if ($IP -eq "255.255.255.31") { $nome = "Servidor BA3" }

    # PR
    if ($IP -eq "255.255.255.12") { $nome = "Servidor PR1" }
    if ($IP -eq "255.255.255.22") { $nome = "Servidor PR2" }
    if ($IP -eq "255.255.255.32") { $nome = "Servidor PR3" }

    # Verifica se o nome esta vazio
    if ($nome -eq "x") {
        $nome = $IP
    } 
    # Retorna o nome
    return $nome
}