---
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

(Remplacer <Domaine\Administrator> et <Domaine> par vos valeurs)

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


