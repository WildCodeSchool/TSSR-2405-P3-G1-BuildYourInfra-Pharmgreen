# DOSSIERS PARTAGÉS - Mettre en place des dossiers réseaux pour les utilisateurs
## 1. Stockage des données sur un volume spécifique de l'AD

Sur le proxmox, dans les réglages matériel créer un disque dur.

<img width="589" alt="Capture d’écran 2024-07-30 à 16 34 48" src="https://github.com/user-attachments/assets/8ba41d9e-e2db-445f-b68f-dd96244cc892">


Sur le serveur, aller dans le menu suivant: 
	*Tools> computer components> Storage management>Disk*
Et initialiser le nouveau disque dur, et le paramétrer pour qu’il soit en partagé.

<img width="224" alt="Capture d’écran 2024-07-30 à 20 55 30" src="https://github.com/user-attachments/assets/f5220975-bc21-4b04-8ea5-73cebcdfe82d">


##	2. Sécurité de partage des dossiers par groupe AD

À l’aide du script en annexe, Scriptcreationdossiers.ps1, et le fichier excel contenant les information utilisateur, et leurs services et départements, l’arborescence de dossiers “individuels” “ services” et “départements” vont se créer.

Par la suite, nous allons dans les propriétés des différents sous dossiers, et nous modifions les droits pour y ajouter les groupes AD correspondants.

<img width="228" alt="Capture d’écran 2024-07-30 à 20 55 04" src="https://github.com/user-attachments/assets/8d6c20d2-9499-4419-a787-43b553e4c7b8">


## 3. Mappage des lecteurs sur les clients par GPO ou script ou paramétrage de profil utilisateur
	

Après avoir créé une GPO “mappage”, et l'avoir paramétré comme suit:

<img width="641" alt="Capture d’écran 2024-07-30 à 20 56 31" src="https://github.com/user-attachments/assets/6164fcc9-e6d6-44b2-b155-eeac95d85745">

Naviguer dans le menu:

*User Configuration > Preferences > Windows Settings > Drive Maps*

Ensuite faites *Nouveau> Lecteur mappé*

Une fenetre souvrirera, il faut la configurer comme suit:

<img width="246" alt="Capture d’écran 2024-07-30 à 20 56 50" src="https://github.com/user-attachments/assets/64187e28-5b01-4d46-8088-e0ab06622867">


Chaque utilisateur sera donc paramétré selon les arguments suivants :
		1. Un **dossier individuel**, avec une lettre de mappage réseau **I**, accessible uniquement par cet utilisateur
		2. Un **dossier de service**, avec une lettre de mappage réseau **M**, accessible par tous les utilisateurs d'un même service.
		3. Un **dossier de département**, avec une lettre de mappage **N**, accessible par tous les utilisateurs d'un même département.


#  Configurer un RAID 1 sous Windows Server Core:

## Ouvrir une session PowerShell

### Vérifier les disques disponibles avec la commande suivante:
*Get-Disk*

<img width="1107" alt="Capture d’écran 2024-08-03 à 11 24 27" src="https://github.com/user-attachments/assets/51a78507-a0aa-4d1b-b472-85e90a31c58b">


Noter les numéros des disques que nous utiliserons pour le RAID 1 (ici 0 et 1).

### Initialiser les disques avec la commande suivante:

*Initialize-Disk -Number 1*

*Initialize-Disk -Number 2*

### Convertir les disques en disques dynamiques, en utilisans *diskpart*:

*diskpart*

*DISKPART> select disk 1*

*DISKPART> convert dynamic*

*DISKPART> select disk 2*

*DISKPART> convert dynamic*

*DISKPART> exit*

<img width="844" alt="Capture d’écran 2024-08-03 à 11 26 56" src="https://github.com/user-attachments/assets/7158554b-e66d-4102-af9e-39d874d0b284">


### Mettre le volume en miroir (RAID 1) : Utiliser *diskpart* pour créer un volume en miroir :

*diskpart*

*DISKPART> select disk 1*

*DISKPART> create volume mirror disk=1,2*

*DISKPART> assign letter=E*

*DISKPART> exit*

<img width="708" alt="Capture d’écran 2024-08-03 à 11 28 40" src="https://github.com/user-attachments/assets/579ca7c5-caf2-46a6-b6c0-b2aadbf110b7">


### Formater le volume en NTFS :

*Format-Volume -DriveLetter E -FileSystem NTFS -NewFileSystemLabel "RAID1Volume"*

<img width="1097" alt="Capture d’écran 2024-08-03 à 11 30 47" src="https://github.com/user-attachments/assets/45011098-b246-4acd-ae15-feea515c7787">


### Vérifier la configuration :
*Get-Volume*

<img width="1096" alt="Capture d’écran 2024-08-03 à 11 31 24" src="https://github.com/user-attachments/assets/b12cd646-52ac-4f7d-a7fe-984590f38568">

## Faire une sauvegarde avec WBADMIN

### Installer WBADMIN

*Install-WindowsFeature Windows-Server-Backup*

### Lancer la sauvegarde

*wbadmin start backup -backupTarget:E: -include:C: -allCritical -quiet*

## Reparamétrer le bootloader

### Insérer le disque iso dans le lecteur 

### Choisir "Réparer votre ordinateur" dans l'écran d'installation de Windows Server.

### Sélectionner "Dépannage" puis "Invite de commandes".

### Taper les commandes suivantes pour récuperer la sauvegarde

*wbadmin get versions -backupTarget:D:*

*wbadmin start recovery -version:<VersionIdentifier> -itemType:Volume -items:C: -recoveryTarget:E: -quiet

### Après avoir restaurer la sauvegarde tapez les commandes ci-dessous pour réparer le bootloader

*bootrec /fixmbr*
*bootrec /fixboot*
*bootrec /scanos*
*bootrec /rebuildbcd*

### Redémarrez le serveur et configurez le BIOS/UEFI pour démarrer à partir du nouveau disque.



