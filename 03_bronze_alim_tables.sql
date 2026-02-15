-- 1. bronze.adherent_raw - Données très sales
-- 50 adhérents avec données crades (fautes, formats sales)
INSERT INTO bronze.adherent_raw (
    source_file, id_adherent_src,
    nom_raw, prenom_raw,
    date_naissance_raw, sexe_raw,
    code_postal_raw, ville_raw,
    email_raw, telephone_raw
)
VALUES
    ('export_mutuelle_2025.csv', 'ADH_001', 'DUPONT', 'Jean-Pierre', '15/05/1980', 'M', '75001', 'PARIS 1er', 'jean.dupont@mail.fr', '06 12 34 56 78'),
    ('export_mutuelle_2025.csv', 'ADH_002', 'Martin', 'Marie ', '1982-03-22', 'F', '69005  ', 'LYon', 'marie.martin @test.com', '0690567890'),
    ('export_mutuelle_2025.csv', 'ADH_003', 'LECLERC', 'Paul', '01-12-75', 'H', '13001', 'marseille', NULL, 'FIXE:0491234567'),
    ('export_mutuelle_2025.csv', 'ADH_004', 'dupond t.', 'Anne-marie', '15/mai/1990', '?', '31000T', 'TOULOUSE', 'anne@exemplecom', '061234567890'),
    ('export_mutuelle_2025.csv', 'ADH_005', 'Bernard', '', '01/01/2000', 'F', '97200', 'Fort-de-France', 'bernard@testCOM', '0690123456'),
    ('export_mutuelle_2025.csv', 'ADH_006', 'ROGER ', 'Sophie', '1985/08/15', 'F', '44000', 'Nantes  ', 'sophie.roger@gmailcom', '02.40.12.34.56'),
    ('export_mutuelle_2025.csv', 'ADH_007', 'Petit', 'Luc', '75-06-20', 'M', '51100', 'Reims', 'luc.petit@test.fr', NULL),
    ('export_mutuelle_2025.csv', 'ADH_008', 'MOREAU', 'Claire', '15-12-1988', 'F', '6900', 'Lyon 5e', 'claire.moreau@free.fr', '07-98 76 54 32'),
    ('export_mutuelle_2025.csv', 'ADH_009', 'Simon', 'julien', '01/01/99', 'M', '75012 paris', 'Paris', 'julien@simoncom', '33612345678'),
    ('export_mutuelle_2025.csv', 'ADH_010', 'Garcia', 'Elena', '????', NULL, '66000', 'Perpignan', 'elena.garcia@mail.com', '04.68.12.34.56');

-- 2. bronze.contrat_raw - Formats incohérents
INSERT INTO bronze.contrat_raw (
    source_file, id_contrat_src, id_adherent_src,
    date_debut_raw, date_fin_raw,
    type_contrat_raw, regime_raw, canal_vente_raw
)
VALUES
    ('export_contrats.csv', 'CTR_001', 'ADH_001', '2023-01-15', '2025-12-31', 'INDIVIDUEL', 'RG', 'AGENCE'),
    ('export_contrats.csv', 'CTR_002', 'ADH_002', '01/03/2024', NULL, 'COLLECTIF ', 'AGRICULTURE', 'INTERNET'),
    ('export_contrats.csv', 'CTR_003', 'ADH_003', '15-06-22', '31/12/2024', 'FAMILLE', 'REGIME GENERAL', 'COURTIER'),
    ('export_contrats.csv', 'CTR_004', 'ADH_004', '2024/01/01', '2024-12-31', 'individuel', 'fonction publique', 'agence'),
    ('export_contrats.csv', 'CTR_005', 'ADH_005', '01-01-2023', NULL, 'COLLECTIF', 'RÉGIME GÉNÉRAL', 'Internet'),
    ('export_contrats.csv', 'CTR_006', 'ADH_006', '15 mars 2024', NULL, 'F', 'agricole', 'COURTIER '),
    ('export_contrats.csv', 'CTR_007', 'ADH_007', '2022-11-01', '2024/06/30', 'INDIV', 'RG', NULL),
    ('export_contrats.csv', 'CTR_008', 'ADH_008', '01/01/25', NULL, 'collectif', 'Fonction Publique', 'AGENCE');

