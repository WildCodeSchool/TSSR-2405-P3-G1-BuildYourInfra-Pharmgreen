---
# Build Your Infra - Pharmgreen
---

<p align="center">
<img align="center" src="https://github.com/WildCodeSchool/TSSR-2405-P3-G2-BuildYourInfra-Pharmgreen/blob/main/S9/Annexes/Logo_PG.png">

Mettre en place une infrastructure réseau pour la société **Pharmgreen**
</p>


---

## État des lieux


- La société comprend actuellement 189 personnes réparties dans 10 départements.
Des personnels extérieurs sont inclus.

- Une partie du département Ventes et Développement Commercial est nomade.
Pas de télétravail pour le reste de la société.

- 100 % de PC portables.

- Aucun serveur ni matériel réseau.

- Pour les utilisateurs interne, réseau en wifi fourni par une box FAI et des répéteurs wifi.

- En nomadisme, utilisation des smartphones personnels pour être en 4G.

- La messagerie est hébergée en cloud.

- Le stockage de données se fait en local sur les machines.

---

## Analyse des besoins

- Schéma du réseau envisagé
- Matériel envisagé
- Mise en place d'une nomenclature Active Directory pour standardisation

---

### Réseau envisagé

![Plan_réseau](https://github.com/WildCodeSchool/TSSR-2405-P3-G2-BuildYourInfra-Pharmgreen/blob/main/S9/Annexes/Réseau_Pharmgreen.png)

---

### Arborescence Active Directory

![Plan_réseau](https://github.com/WildCodeSchool/TSSR-2405-P3-G2-BuildYourInfra-Pharmgreen/blob/main/S9/Annexes/ArboAD_PG.png)

---

### Gestion de l'arborescence AD

Un fichier .xlsx [(AD_Pharmgreen.xlsx)](https://github.com/WildCodeSchool/TSSR-2405-P3-G2-BuildYourInfra-Pharmgreen/blob/main/S9/Annexes/AD_Pharmgreen.xlsx) a été utilisé pour importer les unités organisationnelles, les groupes de sécurité ainsi que les collaborateurs de la société, à l'aide de 3 scripts:

a. **Création des OU**

```
Import-Module ActiveDirectory
Import-Module ImportExcel

$domain = "DC=pharmgreen,DC=com"
$excel = "C:\Users\Administrator\Desktop\Scripts\AD_Pharmgreen.xlsx"
$OU1s = @("PG_Users", "PG_Computers", "PG_Groups")
$data = Import-Excel -Path $excel
$units = $data.Unit | Sort-Object -Unique
$groups = $data.Groupe |Sort-Object -Unique

foreach ($ou1 in $OU1s) {
    New-ADOrganizationalUnit -Name $ou1 -Path $domain -ProtectedFromAccidentalDeletion $false
}

foreach ($unit in $units) {
    foreach ($ou1 in $OU1s) {
    New-ADOrganizationalUnit -Name $unit -Path "OU=$ou1, $domain" -ProtectedFromAccidentalDeletion $false
    }
}
```

b. **Création des groupes de sécurité**

```
Import-Module ActiveDirectory
Import-Module ImportExcel

$domain = "DC=pharmgreen,DC=com"
$excel = "C:\Users\Administrator\Desktop\Scripts\AD_Pharmgreen.xlsx"
$data = Import-Excel -Path $excel 

foreach ($row in $data) {
    New-ADGroup -Name "GRP-$($row.Unit)-$($row.Groupe)" -GroupCategory Security -GroupScope Global -Path "ou=$($row.Unit),ou=PG_Groups,$domain" -ErrorAction Stop
}
```

c. **Import des utilisateurs**

```
Import-Module ActiveDirectory
Import-Module ImportExcel

$domain = "DC=pharmgreen,DC=com"
$excel = "C:\Users\Administrator\Desktop\Scripts\AD_Pharmgreen.xlsx"
$data = Import-Excel -Path $excel
$defaultPassword = "Banane123*"


foreach ($row in $data) {
    $username = $row.Userlogonname

    $userProps = @{
        SamAccountName = $username
        UserPrincipalName = "$username@$domain"
        Name = "$($row.Firstname) $($row.Lastname)"
        GivenName = $row.Firstname
        Surname = $row.Lastname
        DisplayName = "$($row.Firstname) $($row.Lastname)"
        Department = $row.Department
        Title = $row.'Job Title'
        City = $row.City
        Company = $row.Company
        Office = $row.City
        EmailAddress = $row.Email
        OfficePhone = $row.'Telephone number'
        MobilePhone = $row.Mobile
        Path = "OU=$($row.Unit),OU=PG_Users,$domain"
        AccountPassword = ConvertTo-SecureString $defaultPassword -AsPlainText -Force
        Enabled = $true
        ChangePasswordAtLogon = $true
    }
   
    New-ADUser @userProps

}
```

![AD_Users](https://github.com/WildCodeSchool/TSSR-2405-P3-G2-BuildYourInfra-Pharmgreen/blob/main/S9/Annexes/PG_AD_Users.png)
