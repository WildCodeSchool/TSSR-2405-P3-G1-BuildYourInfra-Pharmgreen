
## Création d'un Serveur Windows Server 2022 GUI avec AD-DS, DHCP, et DNS

### Pré-requis
- **ISO Windows Server 2022** ou un accès à un serveur Windows Server 2022 sur Proxmox..

### Étapes de Configuration

#### A. Installation des Rôles AD-DS, DHCP et DNS

1. **Ouvrez Server Manager**.
2. Cliquez sur `Manage` puis sur `Add Roles and Features`.
3. Cliquez sur `Next` jusqu'à arriver à la sélection du serveur. Assurez-vous que votre serveur est sélectionné, puis cliquez sur `Next`.
4. **Sélection des Rôles**:
   - Cochez `Active Directory Domain Services`.
     - Une fenêtre pop-up apparaîtra pour ajouter les fonctionnalités requises. Cliquez sur `Add Features`.
   - Cochez `DHCP Server`.
     - Une fenêtre pop-up apparaîtra pour ajouter les fonctionnalités requises. Cliquez sur `Add Features`.
   - Cochez `DNS Server`.
     - Une fenêtre pop-up apparaîtra pour ajouter les fonctionnalités requises. Cliquez sur `Add Features`.
5. Cliquez sur `Next` pour passer à la section `Features`. Cliquez encore sur `Next` car aucune fonctionnalité additionnelle n'est nécessaire.
6. Cliquez sur `Next` pour passer les sections `AD DS`, `DHCP Server` et `DNS Server`, puis sur `Install`.

#### B. Configuration du Contrôleur de Domaine (AD-DS)

1. Après l'installation des rôles, un **notification flag** apparaîtra en haut de Server Manager. Cliquez dessus, puis sur `Promote this server to a domain controller`.
2. Dans la fenêtre `Deployment Configuration`:
   - Sélectionnez `Add a new forest`.
   - Entrez le nom de domaine racine (ex: `example.com`), puis cliquez sur `Next`.
3. Configurez les options de domaine et entrez un **mot de passe DSRM**.
4. Continuez avec les paramètres par défaut pour `Additional Options` et `Paths`.
5. Vérifiez les options dans `Review Options` et cliquez sur `Next`.
6. Vérifiez la **vérification de la configuration requise** puis cliquez sur `Install`.

Le serveur redémarrera après l'installation du rôle AD-DS et la promotion au contrôleur de domaine.

#### C. Configuration du Serveur DHCP

1. Ouvrez `Server Manager`.
2. Cliquez sur `DHCP` dans le volet de gauche.
3. Cliquez sur `More` dans le panneau de notifications, puis sur `Complete DHCP Configuration`.
4. Suivez l'assistant de configuration pour autoriser le serveur DHCP et créer les étendues nécessaires.

#### D. Configuration du Serveur DNS

1. Ouvrez `DNS Manager` depuis `Server Manager` ou en tapant `dnsmgmt.msc` dans la barre de recherche.
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

- Configurer l'adresse statique via `Network Settings`, la passerelle par défaut et mettre en DNS l'adresse du serveur AD principal

#### F- Rejoindre l’Active Directory

Installer les fonctionnalités suivantes qui sont necessaire à la préparation de ce serveur en controleur de domaine :

- RSAT-AD-Tools : Outils d'administration graphique
- AD-Domain-Services : Services de domaine Active Directory
- DNS

Voici les commandes nécessaires :

`Add-WindowsFeature -Name "RSAT-AD-Tools" -IncludeManagementTools -IncludeAllSubFeature`

`Add-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools -IncludeAllSubFeature`

`Add-WindowsFeature -Name "DNS" -IncludeManagementTools -IncludeAllSubFeature`

Promouvoir le serveur en Domaine Controller en utilisant la commande suivante :

`Install-ADDSDomainController -InstallDns -Credential (Get-Credential <DomainName\Administrator>) -DomainName <Domaine> -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "<Administrator Password>" -Force)`

(Remplacer "<Domaine\Administrator>" et "<Domaine >" par vos valeurs)

Le mot de passe Administrateur de votre Controller AD vous sera demandé.

Le Serveur Core est maintenant configuré comme Domaine Controller 



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


