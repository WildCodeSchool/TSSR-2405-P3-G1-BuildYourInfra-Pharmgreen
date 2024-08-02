

## Installation de RAID 1 sur tout les serveurs

### Étape 1 : **Ajouter des disques pour RAID 1 sur Proxmox:**
   - Allez dans l'onglet "Hard Disk".
   - Ajoutez deux disques virtuels avec la même taille. Ces disques seront utilisés pour configurer RAID 1.
   
![Capture d'écran 2024-07-31 144833](https://github.com/user-attachments/assets/993b32b3-d9a9-4f4c-b47a-2d02c511f193)

![Capture d'écran 2024-07-31 144849](https://github.com/user-attachments/assets/22f5b8b5-5ff1-4bc7-96ff-5a5ca86c5c25)

### Étape 2 : Configurer RAID 1 dans Windows Server 2022
1. **Accéder au gestionnaire de disques :**
   - Ouvrez le "Gestionnaire de disques" (Disk Management).

![Capture d'écran 2024-07-31 143450](https://github.com/user-attachments/assets/f95f4a79-c12f-4788-b7b6-b74b295c04e7)

2. **Initialiser les disques :**
   - Si les disques ne sont pas encore initialisés, initialisez-les en tant que disques MBR ou GPT 

3. **Créer un miroir (RAID 1) :**
   - Cliquez avec le bouton droit sur l'espace non alloué de l'un des deux disques que vous avez ajoutés pour le RAID.
   - Sélectionnez "New Mirrored Volume".
   - Suivez l'assistant pour ajouter le second disque au volume mirroir.
   - Assignez une lettre de lecteur et formatez le volume si nécessaire.

![Capture d'écran 2024-07-31 143346](https://github.com/user-attachments/assets/6c6e419e-22c0-406b-8e01-b99e198866ef)

### Étape 3 : Vérification
1. **Vérifiez la configuration RAID :**
   - Assurez-vous que le RAID 1 fonctionne correctement en vérifiant l'état des disques dans le gestionnaire de disques.
   - Testez le fonctionnement en écrivant et en lisant des données sur le volume RAID.
  
## Installation d'une sauvegarde planifiée des dossiers partagés sur le RAID 1

### Étape 1 : Installer et configurer Windows Server Backup
1. **Installer Windows Server Backup :**
   - Ouvrez le "Gestionnaire de serveur" (Server Manager).
   - Allez dans "Gérer" > "Ajouter des rôles et fonctionnalités".
   - Suivez l'assistant pour installer la fonctionnalité "Windows Server Backup".

![Capture d'écran 2024-07-31 160809](https://github.com/user-attachments/assets/1b2895b6-a79e-492e-b55b-f12e90750275)

2. **Ouvrir Windows Server Backup :**
   - Accédez à Windows Server Backup via le menu Démarrer ou le Gestionnaire de serveur.

### Étape 3 : Configurer une sauvegarde planifiée
1. **Planifier la sauvegarde :**
   - Dans Windows Server Backup, allez dans "Local Backup"
   - Cliquez sur "Backup Schedule" pour lancer l'assistant de planification de sauvegarde.

![Capture d'écran 2024-07-31 160929](https://github.com/user-attachments/assets/d116ffca-3ed1-41c1-a53c-6708cfef5e6b)

2. **Sélectionner le type de sauvegarde :**
   - Choisissez "Custom" pour spécifier les dossiers ou volumes à sauvegarder.

![Capture d'écran 2024-07-31 161431](https://github.com/user-attachments/assets/236fca59-1d5f-43be-a99a-5afec0990418)

3. **Sélectionner les éléments à sauvegarder :**
   - Ajoutez les dossiers partagés des utilisateurs que vous souhaitez sauvegarder.

![Capture d'écran 2024-07-31 161438](https://github.com/user-attachments/assets/5fcebc55-68f6-43ec-a229-0cd4311b4f0c)

4. **Planifier la sauvegarde :**
   - Configurez la sauvegarde pour s'exécuter au moins une fois par semaine.
   - Sélectionnez un jour et une heure où l'impact sur les performances sera minimal.

![Capture d'écran 2024-07-31 162203](https://github.com/user-attachments/assets/6c0accd1-e318-4bdc-86de-58119cac0d6b)

5. **Sélectionner la destination de la sauvegarde :**
   - Choisissez "Back up to a volume" et sélectionnez le volume RAID 1 (D:).
   - Si le RAID 1 est utilisé pour d'autres données, assurez-vous qu'il a suffisamment d'espace libre pour stocker les sauvegardes.

![Capture d'écran 2024-07-31 161548](https://github.com/user-attachments/assets/68b9a192-783a-40ab-b67f-a38dfc26a720)

6. **Finaliser la configuration :**
   - Vérifiez les paramètres de sauvegarde.
   - Cliquez sur "Finish" pour compléter la configuration.

![Capture d'écran 2024-07-31 161602](https://github.com/user-attachments/assets/c970b0f0-30bf-4255-8122-a171b8ad0031)


## Restrictions Horaires pour Utilisateurs Non-Admin sur Windows Server 2022

### 1. Bloquer la Connexion pour les Utilisateurs Non-Admin 

#### **Ouvrez "Active Directory Users and Computers" :**

- Cliquez sur le bouton **Start**, tapez **"dsa.msc"** et appuyez sur **Enter**.

**Modifier les Propriétés des Utilisateurs Non-Admin :**

- Dans la fenêtre **"Active Directory Users and Computers"**, localisez l'utilisateur dans l'unité d'organisation appropriée.
- Cliquez avec le bouton droit sur l'utilisateur et sélectionnez **Properties**.
- Allez dans l'onglet **Account** et configurez les restrictions nécessaires.

## Connexion Autorisée de 7h30 à 20h, du Lundi au Samedi

### 1. Mettre en place des horaires de connexion avec AD

#### **Ouvrez "Active Directory Users and Computers" :**

- Cliquez sur le bouton **Start**, tapez **"Active Directory Users and Computers "** et appuyez sur **Enter**.

![Capture d'écran 2024-08-02 114437](https://github.com/user-attachments/assets/dcf02279-90b9-45c5-b5a1-0ba021d319e8)

**Configurer les Restrictions Horaires :**

- Localisez l'utilisateur dans l'unité d'organisation appropriée.
- Cliquez avec le bouton droit sur l'utilisateur et sélectionnez **Properties**.

 ![Capture d'écran 2024-08-02 144452](https://github.com/user-attachments/assets/a571e382-c9e3-4cbd-8b8e-7d2f8a984ba3)

- Dans l'onglet **Account**, cliquez sur **Logon Hours**.

![Capture d'écran 2024-08-02 122257](https://github.com/user-attachments/assets/ea8b33f0-924d-4c98-a299-cdf54c2e4f00)

- Configurez les heures de connexion autorisées de 7h30 à 20h du lundi au samedi.

![Capture d'écran 2024-08-02 122618](https://github.com/user-attachments/assets/a3aa8aad-31ee-430f-beb5-69a047549499)




