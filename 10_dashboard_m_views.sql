-- =========================================================
-- 10_dashboard_m_views.sql
-- Materialized views pour dashboard / KPIs
-- =========================================================
/*Explications :

Matérialized Views : stockent des résultats pré-calculés pour accélérer les dashboards, surtout pour les grandes tables GOLD.
Agrégations fréquentes :
Par mois (DATE_TRUNC('month', ...))
Par département
Par type de sinistre

KPIs clés :
Nb adhérents actifs, primes annuelles
Nb sinistres, réserves brutes et nettes, règlements
Ratio sinistres / adhérents par zone
Top adhérents par primes
Colonnes date_actualisation : pour savoir quand la MV a été rafraîchie.
Index : pour accélérer les filtres et les requêtes sur les dashboards.*/

-- ============================================
-- 1. MV : nb d'adhérents actifs par mois
-- Grain : mois
-- Agrégation des adhérents actifs et primes
-- ============================================

CREATE MATERIALIZED VIEW gold.mv_adhesions_mensuelles AS
SELECT
    DATE_TRUNC('month', dt.date_jour) AS mois,
    COUNT(DISTINCT f.sk_adherent) AS nb_adhérents_actifs,
    SUM(f.prime_annuelle) AS prime_totale,
    AVG(f.prime_annuelle) AS prime_moyenne,
    CURRENT_TIMESTAMP AS date_actualisation
FROM gold.f_adhesions f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
GROUP BY DATE_TRUNC('month', dt.date_jour)
ORDER BY mois;

-- ============================================
-- 2. MV : sinistralité par mois et type de sinistre
-- Grain : mois + type sinistre
-- Indicateurs : nb sinistres, réserves, règlements
-- ============================================

CREATE MATERIALIZED VIEW gold.mv_sinistralite_mensuelle AS
SELECT
    DATE_TRUNC('month', dt.date_jour) AS mois,
    ds.type_sinistre,
    COUNT(DISTINCT f.sk_sinistre) AS nb_sinistres,
    SUM(f.montant_reglements) AS montant_reglements_total,
    SUM(f.reserve_brute) AS reserve_brute_totale,
    SUM(f.reserve_nette) AS reserve_nette_totale,
    CURRENT_TIMESTAMP AS date_actualisation
FROM gold.f_sinistralite f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
JOIN gold.d_sinistres ds ON ds.sk_sinistre = f.sk_sinistre
GROUP BY DATE_TRUNC('month', dt.date_jour), ds.type_sinistre
ORDER BY mois, ds.type_sinistre;

-- ============================================
-- 3. MV : ratio sinistres / adhérents par département
-- Grain : département
-- Permet d'identifier la sinistralité par zone
-- ============================================

CREATE MATERIALIZED VIEW gold.mv_sinistralite_par_dept AS
SELECT
    da.departement,
    COUNT(DISTINCT f_sk_s.sk_sinistre) AS nb_sinistres,
    COUNT(DISTINCT f_sk_a.sk_adherent) AS nb_adhérents,
    ROUND(
        COUNT(DISTINCT f_sk_s.sk_sinistre)::NUMERIC / 
        NULLIF(COUNT(DISTINCT f_sk_a.sk_adherent),0), 2
    ) AS ratio_sinistres_adhérents,
    CURRENT_TIMESTAMP AS date_actualisation
FROM gold.f_sinistralite f_sk_s
JOIN gold.d_adherents da ON da.sk_adherent = f_sk_s.sk_adherent
LEFT JOIN gold.f_adhesions f_sk_a ON f_sk_a.sk_adherent = f_sk_s.sk_adherent
GROUP BY da.departement
ORDER BY da.departement;

-- ============================================
-- 4. MV : top 10 adhérents par primes annuelles
-- Grain : adhérent
-- ============================================

CREATE MATERIALIZED VIEW gold.mv_top_adhérents_primes AS
SELECT
    da.id_adherent_src,
    da.nom,
    da.prenom,
    SUM(f.prime_annuelle) AS prime_totale,
    COUNT(f.sk_contrat) AS nb_contrats,
    CURRENT_TIMESTAMP AS date_actualisation
FROM gold.f_adhesions f
JOIN gold.d_adherents da ON da.sk_adherent = f.sk_adherent
GROUP BY da.id_adherent_src, da.nom, da.prenom
ORDER BY prime_totale DESC
LIMIT 10;

-- ============================================
-- 5. MV : évolution mensuelle des règlements
-- Grain : mois
-- ============================================

CREATE MATERIALIZED VIEW gold.mv_reglements_mensuels AS
SELECT
    DATE_TRUNC('month', dt.date_jour) AS mois,
    SUM(f.montant_reglements) AS montant_total_reglements,
    COUNT(DISTINCT r.sk_reglement) AS nb_reglements,
    CURRENT_TIMESTAMP AS date_actualisation
FROM gold.f_sinistralite f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
LEFT JOIN gold.d_reglements r ON r.sk_reglement = f.sk_sinistre  -- lien sinistre -> règlement
GROUP BY DATE_TRUNC('month', dt.date_jour)
ORDER BY mois;

-- ============================================
-- 6. Index pour accélérer le rafraîchissement
-- ============================================

CREATE INDEX IF NOT EXISTS idx_mv_adhesions_mensuelles_mois ON gold.mv_adhesions_mensuelles(mois);
CREATE INDEX IF NOT EXISTS idx_mv_sinistralite_mensuelle_mois ON gold.mv_sinistralite_mensuelle(mois);
CREATE INDEX IF NOT EXISTS idx_mv_sinistralite_par_dept_dept ON gold.mv_sinistralite_par_dept(departement);
CREATE INDEX IF NOT EXISTS idx_mv_top_adhérents_primes_prime ON gold.mv_top_adhérents_primes(prime_totale DESC);
CREATE INDEX IF NOT EXISTS idx_mv_reglements_mensuels_mois ON gold.mv_reglements_mensuels(mois);
