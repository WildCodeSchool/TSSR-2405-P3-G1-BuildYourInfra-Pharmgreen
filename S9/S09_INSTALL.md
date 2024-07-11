
## Installation du serveur Debian

### 1. Prérequis:

#### A- Virtualiseur
Il faut Proxmox VE sur lequel seront installées toutes nos machines.

#### B- Debian
Il faut un ISO Debian téléchargé depuis le site officiel: [debian.org](https://www.debian.org/index.fr.html).

### 2. Créer la VM 

#### A-
Dans Proxmox, créer la VM en choisissant l’ISO Debian, et en lui allouant le nombre de coeurs et de RAM nécessaires à l’exercice (ici 2 coeurs et 4 Go de RAM).

#### B-
Au lancement de la VM, choisir une installation sans interface graphique. Suivre les instructions.

#### C- Identifiants
Le nom de la machine est : `root`
Le mot de passe est : `Azerty1*`

#### D- SSH
Cocher "Serveur SSH" en appuyant sur la touche espace.

Une fois l’installation finie, vérifier avec les commandes suivantes:
- Si le paquet est installé: `dpkg -l | grep openssh-server`
- Si le serveur SSH est actif: `sudo systemctl status ssh`

Ensuite, se connecter à l’aide de Putty sur la machine Windows.

#### E- Rejoindre l’Active Directory
Utiliser la commande: `realm join -v domain`

Pour nous, cela serait : `realm join -v pharmgreen.com`

Vérifier sur l’Active Directory que la machine est bien ajoutée.
