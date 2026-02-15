-- Vue KPI Adhésion (rafraîchie quotidiennement)
CREATE MATERIALIZED VIEW gold.v_kpi_adhesion 
REFRESH COMPLETE AFTER '00:05'::interval
AS
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
    
    -- Croissance
    LAG(SUM(f.prime_annuelle)) OVER (PARTITION BY da.departement ORDER BY dt.annee, dt.mois) as ca_precedent,
    
    -- Taux
    ROUND(
        SUM(f.prime_annuelle) / NULLIF(LAG(SUM(f.prime_annuelle)) OVER (PARTITION BY da.departement ORDER BY dt.annee, dt.mois), 0) * 100 - 100, 1
    ) as evolution_ca_pct
    
FROM gold.f_adhesions f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
JOIN gold.d_adherents da ON da.sk_adherent = f.sk_adherent
WHERE f.statut = 'ACTIF'
GROUP BY dt.annee, dt.mois, dt.trimestre, da.departement, da.segment_age, da.sexe;



-- Vue KPI Sinistralité (S/P, fréquence, coût moyen)
CREATE MATERIALIZED VIEW gold.v_kpi_sinistralite 
REFRESH COMPLETE AFTER '00:05'::interval
AS
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
    SUM(f.cout_total) as cout_total_sinistralite,
    
    -- Fréquence (sinistres / adhérents)
    COUNT(DISTINCT f.sk_sinistre)::float / NULLIF(
        (SELECT COUNT(DISTINCT sk_adherent) FROM gold.f_adhesions fa 
         JOIN gold.d_temps dtt ON dtt.sk_date = fa.sk_date 
         WHERE dtt.annee = dt.annee AND fa.statut = 'ACTIF'), 0
    ) as frequence_sinistres,
    
    -- Coût moyen
    AVG(f.cout_total) as cout_moyen_sinistre

FROM gold.f_sinistralite f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
JOIN gold.d_sinistres ds ON ds.sk_sinistre = f.sk_sinistre
GROUP BY dt.annee, dt.mois, dt.trimestre, ds.type_sinistre, ds.code_garantie;



-- DASHBOARD 1: Synthèse Commerciale Mensuelle
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



-- DASHBOARD 2: Pilotage Sinistralité
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
    s.cout_total_sinistralite,
    p.prime_periode,
    ROUND(s.sinistres_payes / NULLIF(p.prime_periode, 0) * 100, 2) as taux_sp_pct,
    s.frequence_sinistres,
    s.cout_moyen_sinistre
FROM sinistres s
JOIN primes p ON p.annee = s.annee AND p.mois = s.mois
WHERE s.annee >= 2024;



-- CARTE 1: État du Portefeuille
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


-- CARTE 2: Alerte Sinistralité
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



-- TOP 5 Départements CA
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



-- Évolution S/P Mensuel
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



-- Carte thermique : Sinistralité par âge/garantie
SELECT 
    da.segment_age,
    ds.type_sinistre,
    COUNT(f.sk_sinistre) as nb_sinistres,
    ROUND(AVG(f.cout_total), 0) as cout_moyen
FROM gold.f_sinistralite f
JOIN gold.d_adherents da ON da.sk_adherent = f.sk_adherent
JOIN gold.d_sinistres ds ON ds.sk_sinistre = f.sk_sinistre
WHERE EXTRACT(YEAR FROM age(CURRENT_DATE, da.date_naissance)) > 18
GROUP BY da.segment_age, ds.type_sinistre
ORDER BY nb_sinistres DESC;


-- Script de rafraîchissement quotidien (à mettre en cron 00:05)
DO $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY gold.v_kpi_adhesion;
    REFRESH MATERIALIZED VIEW CONCURRENTLY gold.v_kpi_sinistralite;
    RAISE NOTICE 'Vues KPI rafraîchies: %', CURRENT_TIMESTAMP;
END $$;


