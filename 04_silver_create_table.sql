-- Dimension adhérent
CREATE TABLE IF NOT EXISTS silver.dim_adherent (
    sk_adherent       bigserial primary key,
    id_adherent_src   text not null,
    nom               text,
    prenom            text,
    date_naissance    date,
    sexe              varchar(1),
    code_postal       varchar(10),
    ville             text,
    email             text,
    telephone         text,
    dt_integration    timestamp default now()
);

-- Dimension contrat
CREATE TABLE IF NOT EXISTS silver.dim_contrat (
    sk_contrat        bigserial primary key,
    id_contrat_src    text not null,
    id_adherent_src   text not null,
    date_debut        date,
    date_fin          date,
    type_contrat      text,
    regime            text,
    canal_vente       text,
    dt_integration    timestamp default now()
);

-- Fait adhésion (historisation)
CREATE TABLE IF NOT EXISTS silver.fait_adhesion (
    sk_adhesion       bigserial primary key,
    id_adhesion_src   text not null,
    id_adherent_src   text not null,
    id_contrat_src    text,
    sk_adherent       bigint,
    sk_contrat        bigint,
    date_adhesion     date,
    date_resiliation  date,
    statut            text,
    prime_annuelle    numeric(14,2),
    code_produit      text,
    code_garanties    text,
    dt_integration    timestamp default now()
);
