# Importer le module ImportExcel si ce n'est pas déjà fait
Install-Module -Name ImportExcel -Force -Scope CurrentUser

# Charger le fichier Excel dans une variable
$users = Import-Excel -Path "C:\chemin\vers\le\fichier\S14_Pharmgreen.xlsx"

foreach ($user in $users) {
    # Vérifier si l'utilisateur existe déjà
    $existingUser = Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'"

    if (!$existingUser) {
        # Si l'utilisateur n'existe pas, le créer
        New-ADUser -Name $user.Name `
                   -GivenName $user.FirstName `
                   -Surname $user.LastName `
                   -SamAccountName $user.SamAccountName `
                   -UserPrincipalName "$($user.SamAccountName)@domaine.com" `
                   -Department $user.Department `
                   -Title $user.Title `
                   -AccountPassword (ConvertTo-SecureString "MotDePasseParDéfaut" -AsPlainText -Force) `
                   -Enabled $true
    }
}

foreach ($user in $users) {
    $existingUser = Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'"

    if ($existingUser) {
        # Modifier les informations de l'utilisateur existant
        Set-ADUser -Identity $existingUser `
                   -Department $user.Department `
                   -Title $user.Title
    }
}

Get-ADUser -Filter "Department -eq 'RH'" | Set-ADUser -Department "Direction des Ressources Humaines"
Get-ADUser -Filter "Department -eq 'Marketing Digital'" | Set-ADUser -Department "e-Marketing"
Get-ADUser -Filter "Department -eq 'Recrutement'" | Set-ADUser -Title "Recruteur RH" -Department "Service Recrutement"

foreach ($user in $users) {
    if ($user.Status -eq "Quitte") {
        # Désactiver l'utilisateur
        Disable-ADAccount -Identity $user.SamAccountName

        # (Optionnel) Déplacer l'utilisateur vers une OU spécifique
        Move-ADObject -Identity $existingUser.DistinguishedName -TargetPath "OU=AnciensEmployés,DC=domaine,DC=com"
    }
}

# Exemples de rapports pour vérifier les comptes modifiés ou désactivés
Get-ADUser -Filter * -Property SamAccountName, Department, Title, Enabled | Export-Csv "C:\chemin\vers\le\rapport\Rapport_AD.csv" -NoTypeInformation

