/*
=========================================================
09_dashboard_views.sql
Vues et Materialized Views pour dashboards
=========================================================
-- Regroupe tous les KPIs et synthèses pour adhésion et sinistralité
-- Inclut calculs, agrégations et rafraîchissement quotidien
-- Grain : mois/jour, adhérent, contrat, sinistre
=========================================================
*/

/*Explications clés :
Materialized Views (v_kpi_*) : pré-calculent les KPIs principaux pour accélérer le dashboard.
Vues classiques (v_dashboard_*) : synthèses et cartes, peuvent être interrogées directement depuis un outil BI.
Calculs dynamiques : évolution % (LAG()), fréquence sinistres, coût moyen.
Granularité : mois, département, segment âge, type de sinistre.
Rafraîchissement automatique : DO $$ REFRESH MATERIALIZED VIEW CONCURRENTLY $$ pour ne pas bloquer les dashboards.*/

-- =========================================================
-- 1. KPI Adhésion (Materialized View)
-- Grain : mois / département / segment / sexe
-- Rafraîchie quotidiennement (prévoir CRON)
-- =========================================================
CREATE MATERIALIZED VIEW gold.v_kpi_adhesion AS
SELECT 
    dt.annee,
    dt.mois,
    dt.trimestre,
    da.departement,
    da.segment_age,
    da.sexe,
    
    -- Compteurs
    COUNT(DISTINCT f.sk_adherent) as nb_adherents,
    COUNT(DISTINCT f.sk_contrat) as nb_contrats,
    SUM(f.prime_annuelle) as ca_portefeuille,
    
    -- Croissance (comparaison mois précédent par département)
    LAG(SUM(f.prime_annuelle)) OVER (PARTITION BY da.departement ORDER BY dt.annee, dt.mois) as ca_precedent,
    
    -- Taux d'évolution
    ROUND(
        SUM(f.prime_annuelle) / NULLIF(LAG(SUM(f.prime_annuelle)) OVER (PARTITION BY da.departement ORDER BY dt.annee, dt.mois), 0) * 100 - 100, 
        1
    ) as evolution_ca_pct,
    
    CURRENT_TIMESTAMP as date_actualisation
FROM gold.f_adhesions f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
JOIN gold.d_adherents da ON da.sk_adherent = f.sk_adherent
WHERE f.statut = 'ACTIF'
GROUP BY dt.annee, dt.mois, dt.trimestre, da.departement, da.segment_age, da.sexe;


-- =========================================================
-- 2. KPI Sinistralité (Materialized View)
-- Grain : mois / type sinistre / garantie
-- =========================================================
CREATE MATERIALIZED VIEW gold.v_kpi_sinistralite AS
SELECT 
    dt.annee,
    dt.mois,
    dt.trimestre,
    ds.type_sinistre,
    ds.code_garantie,
    
    -- Sinistralité
    COUNT(DISTINCT f.sk_sinistre) as nb_sinistres,
    SUM(f.montant_reglements) as sinistres_payes,
    SUM(f.reserve_brute) as reserves,
    SUM(f.reserve_brute + f.reserve_nette) as cout_total,
    
    -- Fréquence (sinistres / adhérents)
    COUNT(DISTINCT f.sk_sinistre)::float / NULLIF(
        (SELECT COUNT(DISTINCT sk_adherent) 
         FROM gold.f_adhesions fa 
         JOIN gold.d_temps dtt ON dtt.sk_date = fa.sk_date 
         WHERE dtt.annee = dt.annee AND fa.statut = 'ACTIF'), 
        0
    ) as frequence_sinistres,
    
    -- Coût moyen par sinistre
    AVG(f.reserve_brute + f.reserve_nette) as cout_moyen_sinistre,
    
    CURRENT_TIMESTAMP as date_actualisation
FROM gold.f_sinistralite f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
JOIN gold.d_sinistres ds ON ds.sk_sinistre = f.sk_sinistre
GROUP BY dt.annee, dt.mois, dt.trimestre, ds.type_sinistre, ds.code_garantie;


-- =========================================================
-- 3. Dashboard synthèse commerciale mensuelle
-- Vue simple pour CA portefeuille par département
-- =========================================================
CREATE VIEW gold.v_dashboard_commercial AS
SELECT 
    'CA Portefeuille' as indicateur,
    dt.annee || '-' || LPAD(dt.mois::text, 2, '0') as periode,
    da.departement,
    SUM(f.prime_annuelle) as valeur,
    ROUND(SUM(f.prime_annuelle)/1e6, 1) as valeur_kmois,
    LAG(SUM(f.prime_annuelle)) OVER w as precedent,
    ROUND(
        (SUM(f.prime_annuelle) - LAG(SUM(f.prime_annuelle)) OVER w) 
        / NULLIF(LAG(SUM(f.prime_annuelle)) OVER w, 0) * 100, 1
    ) as evolution_pct
FROM gold.f_adhesions f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
JOIN gold.d_adherents da ON da.sk_adherent = f.sk_adherent
WHERE f.statut = 'ACTIF'
  AND dt.annee >= 2024
WINDOW w AS (PARTITION BY da.departement ORDER BY dt.annee, dt.mois);


