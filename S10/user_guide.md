
# Mise en place d’un GPO de sécurité

## A- GPO Politique de Mot de Passe
Ici, nous créons une politique de mots de passe qui va régler la mise en place des mots de passe. Nous passerons par :
- L’historique des mots de passe
- La durée de validité minimum et maximum
- La longueur

Ces 3 paramètres permettent la mise en place d’une politique de mots de passe robuste.

Pour ce faire, il faut naviguer dans les sous-menus suivants après la création du GPO :
`Configuration ordinateur > Paramètres Windows > Paramètres de sécurité > Stratégies de compte > Stratégie de mot de passe`

1. **Longueur des mots de passe :**
   - Double-cliquer sur *Password must meet complexity requirements*, et *enable*.
   - Double-cliquer sur *Minimum password length*, puis entrer `10`. Puis *Apply* et *Okay*.
   - Ceci nous permet d’avoir un mot de passe d’un minimum de 10 caractères, pour plus de robustesse.

2. **L’historique des mots de passe :**
   - Double-cliquer sur *Enforce password history*, puis entrer `5`. Puis *Apply* et *Okay*.
   - Ceci nous permet d’obliger les utilisateurs à utiliser 5 mots de passe différents coups sur coups.

3. **Validité minimum :**
   - Double-cliquer sur *Minimum password age*, puis entrer `1`. Puis *Apply* et *Okay*.
   - Ce qui nous permet d’avoir une durée minimum de validité de 1 jour.

4. **Validité maximum :**
   - Double-cliquer sur *Maximum password age*, puis entrer `90`. Puis *Apply* et *Okay*.
   - Ce qui nous permet d’avoir une durée de vie des mots de passe de 90 jours maximum.

Ces 3 paramètres nous permettent d’assurer la sécurité des accès aux postes utilisateurs, grâce à un renouvellement régulier et une variété de mots de passe robustes. Enfin, le nombre de 10 caractères est un choix stratégique, qui permet un bon compromis entre robustesse et mémorisation des mots de passe.

Nous avons donc un menu des mots de passe qui ressemble à ce qui suit :

<img width="344" alt="Capture d’écran 2024-07-15 à 11 39 30" src="https://github.com/user-attachments/assets/a13bcc27-265b-4260-801f-75154162fad8">


## B- GPO sur le Verrouillage des Comptes
Ici, nous créons un GPO qui régule le verrouillage des comptes suite à une erreur d’entrée du mot de passe. Nous passerons par :
- Le nombre maximal de tentatives
- Le temps de verrouillage
- Et le temps avant de réinitialiser le compteur de verrouillage.

Pour ce faire, il faut naviguer dans les sous-menus suivants après la création du GPO :
`Computer Configuration > Policies > Windows Settings > Security Settings > Account Lockout Policy`

1. **Le nombre maximal de tentatives :**
   - Double-cliquer sur *Account lockout threshold*, puis entrer `3`. Puis *Apply* et *Okay*.
   - Ceci nous permet de définir le nombre maximal de mots de passe erronés autorisés.

2. **Le temps de verrouillage :**
   - Double-cliquer sur *Account lockout duration*, puis entrer `25`. Puis *Apply* et *Okay*.
   - Ceci nous permet de verrouiller l'accès au poste pendant 25 minutes avant de pouvoir faire de nouvelles tentatives de mots de passe.

3. **Réinitialiser le compteur de verrouillage du compte après :**
   - Double-cliquer sur *Reset account lockout counter after*, puis entrer `25`. Puis *Apply* et *Okay*.
   - Ceci nous permet de réinitialiser le minutage du verrouillage d’accès aux postes pour une durée de 25 minutes.

