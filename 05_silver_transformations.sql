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
