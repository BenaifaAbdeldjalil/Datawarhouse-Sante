-- =========================================================
-- 08_gold_alim.sql
-- Peuplement des tables GOLD depuis SILVER
-- Tables dimensionnelles (d_*) et factuelles (f_*)
-- =========================================================

-- ============================================
-- TABLE DIMENSIONNELLE : d_adherents
-- Grain : un adhérent
-- Calcul de l'âge, du département et segment âge
-- ============================================

INSERT INTO gold.d_adherents (
    id_adherent_src, nom, prenom, age, sexe, departement, segment_age,
    date_chargement, source_system
)
SELECT 
    a.id_adherent_src,
    a.nom,
    a.prenom,
    
    -- Calcul de l'âge à partir de la date de naissance
    CASE 
        WHEN a.date_naissance IS NOT NULL 
        THEN EXTRACT(YEAR FROM age(CURRENT_DATE, a.date_naissance))::int 
        ELSE NULL 
    END AS age,

    a.sexe,

    -- Département à partir des 2 premiers chiffres du code postal
    LEFT(a.code_postal, 2) AS departement,

    -- Segmentation de l'âge
    CASE 
        WHEN EXTRACT(YEAR FROM age(CURRENT_DATE, a.date_naissance)) BETWEEN 18 AND 30 THEN 'JEUNE'
        WHEN EXTRACT(YEAR FROM age(CURRENT_DATE, a.date_naissance)) BETWEEN 31 AND 60 THEN 'ADULTE'
        WHEN EXTRACT(YEAR FROM age(CURRENT_DATE, a.date_naissance)) > 60 THEN 'SENIOR'
        ELSE 'INCONNU'
    END AS segment_age,

    CURRENT_TIMESTAMP AS date_chargement,
    'SILVER' AS source_system

FROM silver.adherents a;

-- ============================================
-- TABLE DIMENSIONNELLE : d_contrats
-- Grain : un contrat
-- ============================================

INSERT INTO gold.d_contrats (
    id_contrat_src, type_contrat, regime, canal_vente,
    date_chargement, source_system
)
SELECT DISTINCT
    c.id_contrat_src,
    c.type_contrat,
    c.regime,
    c.canal_vente,
    CURRENT_TIMESTAMP AS date_chargement,
    'SILVER' AS source_system
FROM silver.contrats c;

-- ============================================
-- TABLE FACTUELLE : f_adhesions
-- Grain : un contrat actif par jour
-- ============================================

INSERT INTO gold.f_adhesions (
    sk_date, sk_adherent, sk_contrat, nb_contrats_actifs,
    prime_annuelle, statut,
    date_chargement, source_system
)
SELECT 
    dt.sk_date,                   -- Clé sur dimension temps
    da.sk_adherent,               -- Clé sur dimension adhérent
    dc.sk_contrat,                -- Clé sur dimension contrat
    1 AS nb_contrats_actifs,      -- Chaque ligne = 1 contrat actif
    COALESCE(ad.prime_annuelle,0) AS prime_annuelle,
    ad.statut,
    CURRENT_TIMESTAMP AS date_chargement,
    'SILVER' AS source_system
FROM silver.adhesions ad
JOIN gold.d_temps dt ON dt.date_jour = ad.date_adhesion
JOIN gold.d_adherents da ON da.id_adherent_src = ad.id_adherent_src
JOIN gold.d_contrats dc ON dc.id_contrat_src = ad.id_contrat_src
WHERE ad.statut = 'ACTIF';  -- Seulement contrats actifs

-- ============================================
-- TABLE DIMENSIONNELLE : d_sinistres
-- Grain : un sinistre
-- ============================================

INSERT INTO gold.d_sinistres (
    id_sinistre_src, type_sinistre, code_garantie, statut_dossier,
    date_chargement, source_system
)
SELECT DISTINCT
    s.id_sinistre_src,
    s.type_sinistre,
    s.code_garantie,
    s.statut_dossier,
    CURRENT_TIMESTAMP AS date_chargement,
    'SILVER' AS source_system
FROM silver.sinistres s;

-- ============================================
-- TABLE DIMENSIONNELLE : d_reglements
-- Grain : un règlement
-- ============================================

INSERT INTO gold.d_reglements (
    id_reglement_src, type_reglement, mode_paiement,
    date_chargement, source_system
)
SELECT DISTINCT
    r.id_reglement_src,
    r.type_reglement,
    r.mode_paiement,
    CURRENT_TIMESTAMP AS date_chargement,
    'SILVER' AS source_system
FROM silver.reglements r;

-- ============================================
-- TABLE FACTUELLE : f_sinistralite
-- Grain : un sinistre par jour
-- Agrégation des montants règlements et réserves
-- ============================================

INSERT INTO gold.f_sinistralite (
    sk_date, sk_sinistre, sk_adherent, sk_contrat,
    nb_sinistres, montant_reglements, reserve_brute, reserve_nette,
    date_chargement, source_system
)
SELECT 
    dt.sk_date,
    ds.sk_sinistre,
    da.sk_adherent,
    dc.sk_contrat,
    1 AS nb_sinistres,  -- Chaque ligne = un sinistre
    COALESCE(SUM(r.montant_reglement),0) AS montant_reglements,
    s.reserve_brute,
    s.reserve_nette,
    CURRENT_TIMESTAMP AS date_chargement,
    'SILVER' AS source_system
FROM silver.sinistres s
JOIN gold.d_temps dt ON dt.date_jour = s.date_survenance
JOIN gold.d_sinistres ds ON ds.id_sinistre_src = s.id_sinistre_src
LEFT JOIN silver.reglements r ON r.id_sinistre_src = s.id_sinistre_src
LEFT JOIN gold.d_adherents da ON da.id_adherent_src = s.id_adherent_src
LEFT JOIN gold.d_contrats dc ON dc.id_contrat_src = s.id_contrat_src
GROUP BY 
    dt.sk_date, ds.sk_sinistre, da.sk_adherent, dc.sk_contrat,
    s.reserve_brute, s.reserve_nette;
