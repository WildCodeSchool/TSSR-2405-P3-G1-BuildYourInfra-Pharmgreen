
## 1. **Installation de WSUS sur le serveur**

### **Prérequis :**
 - Un serveur  WSUS
 - Un client
 - Un serveur AD
 - Les machines doivent communiquer entre elles

### Étape 1: Installer le rôle WSUS

1. **Ouvrir le Gestionnaire de serveur** :
   - Cliquez sur **"Gérer"** (en haut à droite) puis sur **"Ajouter des rôles et des fonctionnalités"**.

2. **Sélectionner le type d'installation** :
   - Sélectionnez **"Installation basée sur un rôle ou une fonctionnalité"**.

3. **Choisir le serveur de destination** :
   - Sélectionnez votre serveur dans la liste.

4. **Ajouter le rôle WSUS** :
   - Dans l'assistant de sélection des rôles, cochez **Windows Server Update Services**.
   - Une fenêtre pop-up s'ouvrira pour vous demander d'ajouter des fonctionnalités requises, cliquez sur **"Ajouter des fonctionnalités"**.

5. **Sélectionner les services de rôle WSUS** :
   - Cochez **WSUS Services** et **Base de données interne de Windows** ou spécifiez un serveur SQL externe si vous en utilisez un.

6. **Configurer l'emplacement de stockage des mises à jour** :
   - Indiquez un chemin d'accès pour stocker les mises à jour (par exemple, `D:\WSUS`).
   - Assurez-vous que le lecteur sélectionné a suffisamment d'espace disque.

7. **Terminer l’installation** :
   - Cliquez sur **"Installer"** et attendez la fin de l’installation.

