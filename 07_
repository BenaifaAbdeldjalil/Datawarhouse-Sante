-- ============================================
----------------------DOMAINE SINISTRALITE
-- ============================================
-- Dimension Sinistre/Garantie
CREATE TABLE gold.d_sinistres (
    sk_sinistre     serial PRIMARY KEY,
    id_sinistre_src text NOT NULL,
    type_sinistre   text,
    code_garantie   text,
    statut_dossier  text,
    dt_integration  timestamp DEFAULT now()
);

-- Dimension Règlement
CREATE TABLE gold.d_reglements (
    sk_reglement    serial PRIMARY KEY,
    id_reglement_src text NOT NULL,
    type_reglement  text,
    mode_paiement   text
);

CREATE TABLE gold.f_sinistralite (
    sk_date            int REFERENCES gold.d_temps(sk_date),
    sk_sinistre        int REFERENCES gold.d_sinistres(sk_sinistre),
    sk_adherent        int REFERENCES gold.d_adherents(sk_adherent),
    sk_contrat         int REFERENCES gold.d_contrats(sk_contrat),
    nb_sinistres       int DEFAULT 1,
    montant_reglements numeric(14,2) DEFAULT 0,
    reserve_brute      numeric(14,2) DEFAULT 0,
    reserve_nette      numeric(14,2) DEFAULT 0,
    cout_total         numeric(14,2) GENERATED ALWAYS AS 
        (montant_reglements + reserve_brute) STORED,
    PRIMARY KEY (sk_date, sk_sinistre)
);
