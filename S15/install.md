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