--- 3. bronze.adhesion_raw - Montants sales + statuts
INSERT INTO bronze.adhesion_raw (
    source_file, id_adhesion_src, id_adherent_src, id_contrat_src,
    date_adhesion_raw, date_resiliation_raw, statut_raw,
    prime_annuelle_raw, code_produit_raw, code_garanties_raw
)
VALUES
    ('export_adhesions.csv', 'ADHIST_001', 'ADH_001', 'CTR_001', '2023-01-15', NULL, 'A', '456,78', 'SANTE_BASE', 'HOSPITALISATION'),
    ('export_adhesions.csv', 'ADHIST_002', 'ADH_002', 'CTR_002', '01/03/2024', NULL, 'ACTIF', '789.00', 'SANTE_PLUS', 'DENTAIRE'),
    ('export_adhesions.csv', 'ADHIST_003', 'ADH_003', 'CTR_003', '15-06-2022', '31/12/2023', 'R', '1 234,56', 'PREVOYANCE', 'OPTIQUE'),
    ('export_adhesions.csv', 'ADHIST_004', 'ADH_004', 'CTR_004', '2024/01/01', NULL, 'actif', '2345.99 €', 'sante_base', 'PHARMACIE'),
    ('export_adhesions.csv', 'ADHIST_005', 'ADH_005', 'CTR_005', '01-01-2023', '15/06/2024', 'RES', '0,00', 'SANTE_PLUS', NULL),
    ('export_adhesions.csv', 'ADHIST_006', 'ADH_006', 'CTR_006', '15/03/2024', NULL, 'A', '1.250,50', 'PREVOYANCE', 'HOSPITALISATION, DENTAIRE'),
    ('export_adhesions.csv', 'ADHIST_007', 'ADH_007', 'CTR_007', '01/11/2022', NULL, 'RESILIE', '-125.00', 'SANTE_BASE', 'OPTIQUE'),
    ('export_adhesions.csv', 'ADHIST_008', 'ADH_008', 'CTR_008', '2025-01-01', NULL, 'actif', '99999,99', 'PREVOYANCE', 'PHARMACIE');

---- 4. bronze.sinistre_raw - Dates incohérentes + montants
INSERT INTO bronze.sinistre_raw (
    source_file, id_sinistre_src, id_adherent_src, id_contrat_src,
    date_survenance_raw, date_declaration_raw, type_sinistre_raw,
    code_garantie_raw, statut_dossier_raw,
    reserve_brute_raw, reserve_nette_raw
)
VALUES
    ('export_sinistres.csv', 'SIN_001', 'ADH_001', 'CTR_001', '2024-03-15', '2024-03-20', 'HOSPITALISATION', 'GAR_HOSP', 'OUVERT', '2 500,00', '2 000,00'),
    ('export_sinistres.csv', 'SIN_002', 'ADH_002', 'CTR_002', '15/04/2024', '01/04/2024', 'DENTAIRE', 'GAR_DENT', 'CLOTURE', '450.50', '380,25'),
    ('export_sinistres.csv', 'SIN_003', 'ADH_003', 'CTR_003', '2024-06-10', '10/06/2024', 'OPTIQUE', 'GAR_OPT', 'EN_RECOURS', '250€', '200'),
    ('export_sinistres.csv', 'SIN_004', 'ADH_004', 'CTR_004', '01/07/2024', '2024-07-05', 'PHARMACIE', 'gar_phar', 'ouvert', '0,00', 'NULL'),
    ('export_sinistres.csv', 'SIN_005', 'ADH_005', 'CTR_005', '2023-12-25', '25-12-2023', 'HOSPITALISATION', 'GAR_HOSP', 'CLOTURE', '-100.00', '0'),
    ('export_sinistres.csv', 'SIN_006', 'ADH_006', 'CTR_006', '15 mai 2024', '2024-05-20', 'DENTAIRE', 'GAR_DENT', 'OUVERT', '1 250,75', '1 000'),
    ('export_sinistres.csv', 'SIN_007', 'ADH_007', 'CTR_007', '2024-08-01', '01/08/2024', 'OPTIQUE', 'GAR_OPT', 'EN_RECOURS', '99999,99', '80 000');

-- 5. bronze.reglement_raw - Montants négatifs + formats
INSERT INTO bronze.reglement_raw (
    source_file, id_reglement_src, id_sinistre_src,
    date_reglement_raw, montant_reglement_raw,
    type_reglement_raw, mode_paiement_raw
)
VALUES
    ('export_reglements.csv', 'REG_001', 'SIN_001', '2024-04-10', '1 800,00', 'DEFINITIF', 'VIREMENT'),
    ('export_reglements.csv', 'REG_002', 'SIN_002', '15/05/2024', '350.25', 'PROVISOIRE', 'CHEQUE'),
    ('export_reglements.csv', 'REG_003', 'SIN_003', '2024-07-15', '180€', 'DEFINITIF', 'VIREMENT'),
    ('export_reglements.csv', 'REG_004', 'SIN_004', '10/08/2024', '0,00', 'PROVISOIRE', 'PRELEVEMENT'),
    ('export_reglements.csv', 'REG_005', 'SIN_005', '2024-01-05', '-95.50', 'DEFINITIF', 'CHEQUE'),
    ('export_reglements.csv', 'REG_006', 'SIN_006', '01/06/2024', '950,00', 'DEFINITIF', 'VIREMENT'),
    ('export_reglements.csv', 'REG_007', 'SIN_007', '2024-09-01', '75 000,00', 'PROVISOIRE', NULL);



