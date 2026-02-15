-- Dimension Temps (commune aux 2 domaines)
CREATE TABLE IF NOT EXISTS gold.d_temps (
    sk_date     serial PRIMARY KEY,
    date_jour   date NOT NULL UNIQUE,
    annee       int,
    mois        int,
    jour        int,
    trimestre   int,
    semestre    int,
    jour_semaine text
);

-- Peuplement d_temps (2015-2030)
INSERT INTO gold.d_temps (date_jour, annee, mois, jour, trimestre, semestre, jour_semaine)
SELECT 
    d::date,
    EXTRACT(YEAR FROM d)::int,
    EXTRACT(MONTH FROM d)::int,
    EXTRACT(DAY FROM d)::int,
    EXTRACT(QUARTER FROM d)::int,
    CASE WHEN EXTRACT(MONTH FROM d) <= 6 THEN 1 ELSE 2 END::int,
    TO_CHAR(d, 'Day')::text
FROM generate_series('2015-01-01'::date, '2030-12-31'::date, '1 day'::interval) d;



-- Dimension Adhérent enrichie
CREATE TABLE gold.d_adherents (
    sk_adherent     serial PRIMARY KEY,
    id_adherent_src text NOT NULL,
    nom             text,
    prenom          text,
    age             int,
    sexe            varchar(1),
    departement     varchar(2),
    segment_age     text,  -- 'JEUNE','ADULTE','SENIOR'
    dt_integration  timestamp DEFAULT now()
);

-- Dimension Contrat
CREATE TABLE gold.d_contrats (
    sk_contrat      serial PRIMARY KEY,
    id_contrat_src  text NOT NULL,
    type_contrat    text,
    regime          text,
    canal_vente     text,
    dt_integration  timestamp DEFAULT now()
);


CREATE TABLE gold.f_adhesions (
    sk_date         int REFERENCES gold.d_temps(sk_date),
    sk_adherent     int REFERENCES gold.d_adherents(sk_adherent),
    sk_contrat      int REFERENCES gold.d_contrats(sk_contrat),
    nb_contrats_actifs int DEFAULT 1,
    prime_annuelle  numeric(14,2),
    statut          text,  -- ACTIF/RESILIE
    PRIMARY KEY (sk_date, sk_adherent, sk_contrat)
);


