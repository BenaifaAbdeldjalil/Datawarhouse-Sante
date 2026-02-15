-- Table bronze d’adhésions (historique des ajouts / résiliations)
CREATE TABLE IF NOT EXISTS bronze.adhesion_raw (
    source_file        text,
    load_ts            timestamp default now(),
    id_adhesion_src    text,
    id_adherent_src    text,
    id_contrat_src     text,
    date_adhesion_raw  text,
    date_resiliation_raw text,
    statut_raw         text,
    prime_annuelle_raw text,
    code_produit_raw   text,
    code_garanties_raw text,
    other_json_raw     jsonb
);

-- Table bronze des adhérents
CREATE TABLE IF NOT EXISTS bronze.adherent_raw (
    source_file        text,
    load_ts            timestamp default now(),
    id_adherent_src    text,
    nom_raw            text,
    prenom_raw         text,
    date_naissance_raw text,
    sexe_raw           text,
    code_postal_raw    text,
    ville_raw          text,
    email_raw          text,
    telephone_raw      text
);

-- Table bronze des contrats
CREATE TABLE IF NOT EXISTS bronze.contrat_raw (
    source_file        text,
    load_ts            timestamp default now(),
    id_contrat_src     text,
    id_adherent_src    text,
    date_debut_raw     text,
    date_fin_raw       text,
    type_contrat_raw   text,
    regime_raw         text,
    canal_vente_raw    text
);
