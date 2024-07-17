Mise en place GPO
**4. Mise en place d'une GPO WINDOWS UPDATE:**   
Pour créer une nouvelle GPO, se rendre dans "Group Policy Objects",taper gpmc.msc puis cliquer sur l'icone affiché.  
La fenêtre 

GPO 1 : Gestion de Windows Update   

**Créer la GPO :**   

Dans la console de gestion des stratégies de groupe :   

#Donnez un nom à la GPO, par exemple "Gestion de Windows Update".   
Configurer les paramètres de Windows Update :   

Faire un clic droit sur "Group Policy Objects" puis choisir "New".   
Allez à Configuration ordinateur -> Modèles d'administration -> Composants Windows -> Windows Update.   
Configurez les paramètres selon vos besoins, comme par exemple :   
Configurer les mises à jour automatiques : Activez et choisissez le mode souhaité (p.ex., Télécharger automatiquement et planifier l'installation).   
Spécifier le jour et l'heure pour installer les mises à jour : Configurez les heures et jours spécifiques pour les installations.    
 
**5. GPO Base de registre**

GPO 2 : Blocage de l'accès à la base de registre   
Créer la GPO :   

Suivre les mêmes étapes que précédemment pour créer une nouvelle GPO, la nommer par exemple "Blocage Accès Registre".
Configurer les paramètres de restriction :   

Faire un clic droit sur la GPO nouvellement créée et sélectionner "Edit".  
On se trouve maintenant dans "Group Policy Management Editor"
CB
Allez à Configuration User Configuration -> Administrative Templates -> System.   
CA3   
Recherchez et activez la stratégie Empêcher l'accès aux outils de modification du registre.  
Faire "Edit" puis dans la fenêtre d'option activer (enabled) puis "Apply" puis "OK"   
CA4   

