/*
=========================================================
04_silver_create_table.sql
Tables SILVER = données propres, typées, normalisées
=========================================================
*/

CREATE TABLE silver.adherents (
    id_adherent_src TEXT PRIMARY KEY,
    nom TEXT,
    prenom TEXT,
    date_naissance DATE,
    sexe CHAR(1),
    code_postal VARCHAR(5),
    ville TEXT,
    email TEXT,
    telephone TEXT
);

CREATE TABLE silver.contrats (
    id_contrat_src TEXT PRIMARY KEY,
    id_adherent_src TEXT,
    date_debut DATE,
    date_fin DATE,
    type_contrat TEXT,
    regime TEXT,
    canal_vente TEXT
);

CREATE TABLE silver.adhesions (
    id_adhesion_src TEXT PRIMARY KEY,
    id_adherent_src TEXT,
    id_contrat_src TEXT,
    date_adhesion DATE,
    date_resiliation DATE,
    statut TEXT,
    prime_annuelle NUMERIC(14,2),
    code_produit TEXT,
    code_garanties TEXT
);

CREATE TABLE silver.sinistres (
    id_sinistre_src TEXT PRIMARY KEY,
    id_adherent_src TEXT,
    id_contrat_src TEXT,
    date_survenance DATE,
    date_declaration DATE,
    type_sinistre TEXT,
    code_garantie TEXT,
    statut_dossier TEXT,
    reserve_brute NUMERIC(14,2),
    reserve_nette NUMERIC(14,2)
);

CREATE TABLE silver.reglements (
    id_reglement_src TEXT PRIMARY KEY,
    id_sinistre_src TEXT,
    date_reglement DATE,
    montant_reglement NUMERIC(14,2),
    type_reglement TEXT,
    mode_paiement TEXT
);
