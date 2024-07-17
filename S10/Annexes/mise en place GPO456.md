## **Mise en place GPO "Group Policy Object"**

### **GPO 4: Mise en place d'une GPO WINDOWS UPDATE :**   

Se rendre dans "Group Policy Objects", taper gpmc.msc puis cliquer sur l'icone qui s'affiche pour l'ouvrir.    

![C1a](https://github.com/user-attachments/assets/e89aa85d-2c37-46e7-b1a9-77d1daeb8efb)     

La fenêtre "Group Policy Management" suivante s'affiche :   

**1. Créer la GPO :**   

Faire un clic droit sur "Group Policy Objects" puis choisir "New".  

![CAP1_newGPO](https://github.com/user-attachments/assets/d852f8b0-a78f-4b58-8c19-c44f4a2e24dd)    
   
Dans la console de gestion des stratégies de groupe :    

Donner un nom à la GPO, par exemple **"Gestion de Windows Update"**.   

**2. Configurer les paramètres de Windows Update désirés :**          

Se déplacer dans l'arborescence : "Computer configuration" -> "Administration Templates" -> "Windows Components" -> "Windows Update".    

![CAP3_windowsupdate](https://github.com/user-attachments/assets/7637c0f6-c18f-4fb2-accd-dda1c58b91e0)    

Configurez les paramètres selon vos besoins, comme par exemple :    

- Configurer les mises à jour automatiques : "Activez et choisissez le mode souhaité" (p.ex., Télécharger automatiquement et planifier l'installation).   
- Spécifier le jour et l'heure pour installer les mises à jour :   
"Configurez les jours et heure spécifiques pour les installations."         


![C4_modifapporteeautoupdate](https://github.com/user-attachments/assets/35d63c1e-22a7-4911-a9a9-885170716403)    

 
**GPO 5: Base de registre (Blocage de l'accès à la base de registre)**       

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

https://github.com/WildCodeSchool/TSSR-2405-P3-G2-BuildYourInfra-Pharmgreen/blob/main/S10/Annexes/Capture/CA4_enableoption.PNG   

**GPO 6: Blocage du panneau de configuration**    

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
