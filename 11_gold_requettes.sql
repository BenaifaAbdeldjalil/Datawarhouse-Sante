-- KPI Adhésion : Prime annuelle par département/segment
SELECT 
    dt.annee,
    da.departement,
    da.segment_age,
    SUM(f.prime_annuelle) as ca_portefeuille,
    COUNT(DISTINCT f.sk_adherent) as nb_adherents
FROM gold.f_adhesions f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
JOIN gold.d_adherents da ON da.sk_adherent = f.sk_adherent
WHERE dt.annee = 2025
GROUP BY dt.annee, da.departement, da.segment_age;

-- KPI Sinistralité : Taux S/P par garantie
SELECT 
    dt.annee,
    ds.type_sinistre,
    SUM(f.montant_reglements + f.reserve_brute) / NULLIF(SUM(p.prime_annuelle), 0) as taux_sinistralite
FROM gold.f_sinistralite f
JOIN gold.d_temps dt ON dt.sk_date = f.sk_date
JOIN gold.d_sinistres ds ON ds.sk_sinistre = f.sk_sinistre
LEFT JOIN gold.f_adhesions p ON p.sk_date = f.sk_date 
    AND p.sk_adherent = f.sk_adherent
WHERE dt.annee = 2025
GROUP BY dt.annee, ds.type_sinistre;
