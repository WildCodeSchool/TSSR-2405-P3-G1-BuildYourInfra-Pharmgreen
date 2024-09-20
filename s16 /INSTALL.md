### Étape 1 : Configuration du tunnel IPsec sur PFSense Site 1

#### 1.1 Accédez à l'interface PFSense Site 1

1. Allez dans **VPN > IPsec**.
2. Cliquez sur **Add P1** (Phase 1) pour ajouter une nouvelle configuration de phase 1.

#### 1.2 Configuration de la phase 1

- **Key Exchange version** : Sélectionnez **IKEv2** (recommandé pour une meilleure sécurité et performances).
- **Remote Gateway** : Entrez l'adresse IP publique de PFSense Site 2.
- **Authentication Method** : Sélectionnez **Mutual PSK** (pre-shared key).
- **Pre-Shared Key** : Définissez une clé partagée (que vous utiliserez aussi sur le Site 2).
- **Encryption Algorithm** : Sélectionnez un ensemble d'algorithmes forts. Par exemple :
  - **Encryption Algorithm** : AES 256
  - **Hash Algorithm** : SHA256
  - **DH Group** : 14 (modp2048) (choisir un groupe fort pour la sécurité)
- **Lifetime** : Vous pouvez laisser la valeur par défaut ou ajuster selon vos besoins (28800 secondes est une valeur courante).
  
Ensuite, cliquez sur **Save**.

#### 1.3 Configuration de la phase 2

1. Après avoir configuré la phase 1, vous serez redirigé vers l’écran de configuration de phase 2. Cliquez sur **Add P2** pour configurer la phase 2.

- **Mode** : Sélectionnez **Tunnel IPv4**.
- **Local Network** : Sélectionnez "Network" et entrez le réseau local de ce site (par exemple, `192.168.1.0/24`).
- **Remote Network** : Entrez le réseau local de Site 2 (par exemple, `192.168.2.0/24`).
- **Protocol** : ESP.
- **Encryption Algorithms** : Sélectionnez AES 256 (ou une autre variante forte) et SHA256.
- **PFS key group** : 14 (modp2048) ou plus élevé.

Cliquez sur **Save**, puis **Apply Changes** pour activer la configuration IPsec sur Site 1.

### Étape 2 : Configuration du tunnel IPsec sur PFSense Site 2

Répétez les étapes de configuration sur PFSense Site 2, en ajustant les paramètres pour qu’ils correspondent à ceux du Site 1, mais avec des inversions des adresses IP et réseaux.

#### 2.1 Configuration de la phase 1 sur Site 2

1. Accédez à **VPN > IPsec**, puis cliquez sur **Add P1**.

- **Key Exchange version** : IKEv2.
- **Remote Gateway** : Entrez l'adresse IP publique de PFSense Site 1.
- **Authentication Method** : Mutual PSK.
- **Pre-Shared Key** : Utilisez la même clé partagée que sur le Site 1.
- **Encryption Algorithm** : AES 256, SHA256, DH Group 14 (modp2048).
- **Lifetime** : 28800 secondes ou la même valeur utilisée sur le Site 1.

Cliquez sur **Save**.

#### 2.2 Configuration de la phase 2 sur Site 2

1. Cliquez sur **Add P2** pour configurer la phase 2.

- **Mode** : Tunnel IPv4.
- **Local Network** : Entrez le réseau local de ce site (par exemple, `192.168.2.0/24`).
- **Remote Network** : Entrez le réseau local de Site 1 (par exemple, `192.168.1.0/24`).
- **Encryption Algorithms** : AES 256 et SHA256.
- **PFS key group** : 14 (modp2048).

Cliquez sur **Save**, puis **Apply Changes**.

### Étape 3 : Ajouter les règles de pare-feu IPsec

Par défaut, PFSense bloque le trafic sur l’interface IPsec. Vous devrez donc créer des règles de pare-feu pour permettre la communication via le VPN.

#### 3.1 Configuration des règles sur PFSense Site 1

1. Allez dans **Firewall > Rules > IPsec**.
2. Cliquez sur **Add** pour ajouter une nouvelle règle.
3. Configurez la règle comme suit :
   - **Action** : Pass.
   - **Protocol** : Any (ou si vous souhaitez limiter, vous pouvez sélectionner ICMP pour ping ou TCP/UDP).
   - **Source** : `192.168.2.0/24` (le réseau du site 2).
   - **Destination** : `192.168.1.0/24` (le réseau local du site 1).

Cliquez sur **Save** et appliquez les changements.

#### 3.2 Configuration des règles sur PFSense Site 2

1. Allez dans **Firewall > Rules > IPsec**.
2. Cliquez sur **Add** et configurez une règle identique à celle du Site 1, mais avec des adresses inversées :
   - **Source** : `192.168.1.0/24` (le réseau du site 1).
   - **Destination** : `192.168.2.0/24` (le réseau local du site 2).

Cliquez sur **Save** et appliquez les changements.

### Étape 4 : Vérification et test

1. Allez dans **Status > IPsec** sur chaque PFSense pour vérifier si le tunnel est établi.
   - Vous devriez voir que la phase 1 et la phase 2 sont "established" ou "connected".
   
2. Testez la connexion en faisant un **ping** depuis un appareil du réseau du Site 1 vers une machine sur le réseau du Site 2, et inversement.

### Résumé des configurations :

- **Phase 1** :
  - Remote Gateway : L'adresse IP publique de l'autre PFSense.
  - Authentication Method : Mutual PSK.
  - Encryption : AES 256, SHA256, DH Group 14.
  - Pre-shared key : La même clé sur les deux sites.
  
- **Phase 2** :
  - Local Network : Réseau local du site.
  - Remote Network : Réseau local de l'autre site.
  - Encryption : AES 256, SHA256, PFS Group 14.

- **Règles de pare-feu** : Autoriser le trafic entre les réseaux locaux via l'interface IPsec sur les deux sites.

Avec cette configuration, vous devriez pouvoir établir un VPN IPsec fonctionnel entre deux PFSense, interconnectant vos deux réseaux distants.
