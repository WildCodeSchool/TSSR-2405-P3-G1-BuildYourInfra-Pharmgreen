
#Definir repertoir des logs

$LogDirectory = "E:\LOGS" if (-not (Test-Path -path $logDirectory)) { New-Item -Path $logDirectory -Itemtype Directory ｝

#Nommer le fichier de log avec le nom du script

$ScriptName = (Get-item $PSCommandPath). BaseName $LogFile = "$logDirectory\SscriptName_$(Get-Date -Format ‘yyyyMMdd_HHmmss'). log"

#Rediriger les sorties standards et d'erreur

Start-Transcript -Path $logFile -Append
 
 # Importer les modules nécessaires
Import-Module ActiveDirectory
Import-Module ImportExcel

# Définir le chemin du fichier Excel
$excelFilePath = "C:\Users\Administrator\Downloads\S5_Pharmgreen.xlsx"

# Charger les données du fichier Excel
$usersData = Import-Excel -Path $excelFilePath

# Dictionnaires pour gérer les changements de noms de départements et services
$departmentChanges = @{
    "RH" = "Direction des Ressources Humaines"
}
$serviceChanges = @{
    "Marketing Digital" = "e-Marketing"
    "Recrutement" = "Service Recrutement"
}
$functionChanges = @{
    "Recrutement" = "Recruteur RH"
}

# Liste des utilisateurs dans l'AD pour vérifier ceux qui ne sont plus dans le fichier
$existingUsers = Get-ADUser -Filter * -Properties SamAccountName, GivenName, Surname, DistinguishedName, Department, Title, OfficePhone, MobilePhone

# Créer une liste des utilisateurs dans le fichier Excel pour référence
$excelUsers = $usersData | ForEach-Object { 
    $userSamAccountName = ($_.Prénom.Substring(0,1) + $_.Nom).ToUpper()
    [PSCustomObject]@{
        SamAccountName = $userSamAccountName
        GivenName = $_.'Prénom'
        Surname = $_.'Nom'
        Nomadism = $_.'Nomadisme'
    }
}

# Parcourir les données utilisateurs du fichier Excel
foreach ($user in $usersData) {
    # Extraire les informations
    $firstName = $user.'Prénom'
    $lastName = $user.'Nom'
    $company = $user.'Société'
    $site = $user.'Site'
    $department = $user.'Département'
    $service = $user.'Service'
    $jobTitle = $user.'Fonction'
    $managerFirstName = $user.'Manager - prénom'
    $managerLastName = $user.'Manager - nom'
    $phone = $user.'Téléphone fixe'
    $mobilePhone = $user.'Téléphone portable'
    $nomadism = $user.'Nomadisme'

    # Appliquer les changements de département, service et fonction si non nul
    if ($department -and $departmentChanges.ContainsKey($department)) {
        $department = $departmentChanges[$department]
    }
    if ($service -and $serviceChanges.ContainsKey($service)) {
        $service = $serviceChanges[$service]
    }
    if ($service -and $functionChanges.ContainsKey($service)) {
        $jobTitle = $functionChanges[$service]
    }

    # Générer le nom de compte utilisateur (SamAccountName)
    $samAccountName = ($firstName.Substring(0,1) + $lastName).ToUpper()

    # Générer le UserPrincipalName
    $userPrincipalName = "$samAccountName@$company.com"

    # Déterminer l'OU Path en fonction du statut de nomade
    if ($nomadism -eq "oui") {
        $ouPath = "OU=EXTERNE,OU=PG_Users,OU=PG_Lyon,OU=PG_France,DC=pharmgreen,DC=com"
    } else {
        $ouPath = "OU=$department,OU=PG_Users,OU=PG_Lyon,OU=PG_France,DC=pharmgreen,DC=com"
    }

    # Chercher si l'utilisateur existe déjà dans l'AD, même s'il a changé de nom
    $existingUser = Get-ADUser -Filter { 
        (SamAccountName -eq $samAccountName) -or
        ((GivenName -eq $firstName) -and (Surname -like "$lastName*"))
    } -Properties SamAccountName, GivenName, Surname, DistinguishedName, Department, Title, OfficePhone, MobilePhone

    if ($existingUser) {
        # Si l'utilisateur existe, mettre à jour les informations si elles ont changé
        $updates = @{}
        if ($existingUser.GivenName -ne $firstName) { $updates['GivenName'] = $firstName }
        if ($existingUser.Surname -ne $lastName) { $updates['Surname'] = $lastName }
        if ($existingUser.Department -ne $department) { $updates['Department'] = $department }
        if ($existingUser.Title -ne $jobTitle) { $updates['Title'] = $jobTitle }
        if ($existingUser.OfficePhone -ne $phone) { $updates['OfficePhone'] = $phone }
        if ($existingUser.MobilePhone -ne $mobilePhone) { $updates['MobilePhone'] = $mobilePhone }
        
        if ($updates.Count -gt 0) {
            Write-Host "Mise à jour de l'utilisateur $($existingUser.SamAccountName)"
            Set-ADUser -Identity $existingUser.SamAccountName @updates
        }

        # Déterminer l'OU actuelle de l'utilisateur et le déplacer si nécessaire
        $currentOU = ($existingUser.DistinguishedName -split ',OU=')[1].Split(',')[0]
        if ($nomadism -eq "oui") {
            $newOUPath = "OU=EXTERNE,OU=PG_Users,OU=PG_Lyon,OU=PG_France,DC=pharmgreen,DC=com"
        } else {
            $newOUPath = "OU=$department,OU=PG_Users,OU=PG_Lyon,OU=PG_France,DC=pharmgreen,DC=com"
        }

        if ($currentOU -ne "EXTERNE" -and $newOUPath -ne ($existingUser.DistinguishedName -split ',')[1]) {
            Write-Host "Déplacement de l'utilisateur $($existingUser.SamAccountName) vers $newOUPath"
            Move-ADObject -Identity $existingUser.DistinguishedName -TargetPath $newOUPath
        }
    } else {
        try {
            Write-Host "Création de l'utilisateur $userPrincipalName dans $ouPath"

            New-ADUser `
                -GivenName $firstName `
                -Surname $lastName `
                -Name "$firstName $lastName" `
                -UserPrincipalName $userPrincipalName `
                -SamAccountName $samAccountName `
                -Company $company `
                -Department $department `
                -Title $jobTitle `
                -OfficePhone $phone `
                -MobilePhone $mobilePhone `
                -Manager (Get-ADUser -Filter { GivenName -eq $managerFirstName -and Surname -eq $managerLastName }).DistinguishedName `
                -Path $ouPath `
                -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) `
                -Enabled $true
        } catch {
            Write-Host "Erreur lors de la création de l'utilisateur $userPrincipalName : $_"
        }
    }
}

# Désactiver les utilisateurs qui ne sont plus dans le fichier Excel, en tenant compte des changements de noms
$usersToCheck = $existingUsers | Where-Object { 
    $_.SamAccountName -ne 'Administrator' -and
    ($excelUsers.SamAccountName -notcontains $_.SamAccountName)
}

foreach ($user in $usersToCheck) {
    Write-Host "Désactivation de l'utilisateur $($user.SamAccountName)"
    Disable-ADAccount -Identity $user.SamAccountName
}
# Importer les modules nécessaires
Import-Module ActiveDirectory
Import-Module ImportExcel

# Définir le chemin du fichier Excel
$excelFilePath = "C:\Users\Administrator\Downloads\S5_Pharmgreen.xlsx"

# Charger les données du fichier Excel
$usersData = Import-Excel -Path $excelFilePath

# Dictionnaires pour gérer les changements de noms de départements et services
$departmentChanges = @{
    "RH" = "Direction des Ressources Humaines"
}
$serviceChanges = @{
    "Marketing Digital" = "e-Marketing"
    "Recrutement" = "Service Recrutement"
}
$functionChanges = @{
    "Recrutement" = "Recruteur RH"
}

# Liste des utilisateurs dans l'AD pour vérifier ceux qui ne sont plus dans le fichier
$existingUsers = Get-ADUser -Filter * -Properties SamAccountName, GivenName, Surname, DistinguishedName, Department, Title, OfficePhone, MobilePhone

# Créer une liste des utilisateurs dans le fichier Excel pour référence
$excelUsers = $usersData | ForEach-Object { 
    $userSamAccountName = ($_.Prénom.Substring(0,1) + $_.Nom).ToUpper()
    [PSCustomObject]@{
        SamAccountName = $userSamAccountName
        GivenName = $_.'Prénom'
        Surname = $_.'Nom'
        Nomadism = $_.'Nomadisme'
    }
}

# Parcourir les données utilisateurs du fichier Excel
foreach ($user in $usersData) {
    # Extraire les informations
    $firstName = $user.'Prénom'
    $lastName = $user.'Nom'
    $company = $user.'Société'
    $site = $user.'Site'
    $department = $user.'Département'
    $service = $user.'Service'
    $jobTitle = $user.'Fonction'
    $managerFirstName = $user.'Manager - prénom'
    $managerLastName = $user.'Manager - nom'
    $phone = $user.'Téléphone fixe'
    $mobilePhone = $user.'Téléphone portable'
    $nomadism = $user.'Nomadisme'

    # Appliquer les changements de département, service et fonction si non nul
    if ($department -and $departmentChanges.ContainsKey($department)) {
        $department = $departmentChanges[$department]
    }
    if ($service -and $serviceChanges.ContainsKey($service)) {
        $service = $serviceChanges[$service]
    }
    if ($service -and $functionChanges.ContainsKey($service)) {
        $jobTitle = $functionChanges[$service]
    }

    # Générer le nom de compte utilisateur (SamAccountName)
    $samAccountName = ($firstName.Substring(0,1) + $lastName).ToUpper()

    # Générer le UserPrincipalName
    $userPrincipalName = "$samAccountName@$company.com"

    # Déterminer l'OU Path en fonction du statut de nomade
    if ($nomadism -eq "oui") {
        $ouPath = "OU=EXTERNE,OU=PG_Users,OU=PG_Lyon,OU=PG_France,DC=pharmgreen,DC=com"
    } else {
        $ouPath = "OU=$department,OU=PG_Users,OU=PG_Lyon,OU=PG_France,DC=pharmgreen,DC=com"
    }

    # Chercher si l'utilisateur existe déjà dans l'AD, même s'il a changé de nom
    $existingUser = Get-ADUser -Filter { 
        (SamAccountName -eq $samAccountName) -or
        ((GivenName -eq $firstName) -and (Surname -like "$lastName*"))
    } -Properties SamAccountName, GivenName, Surname, DistinguishedName, Department, Title, OfficePhone, MobilePhone

    if ($existingUser) {
        # Si l'utilisateur existe, mettre à jour les informations si elles ont changé
        $updates = @{}
        if ($existingUser.GivenName -ne $firstName) { $updates['GivenName'] = $firstName }
        if ($existingUser.Surname -ne $lastName) { $updates['Surname'] = $lastName }
        if ($existingUser.Department -ne $department) { $updates['Department'] = $department }
        if ($existingUser.Title -ne $jobTitle) { $updates['Title'] = $jobTitle }
        if ($existingUser.OfficePhone -ne $phone) { $updates['OfficePhone'] = $phone }
        if ($existingUser.MobilePhone -ne $mobilePhone) { $updates['MobilePhone'] = $mobilePhone }
        
        if ($updates.Count -gt 0) {
            Write-Host "Mise à jour de l'utilisateur $($existingUser.SamAccountName)"
            Set-ADUser -Identity $existingUser.SamAccountName @updates
        }

        # Déterminer l'OU actuelle de l'utilisateur et le déplacer si nécessaire
        $currentOU = ($existingUser.DistinguishedName -split ',OU=')[1].Split(',')[0]
        if ($nomadism -eq "oui") {
            $newOUPath = "OU=EXTERNE,OU=PG_Users,OU=PG_Lyon,OU=PG_France,DC=pharmgreen,DC=com"
        } else {
            $newOUPath = "OU=$department,OU=PG_Users,OU=PG_Lyon,OU=PG_France,DC=pharmgreen,DC=com"
        }

        if ($currentOU -ne "EXTERNE" -and $newOUPath -ne ($existingUser.DistinguishedName -split ',')[1]) {
            Write-Host "Déplacement de l'utilisateur $($existingUser.SamAccountName) vers $newOUPath"
            Move-ADObject -Identity $existingUser.DistinguishedName -TargetPath $newOUPath
        }
    } else {
        try {
            Write-Host "Création de l'utilisateur $userPrincipalName dans $ouPath"

            New-ADUser `
                -GivenName $firstName `
                -Surname $lastName `
                -Name "$firstName $lastName" `
                -UserPrincipalName $userPrincipalName `
                -SamAccountName $samAccountName `
                -Company $company `
                -Department $department `
                -Title $jobTitle `
                -OfficePhone $phone `
                -MobilePhone $mobilePhone `
                -Manager (Get-ADUser -Filter { GivenName -eq $managerFirstName -and Surname -eq $managerLastName }).DistinguishedName `
                -Path $ouPath `
                -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) `
                -Enabled $true
        } catch {
            Write-Host "Erreur lors de la création de l'utilisateur $userPrincipalName : $_"
        }
    }
}

# Désactiver les utilisateurs qui ne sont plus dans le fichier Excel, en tenant compte des changements de noms
$usersToCheck = $existingUsers | Where-Object { 
    $_.SamAccountName -ne 'Administrator' -and
    ($excelUsers.SamAccountName -notcontains $_.SamAccountName)
}

foreach ($user in $usersToCheck) {
    Write-Host "Désactivation de l'utilisateur $($user.SamAccountName)"
    Disable-ADAccount -Identity $user.SamAccountName
}
# Fin Journalisation
Stop-Transcript
