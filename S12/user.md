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
