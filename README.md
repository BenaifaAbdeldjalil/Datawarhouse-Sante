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