Ces paramètres renforcent la politique des mots de passe, et permettent une sécurisation plus poussée contre les éventuelles intrusions (brute force, attaque par dictionnaire, etc.). On arrive donc avec un menu comme suit :
![74DFB829-1996-4BA2-A14C-335072211BED_1_201_a](https://github.com/user-attachments/assets/35cc9933-5aee-476d-b7fa-699884e49148)


## C- GPO pour Restreindre l’Installation de Logiciels
Ici, nous créons un GPO qui régule l’installation de logiciels par des utilisateurs. Nous passerons par :
- L’installation via un périphérique externe
- La modification des privilèges

Pour ce faire, il faut naviguer dans les sous-menus suivants après la création du GPO :
`User Configuration > Policies > Administrative Templates > System`

1. **L’installation via un périphérique externe :**
   - Double-cliquer sur *Prevent removable source for any installation*, puis *enable*. Puis *Apply* et *Okay*.
   - Ce qui nous permet d'empêcher l’installation depuis un périphérique externe.

2. **Privilèges d’installation :**
   - Double-cliquer sur *Always install with elevated privilege*, puis *disabled*. Puis *Apply* et *Okay*.
   - Ce qui nous permet de ne pas permettre à un utilisateur d’installer des logiciels qu’avec des droits utilisateurs (et donc de ne pas pouvoir installer de logiciels qui modifient ou permettent un accès en écriture sur la machine).


### **D- Mise en place d'une GPO WINDOWS UPDATE :**   

Se rendre dans "Group Policy Objects", taper gpmc.msc puis cliquer sur l'icone qui s'affiche pour l'ouvrir.    

![C1a](https://github.com/user-attachments/assets/e89aa85d-2c37-46e7-b1a9-77d1daeb8efb)     

La fenêtre "Group Policy Management" suivante s'affiche :   

**1. Créer la GPO :**   

  

Faire un clic droit sur "Group Policy Objects" puis choisir "New".  

![CAP1_newGPO](https://github.com/user-attachments/assets/d852f8b0-a78f-4b58-8c19-c44f4a2e24dd)    
   
    

Donner un nom à la GPO, par exemple **"Gestion de Windows Update"**.   

**2. Configurer les paramètres de Windows Update désirés :**          

Se déplacer dans l'arborescence : "Computer configuration" -> "Administration Templates" -> "Windows Components" -> "Windows Update".    

![CAP3_windowsupdate](https://github.com/user-attachments/assets/7637c0f6-c18f-4fb2-accd-dda1c58b91e0)    

Configurez les paramètres selon vos besoins, comme par exemple :    

- Configurer les mises à jour automatiques : "Activez et choisissez le mode souhaité" (p.ex., Télécharger automatiquement et planifier l'installation).   
- Spécifier le jour et l'heure pour installer les mises à jour :   
"Configurez les jours et heure spécifiques pour les installations."         


![C4_modifapporteeautoupdate](https://github.com/user-attachments/assets/35d63c1e-22a7-4911-a9a9-885170716403)    

 
**E- Base de registre (Blocage de l'accès à la base de registre)**       

**1. Créer la GPO :**   

Suivre les mêmes étapes que précédemment pour créer une nouvelle GPO, la nommer par exemple "Blocage Accès Registre".   

![CA2_NamenewGPO](https://github.com/user-attachments/assets/05e32aa4-4048-4fcb-8d47-b893380e1665)     


**2. Configurer les paramètres de restriction :**        

Faire un clic droit sur la GPO nouvellement créée et sélectionner "Edit".  
On se trouve maintenant dans "Group Policy Management Editor"   


Aller à Configuration User Configuration -> Administrative Templates -> System.(arborescence sur capture d'écran en dessous"    

![CA3_choixmenu](https://github.com/user-attachments/assets/d462df8e-6f0e-4325-894f-f9a7f40af298)      

Recherchez et activez la stratégie "Prevent access to registry tools"
Faire "Edit" (avec le bouton droit de la sourie) puis dans la fenêtre d'option activer (enabled) puis "Apply" puis "OK"   

![CA4_enableoption](https://github.com/user-attachments/assets/055c7320-e212-4c3e-8823-72cde6d29207)
   

**F- Blocage du panneau de configuration**    

**1. Créer la GPO :**

Créer une nouvelle GPO avec un nom tel que "Blocage Panneau de Configuration".   


![CB1_NameGPO6](https://github.com/user-attachments/assets/31989ba9-0132-41ce-aa71-28d34478d5a7)


**2. Configurer les paramètres de restriction :**      


Faire un clic droit sur la GPO nouvellement créée et sélectionnez "Modifier".   
Aller à "user configuration" -> "Administration Templates" -> "control panel".   

![CB2_forbidenreglage](https://github.com/user-attachments/assets/c3f6a2c7-ae60-4575-ac4c-ec02fa3b356f)    


Activer la stratégie Interdire l'accès au panneau de configuration et aux paramètres PC.   

![CB3_enableoudisabled](https://github.com/user-attachments/assets/65ebbc3e-6384-4754-83ff-deef4b268e77)   

Tous ces paramètres peuvent être changés suivant les besoins.   

Pour créer ces GPO (Group Policy Objects) dans un environnement Windows Server, voici des instructions simplifiées pour chaque cas :

Pour créer et configurer des GPO (Group Policy Objects) pour les tâches spécifiées, vous pouvez suivre les étapes suivantes. Assurez-vous que vous avez les droits administratifs nécessaires sur votre domaine Active Directory (AD).

### Restriction des périphériques amovibles (n°7)

1. **Ouvrir la console de gestion des stratégies de groupe (GPMC)**:
   - Allez dans le menu Démarrer, tapez `gpmc.msc`, puis appuyez sur Entrée.

2. **Créer une nouvelle GPO**:
   - Dans la console GPMC, faites un clic droit sur l’OU (Unité d'Organisation) où vous souhaitez appliquer cette GPO, puis sélectionnez `Créer un GPO dans ce domaine, et le lier ici...`.
   - Nommez la GPO, par exemple, "Restriction des périphériques amovibles".

3. **Configurer les paramètres de restriction**:
   - Faites un clic droit sur la GPO nouvellement créée et sélectionnez `Modifier`.
   - Allez à `Configuration de l'ordinateur -> Modèles d'administration -> Système -> Accès amovible`.
   - Configurez les paramètres tels que `Deny read access` et `Deny write access` pour les types de périphériques que vous souhaitez restreindre (CD et DVD, disques amovibles, etc.).

### Gestion d'un compte du domaine qui est administrateur local des machines (n°8)

1. **Créer une GPO pour ajouter un utilisateur de domaine aux administrateurs locaux**:
   - Suivez les étapes pour ouvrir GPMC et créer une nouvelle GPO, par exemple, "Ajout Admin Local".

2. **Configurer les paramètres pour ajouter l'utilisateur**:
   - Faites un clic droit sur la GPO créée et sélectionnez `Modifier`.
   - Allez à `Configuration de l'ordinateur -> Stratégies -> Paramètres Windows -> Paramètres de sécurité -> Groupes restreints`.
   - Faites un clic droit sur `Groupes restreints` et sélectionnez `Ajouter un groupe`.
   - Tapez `Administrateurs` et cliquez sur OK.
   - Cliquez sur `Ajouter un utilisateur ou un groupe` sous `Ce groupe est membre de ces groupes` et ajoutez le compte de domaine que vous souhaitez ajouter comme administrateur local.


### Gestion du pare-feu (GPO n°9)

Pour configurer les règles du pare-feu via une GPO :

1. **Ouvrir l'éditeur de stratégie de groupe :**
   - Sur votre contrôleur de domaine ou un serveur avec l'outil Group Policy Management installé, ouvrez "Group Policy Management".

2. **Créer une nouvelle GPO :**
   - Cliquez avec le bouton droit sur l'unité d'organisation (OU) ou le domaine approprié.
   - Choisissez "Create a GPO in this domain, and Link it here...".
   - Nommez la nouvelle GPO (par exemple, "Gestion du pare-feu").

3. **Configurer les paramètres du pare-feu :**
   - Sous "Computer Configuration" > "Policies" > "Windows Settings" > "Security Settings" > "Windows Firewall with Advanced Security", vous pouvez configurer les règles de pare-feu entrantes et sortantes.

4. **Appliquer la GPO :**
   - Assurez-vous que la GPO est liée à l'OU appropriée ou au domaine entier.

### Définition de scripts de démarrage (GPO n°13)

Pour définir des scripts de démarrage pour les machines ou les utilisateurs :

1. **Ouvrir l'éditeur de stratégie de groupe :**
   - Utilisez "Group Policy Management" comme précédemment.

2. **Créer une nouvelle GPO :**
   - Créez une nouvelle GPO comme décrit dans la section précédente.

3. **Configurer les scripts de démarrage :**
   - Sous "Computer Configuration" ou "User Configuration", allez à "Policies" > "Windows Settings" > "Scripts (Startup/Shutdown)".
   - Double-cliquez sur "Startup" pour configurer les scripts de démarrage des ordinateurs, ou "Logon" pour les scripts de connexion des utilisateurs.
   - Ajoutez les scripts nécessaires en utilisant les boutons "Add".

4. **Appliquer la GPO :**
   - Assurez-vous que la GPO est liée à l'OU ou au domaine où vous voulez que les scripts s'exécutent.

### Politique de sécurité PowerShell (GPO n°14)

Pour définir des politiques de sécurité PowerShell via une GPO :

1. **Ouvrir l'éditeur de stratégie de groupe :**
   - Utilisez "Group Policy Management" comme précédemment.

2. **Créer une nouvelle GPO :**
   - Créez une nouvelle GPO comme décrit ci-dessus.

3. **Configurer les paramètres de sécurité PowerShell :**
   - Sous "Computer Configuration" ou "User Configuration", allez à "Policies" > "Administrative Templates" > "Windows Components" > "Windows PowerShell".
   - Vous pouvez activer/désactiver divers paramètres de sécurité PowerShell comme "Turn on Script Execution", "Script Block Logging", etc.

4. **Appliquer la GPO :**
   - Liez la GPO à l'OU ou au domaine approprié.

# Mise en place d’un GPO Standard

## A- GPO pour Rediriger les Dossiers
Ici, nous créons un GPO qui va rediriger les dossiers des utilisateurs *Documents*, *Downloads* et *Desktop* dans un dossier unique pour chaque utilisateur par le serveur, facilitant ainsi l’administration des machines par les administrateurs.

Pour ce faire, il faut naviguer dans les sous-menus suivants après la création du GPO :
`User Configuration > Policies > Windows Settings > Folder Redirection`

Pour chacun des 3 dossiers, faire un clic droit et sélectionner *Propriétés*.
- Dans l’onglet *Target*, sélectionner *Basic - Redirect everyone's folder to the same location*.
- Dans l’onglet *Target Folder Location*, sélectionner *Create a folder for each user under the root path*.
- Dans l’onglet *Root Path*, entrer le chemin `\\srv-main\Pharmgreen`.

Et donc obtenir le menu suivant pour *Documents*, *Downloads* et *Desktop* :
<img width="921" alt="Capture d’écran 2024-07-16 à 10 57 30" src="https://github.com/user-attachments/assets/3d49ec03-a39a-454c-8ddb-615af3f7a023">



## B- GPO pour Avoir un Fond d’Écran Unique et Non Personnalisable
Ici, nous créons un GPO qui va permettre d’avoir un fond d’écran uniforme sur tout le parc informatique, le logo de Pharmgreen. Avoir son logo pour fond d’écran renforcera l’esprit d’équipe, rappellera les valeurs de l’entreprise aux employés et permettra à l’entreprise de contrôler son image en ayant un parc informatique uniforme.

Pour ce faire, il faut naviguer dans les sous-menus suivants après la création du GPO :
`User Configuration > Policies > Administrative Templates > Desktop > Desktop`

1. **Changer le fond d’écran :**
   - Double-cliquer sur *Desktop Wallpaper*.
   - Puis *enable* pour activer cette fonction.
   - Spécifier le chemin vers le fond d’écran : `C:\Users\Administrator\Downloads\logo_pg`.

Ensuite, nous irons dans le sous-menu suivant :
`User Configuration > Policies > Administrative Templates > Control Panel > Personalization`

2. **Empêcher la modification du fond d’écran :**
   - Double-cliquer sur *Prevent changing desktop background*, puis *Enable*. Et *Apply*, *Okay*.

De cette manière, le fond d’écran ne peut pas être modifié. Nous obtenons le menu suivant :
<img width="800" alt="Capture d’écran 2024-07-16 à 11 25 39" src="https://github.com/user-attachments/assets/b2bc4fe3-7180-4400-8005-486ddd7198ee">

# C- GPO pour la gestion de l’alimentation

Ici, nous créons un GPO qui va permettre une bonne gestion de l’alimentation, et ainsi permettre une optimisation de l’énergie de Pharmgreen.

## Navigation dans les sous-menus après la création du GPO

1. **Computer Configuration**
2. **Policies**
3. **Administrative Templates**
4. **System**
5. **Power Management**

### Paramétrage du délai de mise en veille

- **Specify the system sleep timeout (plugged in)** dans **Sleep settings**.

Ici, nous avons choisi un délai de **5 minutes** avant que les ordinateurs se mettent en veille. Au-delà d’une économie d’énergie, cela permet de reverrouiller l’ordinateur en cas d’oubli des utilisateurs lors de leurs départs.

### Sélection du plan d'alimentation actif

- **Select an active power plan**

Cela permet de choisir le type d'efficience des ordinateurs. Ici, nous choisissons le **mode basse consommation**.






