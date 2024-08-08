# MISE EN PLACE ET INTÉGRATION D’UNE FONCTION LOG DANS LES SCRIPTS:

## En mettant en début de chaque script:

#Definir repertoir des logs
$LogDirectory = "E:\LOGS"
if (-not (Test-Path -path $logDirectory)) {
New-Item -Path $logDirectory -Itemtype Directory
｝

#Nommer le fichier de log avec le nom du script
$scriptname = $(Get-item $PSCommandPath). BaseName
$logFile = "$logDirectory\SscriptName_$(Get-Date -Format ‘yyyyMMdd_HHmmss'). log"

#Rediriger les sorties standards et d'erreur

Start-Transcript -Path $logFile -Append

<img width="847" alt="Capture d’écran 2024-08-07 à 14 36 36" src="https://github.com/user-attachments/assets/745b1389-ff6f-4975-b8ba-5c8988974e97">

Et en conclusion des scripts:
#Fin journalisation
Stop-Transcript

<img width="293" alt="Capture d’écran 2024-08-07 à 14 36 47" src="https://github.com/user-attachments/assets/d6045ecd-475f-4ea8-aedc-2c388191d0b9">


## Explications:
Ce morceau de script nous permet d’enregistrer le fichier log dans un dossier “LOGS” sur le disque partagé “E:\”
Fichier en format “.log”, nommé avec la date et heure de sa création au format “yyyyMMdd_HHmmss”

## CMTrace

Pour une lecture plus lisible de nos fichiers log, nous utilisons CMTrace qui lit les fichier log en “.log” et nous permet d’avoir un affichage comme suit:


### Si CMTrace n’est pas présent sur le server windows, installer le Configuration Manager à l’adresse suivante:
https://www.microsoft.com/en-us/evalcenter/download-microsoft-endpoint-configuration-manager

Dans ce paquet se trouve CMTrace.
### Étapes d'installation:

- Une fois le téléchargement terminé, localisez le fichier CMTrace.exe.
- Copiez le fichier CMTrace.exe dans un dossier sur votre machine locale. Un emplacement courant est C:\Windows\System32, mais vous pouvez le placer où vous préférez.
- (Optionnel) Créez un raccourci vers CMTrace.exe sur votre bureau ou dans votre barre des tâches pour y accéder facilement.
- (Optionnel) Pour associer les fichiers log à CMTrace :
- Faites un clic droit sur un fichier .log
- Choisissez "Ouvrir avec" > "Choisir une autre application"
- Naviguez jusqu'à l'emplacement de CMTrace.exe
- Cochez la case "Toujours utiliser cette application pour ouvrir les fichiers .log"


