-- 1. Peuplement d_adherents (depuis silver)
INSERT INTO gold.d_adherents (
    id_adherent_src, nom, prenom, age, sexe, departement, segment_age
)
SELECT 
    a.id_adherent_src,
    a.nom, a.prenom,
    CASE 
        WHEN a.date_naissance IS NOT NULL 
        THEN EXTRACT(YEAR FROM age(CURRENT_DATE, a.date_naissance))::int 
        ELSE NULL 
    END as age,
    a.sexe,
    LEFT(a.code_postal, 2) as departement,
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN 'JEUNE'
        WHEN age BETWEEN 31 AND 60 THEN 'ADULTE'
        WHEN age > 60 THEN 'SENIOR'
        ELSE 'INCONNU'
    END as segment_age
FROM silver.adherents a;

-- 2. Peuplement d_contrats
INSERT INTO gold.d_contrats (id_contrat_src, type_contrat, regime, canal_vente)
SELECT DISTINCT
    c.id_contrat_src, c.type_contrat, c.regime, c.canal_vente
FROM silver.contrats c;

-- 3. Peuplement f_adhesions (grain: contrat/jour)
INSERT INTO gold.f_adhesions (
    sk_date, sk_adherent, sk_contrat, nb_contrats_actifs,
    prime_annuelle, statut
)
SELECT 
    dt.sk_date,
    da.sk_adherent,
    dc.sk_contrat,
    1 as nb_contrats_actifs,
    COALESCE(ad.prime_annuelle, 0) as prime_annuelle,
    ad.statut
FROM silver.adhesions ad
JOIN gold.d_temps dt ON dt.date_jour = ad.date_adhesion
JOIN gold.d_adherents da ON da.id_adherent_src = ad.id_adherent_src
JOIN gold.d_contrats dc ON dc.id_contrat_src = ad.id_contrat_src
WHERE ad.statut = 'ACTIF';


-- 1. Peuplement d_sinistres
INSERT INTO gold.d_sinistres (id_sinistre_src, type_sinistre, code_garantie, statut_dossier)
SELECT DISTINCT
    s.id_sinistre_src,
    s.type_sinistre,
    s.code_garantie,
    s.statut_dossier
FROM silver.sinistres s;

-- 2. Peuplement d_reglements
INSERT INTO gold.d_reglements (id_reglement_src, type_reglement, mode_paiement)
SELECT DISTINCT
    r.id_reglement_src,
    r.type_reglement,
    r.mode_paiement
FROM silver.reglements r;

-- 3. Peuplement f_sinistralite (agrégation par jour/sinistre)
INSERT INTO gold.f_sinistralite (
    sk_date, sk_sinistre, sk_adherent, sk_contrat,
    nb_sinistres, montant_reglements, reserve_brute, reserve_nette
)
SELECT 
    dt.sk_date,
    ds.sk_sinistre,
    da.sk_adherent,
    dc.sk_contrat,
    1 as nb_sinistres,
    COALESCE(SUM(r.montant_reglement), 0) as montant_reglements,
    s.reserve_brute,
    s.reserve_nette
FROM silver.sinistres s
JOIN gold.d_temps dt ON dt.date_jour = s.date_survenance
JOIN gold.d_sinistres ds ON ds.id_sinistre_src = s.id_sinistre_src
LEFT JOIN silver.reglements r ON r.id_sinistre_src = s.id_sinistre_src
LEFT JOIN gold.d_adherents da ON da.id_adherent_src = s.id_adherent_src
LEFT JOIN gold.d_contrats dc ON dc.id_contrat_src = s.id_contrat_src
GROUP BY 
    dt.sk_date, ds.sk_sinistre, da.sk_adherent, dc.sk_contrat,
    s.reserve_brute, s.reserve_nette;

