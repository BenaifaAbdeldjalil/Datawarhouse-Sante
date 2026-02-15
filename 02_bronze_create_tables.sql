/*
=========================================================
02_bronze_create_tables.sql
Tables BRONZE = données brutes non transformées
Aucune règle métier appliquée
=========================================================
*/

CREATE TABLE bronze.adherent_raw (
    id_adherent_src TEXT,
    nom_raw TEXT,
    prenom_raw TEXT,
    date_naissance_raw TEXT,
    sexe_raw TEXT,
    code_postal_raw TEXT,
    ville_raw TEXT,
    email_raw TEXT,
    telephone_raw TEXT,
    ingestion_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bronze.contrat_raw (
    id_contrat_src TEXT,
    id_adherent_src TEXT,
    date_debut_raw TEXT,
    date_fin_raw TEXT,
    type_contrat_raw TEXT,
    regime_raw TEXT,
    canal_vente_raw TEXT,
    ingestion_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bronze.adhesion_raw (
    id_adhesion_src TEXT,
    id_adherent_src TEXT,
    id_contrat_src TEXT,
    date_adhesion_raw TEXT,
    date_resiliation_raw TEXT,
    statut_raw TEXT,
    prime_annuelle_raw TEXT,
    code_produit_raw TEXT,
    code_garanties_raw TEXT,
    ingestion_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bronze.sinistre_raw (
    id_sinistre_src TEXT,
    id_adherent_src TEXT,
    id_contrat_src TEXT,
    date_survenance_raw TEXT,
    date_declaration_raw TEXT,
    type_sinistre_raw TEXT,
    code_garantie_raw TEXT,
    statut_dossier_raw TEXT,
    reserve_brute_raw TEXT,
    reserve_nette_raw TEXT,
    ingestion_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bronze.reglement_raw (
    id_reglement_src TEXT,
    id_sinistre_src TEXT,
    date_reglement_raw TEXT,
    montant_reglement_raw TEXT,
    type_reglement_raw TEXT,
    mode_paiement_raw TEXT,
    ingestion_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