![Capture d'écran 2024-09-13 152851](https://github.com/user-attachments/assets/0317506b-695b-4bc2-9d59-240effa59750)

### Étape 2: Configurer WSUS

1. **Lancer la configuration post-installation** :
   - Une fois l’installation terminée, une fenêtre de **"Configuration de WSUS"** s’ouvre automatiquement.
   - Si ce n’est pas le cas, ouvrez **WSUS** depuis le menu **Outils** du Gestionnaire de serveur.

2. **Connexion à Microsoft Update** :
   - Sélectionnez **Synchroniser les mises à jour à partir de Microsoft Update**.

3. **Choisir les langues et les produits** :
   - Sélectionnez les langues des mises à jour que vous souhaitez télécharger.
   - Cochez les produits Windows (par exemple, Windows 10, Windows Server) pour lesquels vous souhaitez gérer les mises à jour ( notre client va être en Windows 10, donc cochez la case "Windows 10").

4. **Choisir les classifications de mises à jour** :
   - Cochez les types de mises à jour que vous voulez approuver (par exemple, **Mises à jour de sécurité**, **Service Packs**, **Mises à jour critiques**, etc.).

5. **Planifier les synchronisations** :
   - Vous pouvez choisir de synchroniser automatiquement WSUS avec les serveurs de Microsoft à une certaine heure.

6. **Finaliser la configuration** :
   - Laissez WSUS télécharger les premières mises à jour. Cela peut prendre du temps selon la vitesse de votre connexion et la quantité de mises à jour à télécharger.

### Étape 3: Approvisionnement des mises à jour

1. **Approbation des mises à jour** :
   - Allez dans **Mises à jour** > **Tous les ordinateurs**.
   - Vous verrez une liste de mises à jour disponibles. Sélectionnez celles que vous souhaitez approuver.
   - Cliquez avec le bouton droit et choisissez **Approuver**. Sélectionnez ensuite le groupe d'ordinateurs (par exemple, **Tous les ordinateurs**).

2. **Création du computer group "GENERAL"**
   - Allez dans les paramètres WSUS ( Windows Server Update Services )
   - Computers
   - `Add Computer group` puis renseignez "GENERAL" afin de mettre les clients WSUS dans ce groupe.

![Capture d'écran 2024-09-13 153043](https://github.com/user-attachments/assets/b851339a-68bd-49e5-8735-942cbf3db207)

![Capture d'écran 2024-09-13 153051](https://github.com/user-attachments/assets/8a68d4c5-a4ee-42df-885b-55452fa165de)

## 2. **Configuration de l'AD pour recevoir les mises à jour WSUS**

Pour que les ordinateurs clients reçoivent les mises à jour du serveur WSUS, vous devez configurer les paramètres de stratégie de groupe (GPO) sur votre serveur AD

### Utilisation des GPO (pour les environnements Active Directory)

1. **Ouvrir la Gestion des stratégies de groupe (GPMC)** :
   - Sur le contrôleur de domaine, ouvrez **Gestion des stratégies de groupe**.

2. **Créer une nouvelle stratégie de groupe** :
   - Faites un clic droit sur **"Objets de stratégie de groupe"**, puis sélectionnez **"Nouveau"**.
   - Nommez la stratégie (par exemple, **WSUS-Updates**).
   - Liez la avec l' OU qui a les ordinateurs Clients et WSUS
   - Mettez les ordinateurs dans le même groupe ( ex : Domain Computers ), et mettez les permissions nécessaires , puis liez ce groupe avec votre GPO


### Paramétrage commun à toutes les GPO :

 **Modifier la GPO** :
   - Faites un clic droit sur la nouvelle GPO et sélectionnez **Modifier**.
Va dans **Computer Configuration** → **Policies** → **Administrative Templates** → **Windows Components** → **Windows Update**.

![Capture d'écran 2024-09-13 153232](https://github.com/user-attachments/assets/925215ae-74a8-48ab-8551-3b3d5318ff08)

1. Va dans **Specify intranet Microsoft update service location**, qui indiquera où est le serveur de mise à jour.
   - Coche **Enabled**.
   - Dans les options, pour les 2 premiers champs, mets l'URL avec le nom du serveur sous sa forme FQDN, en ajoutant le numéro de port `8530`.
   - Valide la configuration.

![Capture d'écran 2024-09-13 153245](https://github.com/user-attachments/assets/88293d08-9c99-4fdb-b343-ce63503f0429)

2. Va dans **Do not connect to any Windows Update Internet locations**, qui bloque la connexion aux serveurs de Microsoft.
   - Coche **Enabled** et valide la configuration.

![Capture d'écran 2024-09-13 153304](https://github.com/user-attachments/assets/2e88bfb2-a69a-4209-9d96-419d5f4979c1)

#### Paramétrage spécifique à cette GPO :

1. Va dans **Configure Automatic Updates**.
   - Coche **Enabled**.
   - Dans les options :
     - Dans **Configure automatic updating**, sélectionne `4 - Auto Download and schedule the install`.
     - Dans **Scheduled install day**, mets `0 - Every day`.
     - Dans **Scheduled install time**, mets `09:00`.
     - Coche **Every week**.
     - Coche **Install updates for other Microsoft Products**.

![Capture d'écran 2024-09-13 155202](https://github.com/user-attachments/assets/322f72e5-6bba-47bb-bddd-17ff1346fbed)


2. Va dans **Enable client-side targeting**, qui fait la liaison avec les groupes créés dans WSUS.
   - Coche **Enabled**.
   - Dans les options, mets le nom du groupe WSUS pour les ordinateurs cibles, donc `COMPTABILITE`.
   - Valide la configuration.

![Capture d'écran 2024-09-13 153319](https://github.com/user-attachments/assets/86032b5d-2b5d-41ec-b419-89bcc41fe981)

3. Va dans **Turn off auto-restart for updates during active hours**, qui permet d'empêcher les machines de redémarrer après l'installation d'une mise à jour pendant leurs heures d'utilisation.
   - Coche **Enabled**.

![Capture d'écran 2024-09-13 153358](https://github.com/user-attachments/assets/4cdf8d3b-5e57-42cd-8d8b-529df32c1cce)


5. **Configurer la fréquence de détection des mises à jour** :

   - Toujours dans les paramètres de Windows Update, activez **Configurer des mises à jour automatiques**. Sélectionnez la méthode d’installation (par exemple, **Télécharger les mises à jour et avertir pour l’installation**).

7. **Appliquer la GPO** :

 - Liez cette stratégie de groupe à l’OU contenant vos ordinateurs clients.

### Configuration manuelle sur un client (modification du Registre)

- Accéder à cette page afin de télécharger le WSUSClientManager.exe (afin de modifier le registre)

https://github.com/blndev/wsusworkgroup/releases/tag/1.2

- Ouvrez le .exe puis renseignez les informations demandés (IP de WSUS, Groupname : GENERAL, Automatic Updates and users can configure it ect...)

  ![Capture d'écran 2024-09-13 153518](https://github.com/user-attachments/assets/344548f1-5b06-4c9d-ac05-86384b29172b)

## 3. **Appliquer la GPO à votre client**

Pour installer les GPO configurer sur notre AD (vérifier si le serveur AD communique avec votre client):

1. **Ouvrir une invite de commande** (en tant qu'administrateur).

2. Tapez la commande suivante pour forcer une détection des mises à jour :
 
   ```powershell
   gpupdate /force
    ```
  
4. Vérifiez si les GPO ont bien été installé :

    ```powershell
   gpresult /r
   ```
6. Si cela ne fonctionne pas faites la commande suivante afin d'avoir les détails de l'erreur dans un fichier html localiser sur C:\ :
 
   ```powershell
   gpresult /h C:\rapport_gpo.html
   ```

7. **Vérifier les mises à jour installées (sans internet)** :

    - Ouvrez les **Paramètres Windows** > **Mise à jour et sécurité** > **Windows Update** et vérifiez si les mises à jour sont proposées par votre serveur WSUS.
  
   ![Capture d'écran 2024-09-13 153547](https://github.com/user-attachments/assets/7b475f68-5190-404f-821f-0ac05b7f3c28)

 
6. **Vérifier la détéction de votre client sur WSUS** :

  - Ouvrez WSUS
  - Puis allez dans le computer group "GENERAL"
  - Normalement , en actualisant votre groupe , votre client devrait apparaître et vous pourrez synchroniser votre serveur WSUS pour voir si il y a des mise à jour à faire sur votre client.




# Répartition des FSMO entre les différents DC

## Lister les FSMO et leurs DC avec la commande suivante:
**netdom query fsmo**

<img width="553" alt="Capture d’écran 2024-09-12 à 15 06 03" src="https://github.com/user-attachments/assets/b9b09cf8-9878-4e39-98e1-9e25bb83285f">

## Répartir chaque FSMO sur leurs DC respectifs à l'aide de la commande suivante:
**Move-ADDirectoryServerOperationMasterRole -Identity "Nom_DC_Cible" -OperationMasterRole "nom_FSMO"**

## N.B
Important: Suite à des recherches et en suivant les recommandations de microsoft, nous n'avons pas réparties les FSMO sur d'autre DC que le serveur principal (Active Directory). 

<img width="669" alt="Capture d’écran 2024-09-12 à 15 27 39" src="https://github.com/user-attachments/assets/c0eadbd6-4c80-4985-bdfa-9627d50b9c0c">

<img width="659" alt="Capture d’écran 2024-09-12 à 15 27 44" src="https://github.com/user-attachments/assets/5abd066c-8fc3-4135-b5bd-80b2585a4224">

<img width="678" alt="Capture d’écran 2024-09-12 à 15 27 53" src="https://github.com/user-attachments/assets/961cc388-8795-47d1-a3ee-3e3eea4c817b">
