🧱 Architecture cible (Bronze / Silver / Gold)
🗂️ Organisation Data Mesh par domaines

📋 Plan de travail structuré
🥉 Scripts Bronze (ingestion brute)**
🥈 Scripts Silver (nettoyage + règles de gestion)**
🥇 Modèle Gold – Datamarts :**

Domaine 1 : Historique des adhésions
Domaine 2 : Sinistralité
📐 Modèle en étoile (Star Schema)
📜 Règles de gestion formalisées (à mettre sur GitHub)
🧠 Explication pédagogique du code PostgreSQL

🗂️ 2. Domaines Data Mesh
🟦 Domaine 1 : Adhésion
Adhérents
Contrats
Adhésions
Produits

🟥 Domaine 2 : Sinistralité
Sinistres
Règlements
Réserves
Garanties

Chaque domaine :
  a ses tables Silver
  expose son propre datamart Gold
  possède ses règles de gestion


📋 3. Plan de travail projet
Phase 1 – Modélisation
Identifier entités métier
Définir grain des faits
Définir dimensions

Phase 2 – Bronze
Création schémas
Import CSV brut
Ajout colonnes techniques (date ingestion)

Phase 3 – Silver
Nettoyage
Standardisation
Typage
Déduplication
Règles métier

Phase 4 – Gold
Modèle en étoile
Tables de faits
Dimensions
Indicateurs

Phase 5 – Documentation GitHub
README Architecture
Dictionnaire de données
Règles de gestion
Scripts SQL commentés
