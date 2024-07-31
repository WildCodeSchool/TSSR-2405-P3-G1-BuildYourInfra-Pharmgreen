

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
