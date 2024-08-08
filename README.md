---
# TSSR-2405-P3-G2-BuildYourInfra-Pharmgreen
---

<p align="center">
<img align="center" src="https://github.com/WildCodeSchool/TSSR-2405-P3-G2-BuildYourInfra-Pharmgreen/blob/main/S9/Annexes/Logo_PG.png">

<p align="center"> Mettre en place une infrastructure réseau pour la société Pharmgreen
</p>

## Sommaire

**1 - Présentation de l'équipe**

**2 - Présentation du projet et son contexte**

**3 - Roles par Sprint**

**4-  Choix Techniques**

**Mise en pratique des compétences suivantes :**

- Analyser les besoins techniques et fonctionnels
- Mettre en place des objectifs et réaliser un suivi
- Créer, gérer, faire évoluer une architecture réseau
- Réaliser un projet en équipe
- Documenter toutes les étapes

## L'équipe est composée de :

- Brice
- Karim
- Philippe
- Ronan
- Vanessa

## Le projet et son contexte :

**Pharmgreen** se positionne comme un pionnier dans le domaine de la santé en proposant des dispositifs médicaux innovants d'origine végétale, répondant ainsi à une demande croissante pour des solutions de santé naturelles et respectueuses de l'environnement. Grâce à des procédés de fabrication innovants et des collaborations avec des experts en botanique et en médecine naturelle, elle s'engage à fournir des produits de haute qualité, bénéfiques à la fois pour les patients et pour la planète. Son fondateur est de Lyon, et a décidé d’implanter les locaux dans sa ville natale.

L'équipe présentée au point précédent vient d'être recrutée pour mettre en place une infrastructure réseau, ainsi que palier au manque de techniciens dans l'entreprise.

Le projet est découpé en 11 sprints de 11 semaines.
En début de sprint, le groupe abordera une nouvelle thématique afin de le mettre en place sur l’infrastructure réseau.

## Le suivi des objectifs :

 - Chaque début de sprint, définir les objectifs du sprint
 - Chaque fin de sprint, mettre les objectifs réalisés ou non dans un fichier "Suivi des objectifs"
 - Chaque fin de sprint, mettre les différentes tâches réalisés par chaque membre du groupe


## Rôles par sprint
### Sprint 1

| NOM      | TÂCHES                                                              |
|----------|---------------------------------------------------------------------|
| Ronan  (PO)  | Préparation du serveur Windows 2022 en GUI<br>Présentation          |
| Philippe (SM) | Gestion de l’arborescence AD manuellement et en automatisation<br>Préparation du serveur Debian en SSH<br>Présentation |
| Karim  (DEV)  | Gestion de l’arborescence AD manuellement et en automatisation<br>Préparation du serveur Debian en SSH<br>Présentation |
| Brice  (DEV)  | Préparation du serveur Debian en SSH<br>Présentation                |
                                                         |

### Sprint 2

| NOM      | TÂCHES                                                              |
|----------|---------------------------------------------------------------------|
| Ronan    | GPO Sécurité<br>Script automatisation du serveur Core pour rejoindre ADDS<br>Documentation |         |
| Philippe | Mise en place GLPI<br> Script automatisation du serveur Debian <br>Documentation|
| Karim  PO  |GPO Sécurité<br>Script automatisation du serveur Core pour rejoindre ADDS<br>Documentation|
| Brice  SM  | GPO Sécurité et Standards<br>Script automatisation du serveur Core pour rejoindre ADDS<br>Documentation             |
                                                      |

### Sprint 3

| NOM      | TÂCHES                                                              |
|----------|---------------------------------------------------------------------|
| Ronan    | Script automatisation du serveur Core pour rejoindre ADDS<br>Documentation |         |
| Philippe |Mise en place du pfsense et des règles du parefeu<br> Documentation|
| Karim  PO  |Mise en place du routeur vyos<br>Documentation|
| Brice  SM  | Mise en place du pfsense et des règles du parefe<br>mise en place de la télémétrie<br>Documentation             |                                                       |


### Sprint 4

| NOM      | TÂCHES                                                              |
|----------|---------------------------------------------------------------------|
| Ronan    | RAID 1 sur GUI , Sauvegarde dossiers partagés,Bloquer la connexion pour les utilisateurs non-admin  |         |
| Philippe | Mise en place des Dossiers partagés, GPO Création de dossier personnel, Mise à jour de l'AD|
| Karim  PO  |Mise en place de LAPS,Mise en place RAID1 sur Debian |
| Brice  SM  | Mise en place des Dossiers partagés,Mise en place du RAID1 sur windows Server Core et soutien de Ronan sur la mise en place de la sauvegarde              |


### Sprint 5

| NOM      | TÂCHES                                                              |
|----------|---------------------------------------------------------------------|
| Ronan    | Documentation, Installation de Nagios |         |
| Philippe | Création des logs et installation de CMTrace, Installation de Nagios |
| Karim  PO  |Création des logs et installation de CMTrace, installation de nagios |
| Brice  SM  | Continuer la mise en place du Raid1 sur le windows server core , Création des logs et installation de CMTrace, Installation de Nagios            |
