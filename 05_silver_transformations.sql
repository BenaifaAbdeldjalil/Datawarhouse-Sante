-- Load dim_adherent
INSERT INTO silver.dim_adherent (
    id_adherent_src, nom, prenom, date_naissance,
    sexe, code_postal, ville, email, telephone
)
SELECT DISTINCT
    id_adherent_src,
    NULLIF(trim(nom_raw), '') as nom,
    NULLIF(trim(prenom_raw), '') as prenom,
    CASE
        WHEN date_naissance_raw ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
             THEN date_naissance_raw::date
        ELSE NULL
    END as date_naissance,
    CASE upper(trim(sexe_raw))
        WHEN 'M' THEN 'M'
        WHEN 'F' THEN 'F'
        ELSE NULL
    END as sexe,
    NULLIF(trim(code_postal_raw), '') as code_postal,
    NULLIF(trim(ville_raw), '') as ville,
    NULLIF(trim(email_raw), '') as email,
    NULLIF(trim(telephone_raw), '') as telephone
FROM bronze.adherent_raw
WHERE id_adherent_src IS NOT NULL;


-- Load dim_contrat
INSERT INTO silver.dim_contrat (
    id_contrat_src, id_adherent_src,
    date_debut, date_fin, type_contrat,
    regime, canal_vente
)
SELECT DISTINCT
    c.id_contrat_src,
    c.id_adherent_src,
    CASE
        WHEN c.date_debut_raw ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
             THEN c.date_debut_raw::date
        ELSE NULL
    END as date_debut,
    CASE
        WHEN c.date_fin_raw ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
             THEN c.date_fin_raw::date
        ELSE NULL
    END as date_fin,
    upper(trim(c.type_contrat_raw)) as type_contrat,
    upper(trim(c.regime_raw)) as regime,
    upper(trim(c.canal_vente_raw)) as canal_vente
FROM bronze.contrat_raw c
WHERE c.id_contrat_src IS NOT NULL;



-- Load fait_adhesion
INSERT INTO silver.fait_adhesion (
    id_adhesion_src, id_adherent_src, id_contrat_src,
    sk_adherent, sk_contrat,
    date_adhesion, date_resiliation,
    statut, prime_annuelle, code_produit, code_garanties
)
SELECT
    a.id_adhesion_src,
    a.id_adherent_src,
    a.id_contrat_src,
    da.sk_adherent,
    dc.sk_contrat,
    CASE
        WHEN a.date_adhesion_raw ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
             THEN a.date_adhesion_raw::date
        ELSE NULL
    END as date_adhesion,
    CASE
        WHEN a.date_resiliation_raw ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
             THEN a.date_resiliation_raw::date
        ELSE NULL
    END as date_resiliation,
    CASE upper(trim(a.statut_raw))
        WHEN 'A' THEN 'ACTIF'
        WHEN 'ACTIF' THEN 'ACTIF'
        WHEN 'R' THEN 'RESILIE'
        WHEN 'RESILIE' THEN 'RESILIE'
        ELSE 'INCONNU'
    END as statut,
    CASE
        WHEN prime_annuelle_raw ~ '^[0-9]+([.,][0-9]+)?$'
             THEN replace(prime_annuelle_raw, ',', '.')::numeric(14,2)
        ELSE NULL
    END as prime_annuelle,
    upper(trim(a.code_produit_raw)) as code_produit,
    upper(trim(a.code_garanties_raw)) as code_garanties
FROM bronze.adhesion_raw a
LEFT JOIN silver.dim_adherent da
    ON da.id_adherent_src = a.id_adherent_src
LEFT JOIN silver.dim_contrat dc
    ON dc.id_contrat_src = a.id_contrat_src;

-- Dimension sinistre
CREATE TABLE IF NOT EXISTS silver.dim_sinistre (
    sk_sinistre          bigserial primary key,
    id_sinistre_src      text not null,
    id_adherent_src      text,
    id_contrat_src       text,
    date_survenance      date,
    date_declaration     date,
    type_sinistre        text,
    code_garantie        text,
    statut_dossier       text,
    reserve_brute        numeric(14,2),
    reserve_nette        numeric(14,2),
    dt_integration       timestamp default now()
);

-- Fait règlement (granularité : un règlement)
CREATE TABLE IF NOT EXISTS silver.fait_reglement (
    sk_reglement         bigserial primary key,
    id_reglement_src     text not null,
    id_sinistre_src      text not null,
    sk_sinistre          bigint,
    date_reglement       date,
    montant_reglement    numeric(14,2),
    type_reglement       text,
    mode_paiement        text,
    dt_integration       timestamp default now()
);

INSERT INTO silver.dim_sinistre (
    id_sinistre_src, id_adherent_src, id_contrat_src,
    date_survenance, date_declaration,
    type_sinistre, code_garantie, statut_dossier,
    reserve_brute, reserve_nette
)
SELECT DISTINCT
    s.id_sinistre_src,
    s.id_adherent_src,
    s.id_contrat_src,
    CASE
        WHEN s.date_survenance_raw ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
             THEN s.date_survenance_raw::date
        ELSE NULL
    END as date_survenance,
    CASE
        WHEN s.date_declaration_raw ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
             THEN s.date_declaration_raw::date
        ELSE NULL
    END as date_declaration,
    upper(trim(s.type_sinistre_raw)) as type_sinistre,
    upper(trim(s.code_garantie_raw)) as code_garantie,
    upper(trim(s.statut_dossier_raw)) as statut_dossier,
    CASE
        WHEN s.reserve_brute_raw ~ '^[0-9]+([.,][0-9]+)?$'
             THEN replace(s.reserve_brute_raw, ',', '.')::numeric(14,2)
        ELSE 0
    END as reserve_brute,
    CASE
        WHEN s.reserve_nette_raw ~ '^[0-9]+([.,][0-9]+)?$'
             THEN replace(s.reserve_nette_raw, ',', '.')::numeric(14,2)
        ELSE 0
    END as reserve_nette
FROM bronze.sinistre_raw s
WHERE s.id_sinistre_src IS NOT NULL;

INSERT INTO silver.fait_reglement (
    id_reglement_src, id_sinistre_src, sk_sinistre,
    date_reglement, montant_reglement,
    type_reglement, mode_paiement
)
SELECT
    r.id_reglement_src,
    r.id_sinistre_src,
    ds.sk_sinistre,
    CASE
        WHEN r.date_reglement_raw ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
             THEN r.date_reglement_raw::date
        ELSE NULL
    END as date_reglement,
    CASE
        WHEN r.montant_reglement_raw ~ '^[0-9]+([.,][0-9]+)?$'
             THEN replace(r.montant_reglement_raw, ',', '.')::numeric(14,2)
        ELSE 0
    END as montant_reglement,
    upper(trim(r.type_reglement_raw)) as type_reglement,
    upper(trim(r.mode_paiement_raw)) as mode_paiement
FROM bronze.reglement_raw r
LEFT JOIN silver.dim_sinistre ds
    ON ds.id_sinistre_src = r.id_sinistre_src
WHERE r.id_reglement_src IS NOT NULL;

