# Mise en place du pfsense:
## A- Installation

Lors de l’installation, suivre les instructions du proxmox, en séléctionnant l’iso du pfsense, 2go de ram, L’interface réseau g2 et vmbr1 en intel 1000.
Nous arrivons donc avec les réglages matériels suivants:

<img width="586" alt="Capture d’écran 2024-07-25 à 09 46 52" src="https://github.com/user-attachments/assets/16f01ea6-a7be-47a4-9537-3091c2c9fa95">

Au lancement, suivre les instructions pour arriver aux réglages suivants:

<img width="716" alt="Capture d’écran 2024-07-24 à 14 15 42" src="https://github.com/user-attachments/assets/0220b0d2-54ed-4857-8a99-ba70075d43ba">


## B- Paramétrage du réseau:

Une fois dans le menu du pfsense, sélectionnez le sous-menu 2 pour paramétrer le réseau.
D’abord, le WAN, que nous paramétrons en 10.0.0.4/29. Nous refusons le DHCP et laissons pour plus tard l’IPV6.

<img width="823" alt="Capture d’écran 2024-07-24 à 14 33 04" src="https://github.com/user-attachments/assets/0da95f40-8466-4681-a3b8-68f6a0ad97c5">

<img width="920" alt="Capture d’écran 2024-07-24 à 14 20 54" src="https://github.com/user-attachments/assets/6d56c33a-793d-463d-ada8-e5f0b023cd5c">


Pour le LAN, nous le paramétrons sur le réseau 192.168.1.254/24. Nous refusons également le DHCP et laissons pour plus tard l’IPV6.

## C- Interface graphique et règle du “Deny All”

Sur une machine cliente, ouvrir le navigateur et entrer l’adresse du pfsense (192.168.1.254).
Nous arrivons sur une interface graphique du pfsense.

<img width="1177" alt="Capture d’écran 2024-07-25 à 09 49 40" src="https://github.com/user-attachments/assets/0ca3a3ee-2335-4bcf-b3b5-dff3e062836d">

Choisir en hostname pfsensepharmgreen,  et en nom de domaine pharmgreen.com.

<img width="641" alt="Capture d’écran 2024-07-24 à 14 47 06" src="https://github.com/user-attachments/assets/b1eaf632-65ea-4353-ac4a-b8f2235749e1">

Pour le DNS nous rentrons l’adresse du serveur principal, le windows server 2022 gui, 192.168.1.5.

 <img width="649" alt="Capture d’écran 2024-07-24 à 14 47 32" src="https://github.com/user-attachments/assets/b3511312-5c2b-4dba-8ec6-69d2156b1641">

Pour le mot de passe nous choisissons Azerty1*.

Nous arrivons avec ces réglages de base:

<img width="529" alt="Capture d’écran 2024-07-25 à 09 35 16" src="https://github.com/user-attachments/assets/1aa84384-ebe1-4ca4-b345-7643a81a62ce">

<img width="524" alt="Capture d’écran 2024-07-25 à 09 35 43" src="https://github.com/user-attachments/assets/c9ce01a1-0dbb-42e5-9ca8-7869214bbbd8">



Ensuite, nous allons paramétrer le parefeu sous le principe du “Deny all”, à savoir, bloquer toute entrée et sortie dans le trafic réseau, puis réotoriser uniquement ce qui est utile pour l’entreprise. De cette maniere, nous réduisons la surface de vulnérabilité et pouvons renforcer la sécurité du réseau.

Ainsi, nous bloquons la règle ipv4 dans le menu *Firewall>Rules>LAN*:

<img width="786" alt="Capture d’écran 2024-07-24 à 14 54 10" src="https://github.com/user-attachments/assets/d81c36ce-ad41-4a63-8498-c741a9fbc0dc">


Ensuite, nous créons des règles pour le ping, le HTTP/HTTPS et le DNS:
<img width="1098" alt="Capture d’écran 2024-07-25 à 09 43 37" src="https://github.com/user-attachments/assets/ae3896f3-142a-4ae2-94d2-fae362db7a70">

