
## Création d'un Serveur Windows Server 2022 GUI avec AD-DS, DHCP, et DNS

### Pré-requis
- **ISO Windows Server 2022** ou un accès à un serveur Windows Server 2022 sur Proxmox..

### Étapes de Configuration

#### A. Installation des Rôles AD-DS, DHCP et DNS

1. **Ouvrez Server Manager**.

![Capture d'écran 2024-07-12 105838](https://github.com/user-attachments/assets/898264bf-f831-4bde-bb9b-e2c9eb3cbc70)

2. Cliquez sur `Manage` puis sur `Add Roles and Features`.

![Capture d'écran 2024-07-12 105846](https://github.com/user-attachments/assets/338964b7-f0a3-42b5-accf-450a22c2ff17)


3. Cliquez sur `Next` jusqu'à arriver à la sélection du serveur. Assurez-vous que votre serveur est sélectionné, puis cliquez sur `Next`.

4. **Sélection des Rôles**:
   - Cochez `Active Directory Domain Services`.
     - Une fenêtre pop-up apparaîtra pour ajouter les fonctionnalités requises. Cliquez sur `Add Features`.
   - Cochez `DHCP Server`.
     - Une fenêtre pop-up apparaîtra pour ajouter les fonctionnalités requises. Cliquez sur `Add Features`.
   - Cochez `DNS Server`.
     - Une fenêtre pop-up apparaîtra pour ajouter les fonctionnalités requises. Cliquez sur `Add Features`.

 ![Capture d'écran 2024-07-12 111257](https://github.com/user-attachments/assets/9f1c436b-ea1a-4ee8-ab2d-7b35369d0f6c)

5. Cliquez sur `Next` pour passer à la section `Features`. Cliquez encore sur `Next` car aucune fonctionnalité additionnelle n'est nécessaire.
6. Cliquez sur `Next` pour passer les sections `AD DS`, `DHCP Server` et `DNS Server`, puis sur `Install`.

#### B. Configuration du Contrôleur de Domaine (AD-DS)

1. Après l'installation des rôles, un **notification flag** apparaîtra en haut de Server Manager. Cliquez dessus, puis sur `Promote this server to a domain controller`.

![Capture d'écran 2024-07-12 105934](https://github.com/user-attachments/assets/2c4e5163-4149-49c0-b0b7-34a9353b6531)

2. Dans la fenêtre `Deployment Configuration`:
   - Sélectionnez `Add a new forest`.
   - Entrez le nom de domaine racine (ex: `pharmgreen.com`), puis cliquez sur `Next`.
  
![Capture d'écran 2024-07-12 105941](https://github.com/user-attachments/assets/8a65be71-96e4-4b39-b97d-65421e9f73ec)

3. Configurez les options de domaine et entrez un **mot de passe DSRM**.

![Capture d'écran 2024-07-12 105950](https://github.com/user-attachments/assets/3fa7061a-8a7f-4c0d-85e4-94eb5ee16a7c)

4. Vérifiez les options suivantes et cliquez sur `Next` jusqu'à `Install` .

Le serveur redémarrera après l'installation du rôle AD-DS et la promotion au contrôleur de domaine.

#### C. Configuration du Serveur DHCP

1. Ouvrez `Server Manager`.
2. Cliquez sur `DHCP` dans le volet de gauche.

![Capture d'écran 2024-07-12 112314](https://github.com/user-attachments/assets/ed5fcb8c-1b31-4218-96d0-c73d344dcb8e)

4. Cliquez sur `More` dans le panneau de notifications, puis sur `Complete DHCP Configuration`.
5. Suivez l'assistant de configuration pour autoriser le serveur DHCP et créer les étendues nécessaires.

#### D. Configuration du Serveur DNS

1. Ouvrez `DNS Manager` depuis `Server Manager` ou en tapant `dnsmgmt.msc` dans la barre de recherche.

![Capture d'écran 2024-07-12 113231](https://github.com/user-attachments/assets/76c08333-c6dd-45eb-a782-40b8c28dad88)

2. Configurez les zones de recherche directe et inverse selon vos besoins


## Installation du serveur Windows Core et configuration en Domain Controller

### 1. Prérequis:

#### A- Virtualiseur

Il faut Proxmox VE sur lequel seront installées toutes nos machines.

#### B- Windows Core

Il faut un ISO Windows Server 2022 CORE 

### 2. Créer la VM 

#### A- Choix de l'iso

Dans Proxmox, créer la VM en choisissant l’ISO Windows Server 2022 CORE, et en lui allouant le nombre de coeurs et de RAM nécessaires à l’exercice (ici 2 coeurs et 4 Go de RAM).

#### B- Premier lancement

Au lancement de la VM, suivre les instructions d'installation.

#### C- Configurer une IP statique

- Changer le nom de la machine en utilisant la commande `sconfig` et en selectionnant l'option `Computer Name`

- Configurer l'adresse statique via `Network Settings` en tapant `8` 

![Capture d'écran 2024-07-12 113538](https://github.com/user-attachments/assets/f9edbf02-3eb6-41b2-b933-34db72dae0f7)

- Mettez la carte réseau que vous voulez configurer ( ici `1` )

![Capture d'écran 2024-07-12 113555](https://github.com/user-attachments/assets/f0ebef93-e604-46e4-8868-c2744b9ede6b)

- Mettez à présent  les configurations IP suivantes :

![Capture d'écran 2024-07-12 113705](https://github.com/user-attachments/assets/7171c1fe-79ed-4a02-aeea-26b1e970e91d)

#### F- Rejoindre l’Active Directory

Installer les fonctionnalités suivantes qui sont necessaire à la préparation de ce serveur en controleur de domaine :

- RSAT-AD-Tools : Outils d'administration graphique
- AD-Domain-Services : Services de domaine Active Directory
- DNS

- Avant d'aller d'en Powershell , d'être en mode root/administateur avant de faire les commandes suivantes :

- A présent, dans le menu de Windows Core tapez `15` pour accéder à Powershell : 

![Capture d'écran 2024-07-12 114711](https://github.com/user-attachments/assets/c4cba65b-fe0b-4061-a659-c3ad0ac682a4)

- Voici les commandes nécessaires :

`Add-WindowsFeature -Name "RSAT-AD-Tools" -IncludeManagementTools -IncludeAllSubFeature`

`Add-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools -IncludeAllSubFeature`

`Add-WindowsFeature -Name "DNS" -IncludeManagementTools -IncludeAllSubFeature`

- Promouvoir le serveur en Domaine Controller en utilisant la commande suivante :

`Install-ADDSDomainController -InstallDns -Credential (Get-Credential <DomainName\Administrator>) -DomainName <Domaine> -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "<Administrator Password>" -Force)`

(Remplacer "<Domaine\Administrator>" et "<"Domaine">" par vos valeurs)

- Le mot de passe Administrateur de votre Controller AD vous sera demandé.

- Le Serveur Core est maintenant configuré comme Domaine Controller 



---
## Installation du serveur Debian

### 1. Prérequis:

#### A- Virtualiseur

Il faut Proxmox VE sur lequel seront installées toutes nos machines.

#### B- Debian

Il faut un ISO Debian téléchargé depuis le site officiel: [debian.org](https://www.debian.org/index.fr.html).

### 2. Créer la VM 

#### A- Choix de l'iso

Dans Proxmox, créer la VM en choisissant l’ISO Debian, et en lui allouant le nombre de coeurs et de RAM nécessaires à l’exercice (ici 2 coeurs et 4 Go de RAM).

#### B- Premier lancement

Au lancement de la VM, choisir une installation sans interface graphique. Suivre les instructions.

#### C- Configurer une IP statique

- Changer le nom de la machine

- Configurer l'adresse statique via /etc/network/interfaces

#### D- Rejoindre l’Active Directory

Utiliser la commande: `realm join -v domain`

Pour nous, cela serait : `realm join -v pharmgreen.com`

Vérifier sur l’Active Directory que la machine est bien ajoutée.

#### E- Configurer un tunnel SSH

- Cocher "Serveur SSH" en appuyant sur la touche espace.

- Installer openssh-server avec la commande `apt install openssh-server`

Une fois l’installation finie, vérifier avec les commandes suivantes:
- Si le paquet est installé: `dpkg -l | grep openssh-server`
- Si le serveur SSH est actif: `sudo systemctl status ssh`

Ensuite, se connecter à l’aide de Putty ou de la commande `ssh <Username>@<Domaine>` depuis une machine Windows.


