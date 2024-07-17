# Chargement du fichier de configuration
$config = Import-Csv -Delimiter '=' -Path 'config.txt' | foreach { $obj = @{}; $obj[$_.ServerName] = $_.IPAddress; $obj }

# Définition des variables à partir du fichier de configuration
$serverName = $config['ServerName']
$ipAddress = $config['IPAddress']
$subnetMask = $config['SubnetMask']
$gateway = $config['Gateway']
$dns = $config['DNS']
$domainName = $config['DomainName']
$domainAdminUser = $config['DomainAdminUser']
$domainAdminPassword = $config['DomainAdminPassword']

# Définition des informations d'identification pour l'administrateur de domaine
$secPassword = ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force
$domainAdminCred = New-Object System.Management.Automation.PSCredential ($domainAdminUser, $secPassword)

# Configuration des paramètres réseau
Write-Host "Configuration des paramètres réseau..."
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $gateway
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dns

# Renommage du serveur
Write-Host "Renommage du serveur en $serverName..."
Rename-Computer -NewName $serverName -Force -Restart

# Attente du redémarrage du serveur
Start-Sleep -Seconds 60

# Installation des fonctionnalités nécessaires
Write-Host "Installation du rôle AD-DS..."
Install-WindowsFeature AD-Domain-Services

# Promotion du serveur en tant que contrôleur de domaine
Write-Host "Promotion du serveur en tant que contrôleur de domaine..."
Import-Module ADDSDeployment
Install-ADDSDomainController `
    -DomainName $domainName `
    -InstallDns `
    -Credential $domainAdminCred `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -NoRebootOnCompletion `
    -Force

# Rejoindre le domaine
Write-Host "Rejoindre le domaine $domainName..."
Add-Computer -DomainName $domainName -Credential $domainAdminCred -Force -Restart

Write-Host "Script terminé. Le serveur va redémarrer."