-- =========================================================
-- 4. Dashboard pilotage sinistralité
-- Vue avec ratio S/P et évolution mensuelle
-- =========================================================
CREATE VIEW gold.v_dashboard_sinistralite AS
WITH sinistres AS (
    SELECT * FROM gold.v_kpi_sinistralite
),
primes AS (
    SELECT 
        dt.annee, dt.mois,
        SUM(f.prime_annuelle) as prime_periode
    FROM gold.f_adhesions f
    JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
    WHERE f.statut = 'ACTIF'
    GROUP BY dt.annee, dt.mois
)
SELECT 
    s.annee || '-' || LPAD(s.mois::text, 2, '0') as periode,
    s.type_sinistre,
    s.nb_sinistres,
    s.sinistres_payes,
    s.cout_total,
    p.prime_periode,
    ROUND(s.sinistres_payes / NULLIF(p.prime_periode, 0) * 100, 2) as taux_sp_pct,
    s.frequence_sinistres,
    s.cout_moyen_sinistre
FROM sinistres s
JOIN primes p ON p.annee = s.annee AND p.mois = s.mois
WHERE s.annee >= 2024;


-- =========================================================
-- 5. Carte portefeuille / adhérents actifs
-- =========================================================
CREATE VIEW gold.v_score_portefeuille AS
SELECT 
    CURRENT_DATE as date_refresh,
    COUNT(DISTINCT f.sk_adherent) as nb_adherents_actifs,
    COUNT(DISTINCT f.sk_contrat) as nb_contrats_actifs,
    ROUND(SUM(f.prime_annuelle)/1e6, 0) as ca_mme,
    ROUND(AVG(f.prime_annuelle), 0) as prime_moyenne,
    (SELECT COUNT(*) FROM gold.v_kpi_sinistralite 
     WHERE annee = EXTRACT(YEAR FROM CURRENT_DATE)::int)::float 
     / GREATEST(COUNT(DISTINCT f.sk_adherent), 1) as sinistres_par_adherent
FROM gold.f_adhesions f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
WHERE f.statut = 'ACTIF' 
  AND dt.annee = EXTRACT(YEAR FROM CURRENT_DATE)::int;


-- =========================================================
-- 6. Carte sinistralité (alerte)
-- =========================================================
CREATE VIEW gold.v_score_sinistralite AS
SELECT 
    CURRENT_DATE as date_refresh,
    COUNT(*) as nb_sinistres_ouvres,
    SUM(montant_reglements + reserve_brute) as exposition_totale,
    AVG(montant_reglements + reserve_brute) as exposition_moyenne,
    COUNT(*) FILTER (WHERE statut_dossier = 'OUVERT') as sinistres_non_clotures,
    ROUND(AVG(montant_reglements + reserve_brute) 
          FILTER (WHERE statut_dossier = 'OUVERT'), 0) as reserve_moyenne_ouverte
FROM gold.f_sinistralite f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
WHERE dt.annee = EXTRACT(YEAR FROM CURRENT_DATE)::int;


-- =========================================================
-- 7. Top 5 départements par CA
-- =========================================================
CREATE VIEW gold.v_top5_dept_ca AS
SELECT 
    da.departement,
    COUNT(DISTINCT da.sk_adherent) as nb_adherents,
    ROUND(SUM(f.prime_annuelle)/1e3, 0) as ca_keuros
FROM gold.f_adhesions f
JOIN gold.d_adherents da ON da.sk_adherent = f.sk_adherent
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
WHERE f.statut = 'ACTIF' AND dt.annee = 2025
GROUP BY da.departement
ORDER BY ca_keuros DESC
LIMIT 5;


-- =========================================================
-- 8. Évolution S/P mensuel (HOSPITALISATION)
-- =========================================================
CREATE VIEW gold.v_evolution_sp_hosp AS
SELECT 
    periode,
    sinistres_payes,
    prime_periode,
    ROUND(taux_sp_pct, 1) as sp_pct,
    LAG(ROUND(taux_sp_pct, 1)) OVER (ORDER BY periode) as sp_precedent
FROM gold.v_dashboard_sinistralite
WHERE type_sinistre = 'HOSPITALISATION'
ORDER BY periode DESC
LIMIT 12;


-- =========================================================
-- 9. Carte thermique : sinistralité par âge/garantie
-- =========================================================
CREATE VIEW gold.v_heatmap_sinistralite AS
SELECT 
    da.segment_age,
    ds.type_sinistre,
    COUNT(f.sk_sinistre) as nb_sinistres,
    ROUND(AVG(f.reserve_brute + f.reserve_nette), 0) as cout_moyen
FROM gold.f_sinistralite f
JOIN gold.d_adherents da ON da.sk_adherent = f.sk_adherent
JOIN gold.d_sinistres ds ON ds.sk_sinistre = f.sk_sinistre
WHERE EXTRACT(YEAR FROM age(CURRENT_DATE, da.date_naissance)) > 18
GROUP BY da.segment_age, ds.type_sinistre
ORDER BY nb_sinistres DESC;


-- =========================================================
-- 10. Script de rafraîchissement quotidien
-- Prévoir CRON à 00:05 pour rafraîchir les MV
-- =========================================================
DO $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY gold.v_kpi_adhesion;
    REFRESH MATERIALIZED VIEW CONCURRENTLY gold.v_kpi_sinistralite;
    RAISE NOTICE 'Materialized Views KPI rafraîchies: %', CURRENT_TIMESTAMP;
END $$;
