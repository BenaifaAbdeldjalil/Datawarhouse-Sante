-- =========================================================
-- 05_silver_transformations.sql
-- Alimentation des tables SILVER depuis BRONZE
-- Avec nettoyage complet, typage et règles métier
-- =========================================================

-- ============================================
-- TABLE : silver.adherents
-- Nettoyage et standardisation des adhérents
-- ============================================

INSERT INTO silver.adherents (
    id_adherent_src, nom, prenom, date_naissance, sexe,
    code_postal, ville, email, telephone,
    date_chargement, source_system
)
SELECT DISTINCT
    -- Supprime les espaces superflus
    trim(id_adherent_src) AS id_adherent_src,

    -- Nom en majuscule, vide transformé en NULL
    NULLIF(trim(upper(nom_raw)), '') AS nom,

    -- Prénom en capitalisation correcte, vide transformé en NULL
    NULLIF(trim(initcap(prenom_raw)), '') AS prenom,

    -- Parsing multi-format des dates de naissance
    CASE 
        WHEN date_naissance_raw ~ '^\d{2}/\d{2}/\d{4}$' THEN to_date(date_naissance_raw, 'DD/MM/YYYY')
        WHEN date_naissance_raw ~ '^\d{4}-\d{2}-\d{2}$' THEN date_naissance_raw::date
        WHEN date_naissance_raw ~ '^\d{2}-\d{2}-\d{4}$' THEN to_date(date_naissance_raw, 'DD-MM-YYYY')
        ELSE NULL -- Si format inconnu
    END AS date_naissance,

    -- Normalisation du sexe
    CASE upper(trim(sexe_raw))
        WHEN 'M','H' THEN 'M'
        WHEN 'F' THEN 'F'
        ELSE NULL
    END AS sexe,

    -- Code postal uniquement chiffres
    regexp_replace(trim(code_postal_raw), '[^0-9]', '', 'g') AS code_postal,

    -- Ville en capitalisation correcte, vide transformé en NULL
    NULLIF(trim(initcap(ville_raw)), '') AS ville,

    -- Email en minuscules, vide transformé en NULL
    NULLIF(lower(trim(email_raw)), '') AS email,

    -- Téléphone : suppression caractères non numériques
    regexp_replace(regexp_replace(trim(telephone_raw), '[^\d]', '', 'g'), '^0', '0', 'g') AS telephone,

    -- Colonne technique pour traçabilité
    CURRENT_TIMESTAMP AS date_chargement,

    -- Source des données
    'BRONZE' AS source_system

FROM bronze.adherent_raw 
WHERE trim(id_adherent_src) != ''; -- Ignore les lignes sans ID

-- ============================================
-- TABLE : silver.contrats
-- Nettoyage et standardisation des contrats
-- ============================================

INSERT INTO silver.contrats (
    id_contrat_src, id_adherent_src, date_debut, date_fin,
    type_contrat, regime, canal_vente,
    date_chargement, source_system
)
SELECT DISTINCT
    trim(id_contrat_src),
    trim(id_adherent_src),

    -- Parsing date début multi-format
    CASE 
        WHEN date_debut_raw ~ '^\d{4}-\d{2}-\d{2}$' THEN date_debut_raw::date
        WHEN date_debut_raw ~ '^\d{2}/\d{2}/\d{4}$' THEN to_date(date_debut_raw, 'DD/MM/YYYY')
        WHEN date_debut_raw ~ '^\d{2}-\d{2}-\d{4}$' THEN to_date(date_debut_raw, 'DD-MM-YYYY')
        ELSE NULL
    END AS date_debut,

    -- Parsing date fin multi-format
    CASE 
        WHEN date_fin_raw ~ '^\d{4}-\d{2}-\d{2}$' THEN date_fin_raw::date
        WHEN date_fin_raw ~ '^\d{2}/\d{2}/\d{4}$' THEN to_date(date_fin_raw, 'DD/MM/YYYY')
        WHEN date_fin_raw ~ '^\d{2}-\d{2}-\d{4}$' THEN to_date(date_fin_raw, 'DD-MM-YYYY')
        ELSE NULL
    END AS date_fin,

    -- Normalisation textes en majuscules
    upper(trim(type_contrat_raw)) AS type_contrat,
    upper(trim(regime_raw)) AS regime,
    upper(trim(canal_vente_raw)) AS canal_vente,

    CURRENT_TIMESTAMP AS date_chargement,
    'BRONZE' AS source_system

FROM bronze.contrat_raw;

-- ============================================
-- TABLE : silver.adhesions
-- Nettoyage des adhésions, parsing montants et mapping statut
-- ============================================

INSERT INTO silver.adhesions (
    id_adhesion_src, id_adherent_src, id_contrat_src,
    date_adhesion, date_resiliation, statut,
    prime_annuelle, code_produit, code_garanties,
    date_chargement, source_system
)
SELECT
    trim(id_adhesion_src),
    trim(id_adherent_src),
    trim(id_contrat_src),

    -- Parsing date adhésion
    CASE 
        WHEN date_adhesion_raw ~ '^\d{4}-\d{2}-\d{2}$' THEN date_adhesion_raw::date
        WHEN date_adhesion_raw ~ '^\d{2}/\d{2}/\d{4}$' THEN to_date(date_adhesion_raw, 'DD/MM/YYYY')
        ELSE NULL
    END AS date_adhesion,

    -- Parsing date résiliation
    CASE 
        WHEN date_resiliation_raw ~ '^\d{4}-\d{2}-\d{2}$' THEN date_resiliation_raw::date
        WHEN date_resiliation_raw ~ '^\d{2}/\d{2}/\d{4}$' THEN to_date(date_resiliation_raw, 'DD/MM/YYYY')
        ELSE NULL
    END AS date_resiliation,

    -- Mapping statut
    CASE upper(trim(statut_raw))
        WHEN 'A','ACTIF' THEN 'ACTIF'
        WHEN 'R','RES','RESILIE' THEN 'RESILIE'
        ELSE 'INCONNU'
    END AS statut,

    -- Parsing montant prime annuelle
    CASE
        WHEN prime_annuelle_raw ~ '^[0-9 ]+[,][0-9]{2}$' 
        THEN replace(regexp_replace(prime_annuelle_raw, '[ €]', '', 'g'), ',', '.')::numeric(14,2)
        WHEN prime_annuelle_raw ~ '^[0-9]+[.][0-9]{2}$' 
        THEN prime_annuelle_raw::numeric(14,2)
        ELSE NULL
    END AS prime_annuelle,

    upper(trim(code_produit_raw)) AS code_produit,
    upper(trim(code_garanties_raw)) AS code_garanties,

    CURRENT_TIMESTAMP AS date_chargement,
    'BRONZE' AS source_system

