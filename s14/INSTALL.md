### Étape 1 : Préparer le serveur Ubuntu
1. **Mettre à jour le système :**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
2. **Installer les prérequis :**
   Assurez-vous d'avoir installé les dépendances suivantes :
   ```bash
   sudo apt install wget curl git -y
   ```

### Étape 2 : Télécharger et installer IRedMail
1. **Télécharger la dernière version d'IRedMail :**
   ```bash
   cd /opt
   wget https://github.com/iredmail/iRedMail/archive/refs/tags/1.6.2.tar.gz -O iredmail.tar.gz
   ```
2. **Extraire l'archive :**
   ```bash
   tar xvf iredmail.tar.gz
   cd iRedMail-1.6.2/
   ```
3. **Lancer l'installation :**
   ```bash
   sudo bash iRedMail.sh
   ```
   - Vous serez invité à choisir le chemin d'installation, acceptez le chemin par défaut.
   - Choisissez ensuite les services que vous souhaitez installer (Postfix, Dovecot, etc.).
   - Lorsqu'on vous demande le nom de domaine, entrez `pharmgreen.com`.
   - Choisissez le backend pour stocker les données des utilisateurs (OpenLDAP, MySQL/MariaDB, etc.).
   - Suivez les autres instructions affichées à l'écran pour terminer l'installation.

### Étape 4 : Configurer le DNS pour le domaine pharmgreen.com
Pour que votre serveur de messagerie fonctionne correctement, vous devez configurer certains enregistrements DNS pour `pharmgreen.com` :

### Étape 2 : Connecter le serveur mail au domaine 
Ajouter des enregistrements DNS sur un serveur Windows Server 2022 se fait via le Gestionnaire DNS (DNS Manager). Voici les étapes à suivre pour ajouter des enregistrements DNS sur Windows Server 2022 :

#### Ouvrir le Gestionnaire DNS

1. **Se connecter au serveur Windows Server 2022** avec un compte ayant les droits d’administrateur.
2. **Ouvrir le Gestionnaire DNS :**
   - Cliquez sur le menu **Démarrer**.
   - Tapez **DNS** et sélectionnez **DNS Manager** (ou **Gestionnaire DNS**).

#### Ajouter un Enregistrement A (Adresse)

1. **Naviguer vers la zone de recherche directe (Forward Lookup Zones)** :
   - Dans le Gestionnaire DNS, développez l’arborescence à gauche pour trouver **Zones de recherche directe**.
   - Cliquez sur la zone correspondant à votre domaine, par exemple `pharmgreen.com`.
   
2. **Ajouter un enregistrement A :**
   - Faites un clic droit sur la zone de votre domaine (`pharmgreen.com`) et sélectionnez **Nouvel hôte (A ou AAAA)...**.
   - Dans la fenêtre qui s’ouvre :
     - **Nom** : Saisissez `mail` (ou laissez-le vide pour créer un enregistrement pour le domaine de base).
     - **Adresse IP** : Saisissez l'adresse IP de votre serveur de messagerie (par exemple, `192.168.1.10`).
   - Cliquez sur **Ajouter un hôte**.
   - Une fenêtre de confirmation apparaîtra indiquant que l'enregistrement a été créé avec succès.

#### Ajouter un Enregistrement MX (Mail Exchange)

1. **Ajouter un enregistrement MX :**
   - Faites un clic droit sur la zone de votre domaine (`pharmgreen.com`) et sélectionnez **Nouvel enregistrement MX...**.
   - Dans la fenêtre qui s’ouvre :
     - **Nom** : Laissez vide ou mettez `@` pour indiquer le domaine racine.
     - **Serveur de messagerie pleinement qualifié (FQDN)** : Entrez `mail.pharmgreen.com`.
     - **Priorité** : Saisissez `10` ou une autre valeur. Un nombre plus bas signifie une priorité plus élevée.
   - Cliquez sur **OK** pour ajouter l'enregistrement MX.

#### Ajouter un Enregistrement TXT pour SPF (Optionnel)

1. **Ajouter un enregistrement TXT :**
   - Faites un clic droit sur la zone de votre domaine (`pharmgreen.com`) et sélectionnez **Nouvel enregistrement TXT**.
   - Dans la fenêtre qui s’ouvre :
     - **Nom** : Laissez vide ou mettez `@` pour indiquer le domaine racine.
     - **Données du texte** : Entrez la valeur `"v=spf1 mx ~all"`.
   - Cliquez sur **OK** pour ajouter l'enregistrement.

#### Ajouter un Enregistrement CNAME ou d'autres Enregistrements (si nécessaire)

1. **Ajouter un enregistrement CNAME :**
   - Faites un clic droit sur la zone de votre domaine  et sélectionnez **Nouvel alias (CNAME)...**.
   - Dans la fenêtre qui s’ouvre :
     - **Nom de l'alias** : Entrez l'alias, par exemple `www`.
     - **Nom complet du domaine cible (FQDN)** : Entrez le nom du domaine cible, par exemple `mail.exemple.com`.
   - Cliquez sur **OK** pour ajouter l'enregistrement.


### Étape 4 : Intégrer le domaine pharmgreen.com avec Windows Server 2022 (Active Directory)
Si vous souhaitez que les utilisateurs de Windows Server 2022 puissent utiliser le serveur de messagerie avec leur compte AD :

1. **Installer et configurer OpenLDAP sur Ubuntu :**
   - Durant l'installation d'IRedMail, vous avez peut-être choisi OpenLDAP comme backend. Si c'est le cas, vous devez configurer la synchronisation avec votre AD sur Windows.

2. **Installer et configurer `samba` et `winbind` :**
   - Pour intégrer votre serveur Ubuntu au domaine Windows :
     ```bash
     sudo apt install samba winbind -y
     ```

3. **Rejoindre le domaine Windows :**
   - Modifiez le fichier `/etc/samba/smb.conf` pour rejoindre le domaine. Ajoutez-y les paramètres nécessaires comme le domaine, le contrôleur de domaine, etc.
   - Ensuite, utilisez la commande suivante pour rejoindre le domaine :
     ```bash
     sudo net ads join -U administrateur
     ```

4. **Configurer Dovecot pour l'authentification avec Active Directory :**
   - Modifiez le fichier de configuration de Dovecot (`/etc/dovecot/dovecot.conf`) pour permettre l'authentification via LDAP.

### Étape 5 : Tester l'installation
1. **Redémarrer tous les services :**
   ```bash
   sudo systemctl restart postfix dovecot slapd
   ```
2. **Tester l'envoi et la réception d'emails :**
   - Utilisez un client de messagerie (comme Thunderbird ou Outlook) pour vous connecter à votre serveur de messagerie via IMAP/SMTP.

