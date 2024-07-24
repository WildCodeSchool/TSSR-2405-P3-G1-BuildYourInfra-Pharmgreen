# Importer le fichier de configuration
$config = Get-Content -Path "config.txt" | ForEach-Object {
    $key, $value = $_ -split '='
    [PSCustomObject]@{Key = $key; Value = $value}
} | Group-Object -Property Key | ForEach-Object {
    $obj = New-Object PSObject -Property @{
        Key = $_.Name
        Value = ($_.Group | Select-Object -First 1).Value
    }
    $obj.PSObject.Properties.Remove("Group")
    $obj
}

# Convertir les paramètres de configuration en variables
foreach ($item in $config) {
    Set-Variable -Name $item.Key -Value $item.Value
}

# Convertir InstallDNS en booléen
$InstallDNS = [System.Convert]::ToBoolean($InstallDNS)

# Installer la fonctionnalité AD DS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Importer le module AD DS
Import-Module ADDSDeployment

# Créer le domaine
$SafeModeAdminPassword = ConvertTo-SecureString $SafeModeAdminPassword -AsPlainText -Force

Install-ADDSForest `
    -DomainName $DomainName `
    -SafeModeAdministratorPassword $SafeModeAdminPassword `
    -InstallDNS:$InstallDNS `
    -DomainNetbiosName $DomainNetbiosName `
    -Force