FROM bronze.adhesion_raw;

-- ============================================
-- TABLE : silver.sinistres
-- Nettoyage des sinistres et sécurisation montants
-- ============================================

INSERT INTO silver.sinistres (
    id_sinistre_src, id_adherent_src, id_contrat_src,
    date_survenance, date_declaration, type_sinistre,
    code_garantie, statut_dossier,
    reserve_brute, reserve_nette,
    date_chargement, source_system
)
SELECT
    trim(id_sinistre_src),
    NULLIF(trim(id_adherent_src), ''),
    NULLIF(trim(id_contrat_src), ''),

    -- Parsing date survenance
    CASE 
        WHEN date_survenance_raw ~ '^\d{4}-\d{2}-\d{2}$' THEN date_survenance_raw::date
        WHEN date_survenance_raw ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN to_date(date_survenance_raw, 'DD/MM/YYYY')
        ELSE NULL
    END AS date_survenance,

    -- Parsing date déclaration
    CASE 
        WHEN date_declaration_raw ~ '^\d{4}-\d{2}-\d{2}$' THEN date_declaration_raw::date
        WHEN date_declaration_raw ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN to_date(date_declaration_raw, 'DD/MM/YYYY')
        ELSE NULL
    END AS date_declaration,

    upper(trim(type_sinistre_raw)) AS type_sinistre,
    upper(trim(code_garantie_raw)) AS code_garantie,

    -- Mapping statut dossier
    CASE upper(trim(statut_dossier_raw))
        WHEN 'OUVERT','OPEN' THEN 'OUVERT'
        WHEN 'CLOTURE','CLOSED' THEN 'CLOTURE'
        WHEN 'RECOURS' THEN 'EN_RECOURS'
        ELSE upper(trim(statut_dossier_raw))
    END AS statut_dossier,

    -- Reserves sécurisées (positives uniquement)
    GREATEST(0, 
        CASE
            WHEN reserve_brute_raw ~ '[0-9]+[,][0-9]{2}' 
            THEN replace(regexp_replace(reserve_brute_raw, '[ €\t\n\r]', '', 'g'), ',', '.')::numeric(14,2)
            WHEN reserve_brute_raw ~ '[0-9.]+' 
            THEN regexp_replace(reserve_brute_raw, '[ €\t\n\r]', '', 'g')::numeric(14,2)
            ELSE 0
        END
    ) AS reserve_brute,

    GREATEST(0, 
        CASE
            WHEN reserve_nette_raw ~ '[0-9]+[,][0-9]{2}' 
            THEN replace(regexp_replace(reserve_nette_raw, '[ €\t\n\r]', '', 'g'), ',', '.')::numeric(14,2)
            WHEN reserve_nette_raw ~ '[0-9.]+' 
            THEN regexp_replace(reserve_nette_raw, '[ €\t\n\r]', '', 'g')::numeric(14,2)
            ELSE 0
        END
    ) AS reserve_nette,

    CURRENT_TIMESTAMP AS date_chargement,
    'BRONZE' AS source_system

FROM bronze.sinistre_raw 
WHERE trim(id_sinistre_src) != '';

-- ============================================
-- TABLE : silver.reglements
-- Nettoyage des règlements et sécurisation montants
-- ============================================

INSERT INTO silver.reglements (
    id_reglement_src, id_sinistre_src,
    date_reglement, montant_reglement,
    type_reglement, mode_paiement,
    date_chargement, source_system
)
SELECT
    trim(id_reglement_src),
    NULLIF(trim(id_sinistre_src), ''),

    -- Parsing date règlement
    CASE 
        WHEN date_reglement_raw ~ '^\d{4}-\d{2}-\d{2}$' THEN date_reglement_raw::date
        WHEN date_reglement_raw ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN to_date(date_reglement_raw, 'DD/MM/YYYY')
        ELSE NULL
    END AS date_reglement,

    -- Montant positif uniquement
    GREATEST(0, 
        CASE
            WHEN montant_reglement_raw ~ '[0-9]+[,][0-9]{2}' 
            THEN replace(regexp_replace(montant_reglement_raw, '[ €\t\n\r]', '', 'g'), ',', '.')::numeric(14,2)
            WHEN montant_reglement_raw ~ '[0-9.]+' 
            THEN regexp_replace(montant_reglement_raw, '[ €\t\n\r]', '', 'g')::numeric(14,2)
            ELSE 0
        END
    ) AS montant_reglement,

    upper(trim(type_reglement_raw)) AS type_reglement,
    upper(trim(mode_paiement_raw)) AS mode_paiement,

    CURRENT_TIMESTAMP AS date_chargement,
    'BRONZE' AS source_system

FROM bronze.reglement_raw 
WHERE trim(id_reglement_src) != '';
