# 🛰️ Projet Radar 2D

## 📝 Description du Projet
Ce projet vise à concevoir un **radar 2D fonctionnant sur une carte FPGA**, capable de détecter des obstacles en utilisant un télémètre à ultrasons. Les données sont visualisées graphiquement sur un écran connecté via VGA, et une communication UART permet d'envoyer et de recevoir des informations sur un terminal PC.

### 🚀 Fonctionnalités principales :
- 📡 Détection d'obstacles via un télémètre ultrasonique.
- 🖥️ Affichage graphique en 2D (cercles concentriques, lignes radiales et obstacles représentés en rouge).
- 🔄 Contrôle du balayage du radar à l'aide d'un servomoteur.
- 💾 Communication UART bidirectionnelle pour configurer et exporter les données vers un terminal (TeraTerm, Minicom, etc.).

## 🛠️ Technologies Utilisées
- **VHDL** : Pour la conception des IPs personnalisées (UART, télémètre, etc.).
- **Quartus Prime** : Pour la compilation, simulation et déploiement sur FPGA.
- **Analog Discovery** : Pour les tests matériels (substitution du convertisseur série-USB).
- **Nios II** : Intégration autour d’un processeur soft-core.

## 📂 Architecture du Projet
Le projet est divisé en plusieurs parties :
1. **Conception des IPs** :
   - Télémètre Ultrason (détection des distances).
   - Servomoteur (contrôle de l'angle du radar).
   - UART (transmission et réception des données).
2. **Intégration Avalon** :
   - Création et simulation des interfaces pour le système Nios II.
3. **Interface VGA** :
   - Affichage des données sur un écran pour visualisation en temps réel.
4. **Communication UART** :
   - Envoi des données cartographiées et réception des commandes utilisateur.

## 📚 Documentation Technique
### 🖥️ Simulation & Résultats
- **[`CR_Pj_LADJICI_Ayoub.pdf`](./CR_Pj_LADJICI_Ayoub.pdf)** :
  - Rapport détaillant la conception, les simulations et les tests réalisés.

### 📜 Code Source
- **[`src`](./src/)** :
  - Contient l’ensemble des fichiers VHDL, les testbenchs, ainsi que le fichier top-level pour la carte FPGA.
  
### 📊 Ressources Complémentaires
- **[`fichiers_test`](./fichiers_test/)** :
  - Commandes pour tester le projet avec des outils tels que TeraTerm ou Minicom.

## 🚀 Installation et Utilisation

### 📥 Prérequis
- **Quartus Prime** (Version utilisée : 18.1).
- Une carte FPGA compatible (MAX 10 utilisée dans ce projet).
- Un terminal série (TeraTerm, Minicom, ou équivalent).
- Analog Discovery ou un convertisseur série-USB.

### 📂 Configuration du Projet
1. **Clonage du dépôt :**
   ```bash
   git clone https://github.com/AyoubLADJICI/Radar_2D_Fpga.git
   cd Radar_2D_Fpga

