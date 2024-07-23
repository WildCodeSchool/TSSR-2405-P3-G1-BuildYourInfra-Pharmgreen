# Réglage télémétrie pour utilisateurs et ordinateurs

## A- Créer un GPO Général sur la télémétrie

Dans l'éditeur de stratégie de groupe, naviguer dans le sous-menu suivant :

*Computer Configuration -> Preferences -> Windows Settings -> Registry*

Puis, clique droit et sélectionnez **New** -> **Registry Item**.

Configurer comme suit :
- **Action**: Update
- **Hive**: HKEY_LOCAL_MACHINE
- **Key Path**: SOFTWARE\Policies\Microsoft\Windows\DataCollection
- **Value Name**: AllowTelemetry
- **Value Type**: REG_DWORD
- **Value Data**: 0

## B- Créer un Script
Créer le script suivant pour récupérer le GPO Général :

*New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force*
*Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0*


## C- Créer le GPO pour les Ordinateurs:

Une fois le GPO créé, naviguer dans le sous menu suivant:

*Computer Configuration -> Policies -> Windows Settings -> Scripts (Startup/Shutdown)*

Ajouter le chemin du script en **Startup**.

## D- Créer le GPO pour les utilisateurs:

Une fois le GPO créé, naviguer dans le sous menu suivant:

*User Configuration -> Policies -> Windows Settings -> Scripts (Logon/Logoff)*

Puis, ajouter le script en **Logon**.

## E- NB

La valeur **0** est pour une politique de télémétrie stricte. Pharmgreen étant une OIV, il ne faut pas que ses données puissent fuiter.
