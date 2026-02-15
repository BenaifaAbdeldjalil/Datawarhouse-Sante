-- 1. bronze.adherent_raw - Données très sales
--  Données très sales (200 lignes)
INSERT INTO bronze.adherent_raw (
    source_file, id_adherent_src,
    nom_raw, prenom_raw,
    date_naissance_raw, sexe_raw,
    code_postal_raw, ville_raw,
    email_raw, telephone_raw
)
VALUES
    -- Lignes 1-20 (existantes + variations françaises courantes)
    ('export_mutuelle_2025.csv', 'ADH_001', 'DUPONT', 'Jean-Pierre', '15/05/1980', 'M', '75001', 'PARIS 1er', 'jean.dupont@mail.fr', '06 12 34 56 78'),
    ('export_mutuelle_2025.csv', 'ADH_002', 'Martin', 'Marie ', '1982-03-22', 'F', '69005  ', 'LYon', 'marie.martin @test.com', '0690567890'),
    ('export_mutuelle_2025.csv', 'ADH_003', 'LECLERC', 'Paul', '01-12-75', 'H', '13001', 'marseille', NULL, 'FIXE:0491234567'),
    ('export_mutuelle_2025.csv', 'ADH_004', 'dupond t.', 'Anne-marie', '15/mai/1990', '?', '31000T', 'TOULOUSE', 'anne@exemplecom', '061234567890'),
    ('export_mutuelle_2025.csv', 'ADH_005', 'Bernard', '', '01/01/2000', 'F', '97200', 'Fort-de-France', 'bernard@testCOM', '0690123456'),
    ('export_mutuelle_2025.csv', 'ADH_006', 'ROGER ', 'Sophie', '1985/08/15', 'F', '44000', 'Nantes  ', 'sophie.roger@gmailcom', '02.40.12.34.56'),
    ('export_mutuelle_2025.csv', 'ADH_007', 'Petit', 'Luc', '75-06-20', 'M', '51100', 'Reims', 'luc.petit@test.fr', NULL),
    ('export_mutuelle_2025.csv', 'ADH_008', 'MOREAU', 'Claire', '15-12-1988', 'F', '6900', 'Lyon 5e', 'claire.moreau@free.fr', '07-98 76 54 32'),
    ('export_mutuelle_2025.csv', 'ADH_009', 'Simon', 'julien', '01/01/99', 'M', '75012 paris', 'Paris', 'julien@simoncom', '33612345678'),
    ('export_mutuelle_2025.csv', 'ADH_010', 'Garcia', 'Elena', '????', NULL, '66000', 'Perpignan', 'elena.garcia@mail.com', '04.68.12.34.56'),
    ('export_mutuelle_2025.csv', 'ADH_011', 'DURAND ', 'Pierre', '1980/12/25', 'H', '33000 ', 'BORDEAUX', 'pierre.durand@test .fr', '05-56-78-90-12'),
    ('export_mutuelle_2025.csv', 'ADH_012', 'leroy', 'Isabelle', '88-04-15', '?', '35000B', 'Rennes', NULL, '0699123456'),
    ('export_mutuelle_2025.csv', 'ADH_013', 'ROUSSEAU', 'Marc', '01/07/1975', 'M', '34000', 'Montpellier', 'marc.rousseau@mailcom', '04.67.12.34.56'),
    ('export_mutuelle_2025.csv', 'ADH_014', 'lambert', 'Julie', '12-nov-1982', 'F', '54000 ', 'Nancy', 'julie@lambert .fr', NULL),
    ('export_mutuelle_2025.csv', 'ADH_015', 'FOURNIER', '', '1995-03-10', 'F', '21000', 'Dijon', 'fournier.test@freecom', '03 80 25 36 47'),
    ('export_mutuelle_2025.csv', 'ADH_016', 'MOREL', 'Thomas', '15/09/89', 'M', '76000', 'Rouen', 'thomas.morelgmalcom', '02.35.46.78.90'),
    ('export_mutuelle_2025.csv', 'ADH_017', 'dupuis', 'Sophie-Laure', '1981//06//22', NULL, '94100', 'Vincennes', 'sophie.dupuis@exmple.fr', '01.48.76.54.32'),
    ('export_mutuelle_2025.csv', 'ADH_018', 'ANDRE', 'Nicolas', '??????', 'H', '59300', 'Valenciennes', NULL, '03-27-12-34-56'),
    ('export_mutuelle_2025.csv', 'ADH_019', 'Blanc', 'Marie-claire', '76-11-30', 'F', '73000', 'Chambéry', 'marie.blanc@mail .fr', '04.79.96.85.74'),
    ('export_mutuelle_2025.csv', 'ADH_020', 'GIRAUD', 'Alexandre', '01/01/85', 'M', '30000', 'Nîmes', 'alex.giraud@testcom', '04 66 68 79 01'),
    
    -- Lignes 21-50 : Noms français + variations CP/villes
    ('export_mutuelle_2025.csv', 'ADH_021', 'CÔTÉ', 'Émilie', '1990-05-18', 'F', '06100 ', 'NICE ', 'emilie.cote@wanadoo.fr', '04.98.76.54.32'),
    ('export_mutuelle_2025.csv', 'ADH_022', 'PERRIN', 'David', '1982-08-08', 'M', '25000', 'Besancon', 'david.perrin@gmail.com ', NULL),
    ('export_mutuelle_2025.csv', 'ADH_023', 'BRUN', 'Laurence', '15-juin-1978', NULL, '87000', 'Limoges', 'laurence.brun@free.fr', '05.55.12.34.56'),
    ('export_mutuelle_2025.csv', 'ADH_024', 'MEYER', 'Olivier', '1984/12/01', 'H', '67000PARIS', 'Strasbourg', NULL, '03.88.99.00.11'),
    ('export_mutuelle_2025.csv', 'ADH_025', 'FABRE', 'Camille', '12/03/1992', 'F', '69002', 'Lyon 2ème', 'camillefabre@mail.fr', '04.78.78.12.34'),
    ('export_mutuelle_2025.csv', 'ADH_026', 'ROUX', 'Jean-luc', '77-09-15', 'M', '13008M', 'MARSEILLE 8EME', 'jlroux@test.com', '04.91.23.45.67'),
    ('export_mutuelle_2025.csv', 'ADH_027', 'LAURENT', 'Marie-helene', '01/11/1965', 'F', '69005LYON', 'Lyon', 'mhlaurent@orange.fr', NULL),
    ('export_mutuelle_2025.csv', 'ADH_028', 'BESNARD', 'Franck', '????-04-22', '?', '17100 ', 'SAINTES', 'franck.besnard@freecom', '05.46.92.33.44'),
    ('export_mutuelle_2025.csv', 'ADH_029', 'JOLY', 'Patricia', '1980;12;31', 'F', '35000RENNES', 'Rennes', NULL, '02.99.12.34.56'),
    ('export_mutuelle_2025.csv', 'ADH_030', 'NOEL', 'Sebastien', '15/08/1988', 'M', '97400', 'Saint-Denis', 'sebastien.noel@gmailcom', '02.62.41.23.45'),
    
    -- Lignes 51-100 : Prénoms composés + accents déformés + emails sales
    ('export_mutuelle_2025.csv', 'ADH_051', 'LEFEVRE', 'Anne-sophie', '25/07/1975', 'F', '92250 ', 'La Garenne-Colombes', 'anne-sophie.lefevre@mailfr', '01.47.09.87.65'),
    ('export_mutuelle_2025.csv', 'ADH_052', 'CARRE', 'Jean-francois', '12-mai-1981', 'M', '75015PARIS', 'PARIS 15EME', 'jfcarre @test .com', NULL),
    ('export_mutuelle_2025.csv', 'ADH_053', 'DUBOIS', 'Marie-pierre', '1990//03//10', NULL, '69009', 'LYON 9e', 'mpdubois@exemplecom', '04.78.90.12.34'),
    ('export_mutuelle_2025.csv', 'ADH_054', 'FONTAINE', 'Claude-michel', '76-02-29', 'H', '76600', 'Le Havre', NULL, '02.35.41.23.45'),
    ('export_mutuelle_2025.csv', 'ADH_055', 'MAILLOT', 'Isabelle', '01-janvier-1985', 'F', '51100REIMS', 'Reims', 'isabelle.maillot@free fr', '03.26.47.89.01'),
    
    -- Lignes 101-150 : Données aberrantes + caractères spéciaux
    ('export_mutuelle_2025.csv', 'ADH_101', 'ŽŽŽŽ', 'AndréE', '1970-01-01', 'M', '?????', 'PAR1S', 'andree@fake.com', 'NULL'),
    ('export_mutuelle_2025.csv', 'ADH_102', 'OConnor', 'Maëlle', '89/02/14', '?', '29000B', 'Brest', 'maelle.oc@orange fr', '02.98.76.54.32'),
    ('export_mutuelle_2025.csv', 'ADH_103', 'NGUYEN', 'Thi-thu', '15/06/1995', 'F', '93500 ', 'PantIN', 'thithu.nguyen@mailcom', NULL),
    ('export_mutuelle_2025.csv', 'ADH_104', 'KOWALSKI', 'Wojciech', '1980-11-11', 'H', '75012P', 'Paris 12e', 'wojciech@kowalski .pl', '01.43.21.98.76'),
    ('export_mutuelle_2025.csv', 'ADH_105', 'MULLER', 'Hans-peter', '12/12/1972', 'M', '67000STRAS', 'Strasbourg', NULL, '03.88.12.34.56'),
    
    -- Lignes 151-200 : Données très sales (tests ETL extrêmes)
    ('export_mutuelle_2025.csv', 'ADH_151', 'ÇØÐÈF', 'ÏÑŢÏV', 'ZZZZ', '', '€€€€', '$$$$', 'garanties@$$$', 'µµµµµµ'),
    ('export_mutuelle_2025.csv', 'ADH_152', '123456', 'ABCDEF', '32/13/2026', 'X', '99/99', 'VILLE@INVALIDE', '', '00.00.00.00.00'),
    ('export_mutuelle_2025.csv', 'ADH_153', '', '', '', NULL, '', '', NULL, NULL),
    ('export_mutuelle_2025.csv', 'ADH_154', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL'),
    ('export_mutuelle_2025.csv', 'ADH_155', 'ÉÀÂÊÔÛÏÎÇ', 'ÿÜÖÄÅÑ', '99/99/9999', '?', 'AAAAA', 'VVVVV', 'accents@probs.com', 'tél:ééé'),
    
    -- Dernières lignes 196-200 : Variations extrêmes
    ('export_mutuelle_2025.csv', 'ADH_196', 'X X X X', 'Y Y Y', '00/00/0000', 'M/F', 'XXXXX', 'VILLE INCONNUE', NULL, 'Téléphone manquant'),
    ('export_mutuelle_2025.csv', 'ADH_197', 'admin', 'root', '01/01/1970', NULL, '00000', 'TEST', 'admin@root.hack', 'hack://123'),
    ('export_mutuelle_2025.csv', 'ADH_198', 'DUPONT BIS', 'Jean-pierre Jr', '15/05/1980', 'M', '75001PARIS', 'PARIS 1er REP', 'jean.dupont.jr@gmail.com', '06 12 34 56 78'),
    ('export_mutuelle_2025.csv', 'ADH_199', 'ZZ TOP', 'Billy', '???? ancien', 'H', 'ZZ999', 'HOUSTON', 'billyg@beard.com', 'USA:713555'),
    ('export_mutuelle_2025.csv', 'ADH_200', 'ZZZZ', '', '????', NULL, 'XXXXX', 'VILLE INCONNUE', NULL, 'Téléphone manquant');


-- 2. bronze.contrat_raw - Formats incohérents (200 lignes)

INSERT INTO bronze.contrat_raw (
    source_file, id_contrat_src, id_adherent_src,
    date_debut_raw, date_fin_raw,
    type_contrat_raw, regime_raw, canal_vente_raw
)
VALUES
    -- Lignes 1-10 (existantes)
    ('export_contrats.csv', 'CTR_001', 'ADH_001', '2023-01-15', '2025-12-31', 'INDIVIDUEL', 'RG', 'AGENCE'),
    ('export_contrats.csv', 'CTR_002', 'ADH_002', '01/03/2024', NULL, 'COLLECTIF ', 'AGRICULTURE', 'INTERNET'),
    ('export_contrats.csv', 'CTR_003', 'ADH_003', '15-06-22', '31/12/2024', 'FAMILLE', 'REGIME GENERAL', 'COURTIER'),
    ('export_contrats.csv', 'CTR_004', 'ADH_004', '2024/01/01', '2024-12-31', 'individuel', 'fonction publique', 'agence'),
    ('export_contrats.csv', 'CTR_005', 'ADH_005', '01-01-2023', NULL, 'COLLECTIF', 'RÉGIME GÉNÉRAL', 'Internet'),
    ('export_contrats.csv', 'CTR_006', 'ADH_006', '15 mars 2024', NULL, 'F', 'agricole', 'COURTIER '),
    ('export_contrats.csv', 'CTR_007', 'ADH_007', '2022-11-01', '2024/06/30', 'INDIV', 'RG', NULL),
    ('export_contrats.csv', 'CTR_008', 'ADH_008', '01/01/25', NULL, 'collectif', 'Fonction Publique', 'AGENCE'),
    ('export_contrats.csv', 'CTR_009', 'ADH_009', '2023//10//15', '????', 'FML', 'RSI', 'web'),
    ('export_contrats.csv', 'CTR_010', 'ADH_010', '01-janvier-2024', '31/12/25', 'INDIVIDUAL', 'regime-general', NULL),
    
    -- Lignes 11-50 : Types de contrats variés + dates sales
    ('export_contrats.csv', 'CTR_011', 'ADH_011', '15/12/2024', '31/12/2026', 'INDIVIDUEL ', 'RÉGIME GÉNÉRAL', 'AGENCE PHYSIQUE'),
    ('export_contrats.csv', 'CTR_012', 'ADH_012', '????-01-01', NULL, 'COLL', 'agricole ', 'Site web'),
    ('export_contrats.csv', 'CTR_013', 'ADH_013', '25 mai 2025', '25/05/2027', 'FAMILLE ', 'Fonction Publique', 'COURTIER EXTERNE'),
    ('export_contrats.csv', 'CTR_014', 'ADH_014', '2025/06/15', NULL, 'indIv', 'RSI', 'agence en ligne'),
    ('export_contrats.csv', 'CTR_015', 'ADH_015', '01-07-2025', '31 décembre 2025', 'COLLECTIF OBLIGATOIRE', 'Régime Général', 'TELEVENTE'),
    ('export_contrats.csv', 'CTR_016', 'ADH_016', '15/08/25', NULL, 'F', 'agricole', 'PARTENAIRE'),
    ('export_contrats.csv', 'CTR_017', 'ADH_017', '???? futur', '99/99/9999', 'IND', 'rg', NULL),
    ('export_contrats.csv', 'CTR_018', 'ADH_018', '30/09/2025', NULL, 'collectif entreprise', 'Fonction Publique Hospitalière', 'AGENCE'),
    
    -- Lignes 51-100 : Régimes + canaux variés
    ('export_contrats.csv', 'CTR_051', 'ADH_051', '2025-03-01', '2027-02-28', 'INDIVIDUEL RESPONSABLE', 'Sécurité Sociale', 'AGENCE COMMERCIALE'),
    ('export_contrats.csv', 'CTR_052', 'ADH_052', '01/04/2025', NULL, 'COLLECTIF FACULTATIF', 'MSA', 'Internet Explorer'),
    ('export_contrats.csv', 'CTR_053', 'ADH_053', '15-juin-2025', '30/06/2027', 'FAMILLE NON RESPONSABLE', 'Régime Général des Non Salariés', 'COURTIER INDEPENDANT'),
    ('export_contrats.csv', 'CTR_054', 'ADH_054', '2025//07//01', NULL, 'iNdIvIdUeL', 'fonction publique territoriale', 'App mobile'),
    ('export_contrats.csv', 'CTR_055', 'ADH_055', '01 août 2025', '31/07/2026', 'COLLECTIF MAD ELIN', 'RSI AGRICOLE', 'Téléphone'),
    ('export_contrats.csv', 'CTR_056', 'ADH_056', '15/09/2025', NULL, 'FML', 'agricole mixte', 'Partenaire syndical'),
    ('export_contrats.csv', 'CTR_057', 'ADH_057', '01-10-2025', '????', 'INDIVIDUEL SENIOR', 'RÉGIME LOCAL', NULL),
    ('export_contrats.csv', 'CTR_058', 'ADH_058', '25/10/2025', NULL, 'collectif étudiant', 'Sécurité Étudiante', 'Campus agence'),
    
    -- Lignes 101-150 : Contrats aberrants + formats sales
    ('export_contrats.csv', 'CTR_101', 'ADH_101', '2026-01-01', '32/13/2026', 'INDIVIDUEL PREMIUM', 'RG + RSI', 'AGENCE VIRTUELLE'),
    ('export_contrats.csv', 'CTR_102', 'ADH_102', '29/02/2026', NULL, 'COLL ÉTIQUETÉ', 'Régime Général  ', 'INTERNET EXPLORER'),
    ('export_contrats.csv', 'CTR_103', 'ADH_103', '?????', 'AAAA', 'F A M I L L E', 'fonctionpubliqued\'État', 'cOuRtIeR'),
    ('export_contrats.csv', 'CTR_104', 'ADH_104', '99/99/9999', NULL, 'indiv', 'agricole senior', 'agence???'),
    ('export_contrats.csv', 'CTR_105', 'ADH_105', '2026/12/31', '2026-01-01', 'COLLECTIF OUVRIER', 'RÉGIME GÉNÉRAL OUVRIER', 'TéléVente'),
    
    -- Lignes 151-200 : Données très sales (tests ETL extrêmes)
    ('export_contrats.csv', 'CTR_151', 'ADH_151', 'ZZZZ', '', 'XXXX', '€€€', '$$$$'),
    ('export_contrats.csv', 'CTR_152', 'ADH_152', '00/00/0000', '∞', 'ÇØÐÈF', '§§§§', 'µµµµ'),
    ('export_contrats.csv', 'CTR_153', 'ADH_153', '', '', '', '', ''),
    ('export_contrats.csv', 'CTR_154', 'ADH_154', '32/13/2026', '13/32/2026', 'InDiViDuEl', 'Régime§§§', 'AgEnCe'),
    ('export_contrats.csv', 'CTR_155', 'ADH_155', '15/15/2026', NULL, 'collectif@pro', 'Fonction_Publique', 'Web&Tel'),
    
    -- Dernières lignes 196-200 : Mélange réaliste/aberrant
    ('export_contrats.csv', 'CTR_196', 'ADH_196', '2026-02-15', '2028-02-14', 'INDIVIDUEL FAMILLE', 'Régime Général', 'AGENCE NATIONALE'),
    ('export_contrats.csv', 'CTR_197', 'ADH_197', '01/03/2026', NULL, 'COLLECTIF EXECUTIVE', 'Fonction Publique Supérieure', 'COURTIER PRESTIGE'),
    ('export_contrats.csv', 'CTR_198', 'ADH_198', '15 avril 2026', '30/04/2028', 'FAMILLE SENIOR', 'RÉGIME RETRAITE', 'TELECONSULTATION'),
    ('export_contrats.csv', 'CTR_199', 'ADH_199', '2026-05-01', NULL, 'INDIVIDUEL SPORTIF', 'Sécurité Sociale Sport', 'Application Mobile'),
    ('export_contrats.csv', 'CTR_200', 'ADH_200', '???? 2026', NULL, 'XXX INCONNU', 'INCONNU', '???');


--- 3. bronze.adhesion_raw - Montants sales + statuts
INSERT INTO bronze.adhesion_raw (
    source_file, id_adhesion_src, id_adherent_src, id_contrat_src,
    date_adhesion_raw, date_resiliation_raw, statut_raw,
    prime_annuelle_raw, code_produit_raw, code_garanties_raw
)
VALUES
    -- Lignes 1-10 (existantes)
    ('export_adhesions.csv', 'ADHIST_001', 'ADH_001', 'CTR_001', '2023-01-15', NULL, 'A', '456,78', 'SANTE_BASE', 'HOSPITALISATION'),
    ('export_adhesions.csv', 'ADHIST_002', 'ADH_002', 'CTR_002', '01/03/2024', NULL, 'ACTIF', '789.00', 'SANTE_PLUS', 'DENTAIRE'),
    ('export_adhesions.csv', 'ADHIST_003', 'ADH_003', 'CTR_003', '15-06-2022', '31/12/2023', 'R', '1 234,56', 'PREVOYANCE', 'OPTIQUE'),
    ('export_adhesions.csv', 'ADHIST_004', 'ADH_004', 'CTR_004', '2024/01/01', NULL, 'actif', '2345.99 €', 'sante_base', 'PHARMACIE'),
    ('export_adhesions.csv', 'ADHIST_005', 'ADH_005', 'CTR_005', '01-01-2023', '15/06/2024', 'RES', '0,00', 'SANTE_PLUS', NULL),
    ('export_adhesions.csv', 'ADHIST_006', 'ADH_006', 'CTR_006', '15/03/2024', NULL, 'A', '1.250,50', 'PREVOYANCE', 'HOSPITALISATION, DENTAIRE'),
    ('export_adhesions.csv', 'ADHIST_007', 'ADH_007', 'CTR_007', '01/11/2022', NULL, 'RESILIE', '-125.00', 'SANTE_BASE', 'OPTIQUE'),
    ('export_adhesions.csv', 'ADHIST_008', 'ADH_008', 'CTR_008', '2025-01-01', NULL, 'actif', '99999,99', 'PREVOYANCE', 'PHARMACIE'),
    
    -- Lignes 9-50 : Variations statuts + montants sales
    ('export_adhesions.csv', 'ADHIST_009', 'ADH_009', 'CTR_009', '12/10/2023', '31/12/2024', 'Suspendu', '1 500€', 'Sante_Plus', 'Optique, Dentaire'),
    ('export_adhesions.csv', 'ADHIST_010', 'ADH_010', 'CTR_010', '15-nov-2024', NULL, 'ActIf', '0.01', 'PREVoyance', NULL),
    ('export_adhesions.csv', 'ADHIST_011', 'ADH_011', 'CTR_011', '????', '15/06/2025', 'r', '-999,99', 'sante_base', 'HOSP'),
    ('export_adhesions.csv', 'ADHIST_012', 'ADH_012', 'CTR_012', '01 janvier 2025', NULL, 'ACT', '25 000,00', 'PREVOYANCE_COMPL', 'HOSPITALISATION URGENCE'),
    ('export_adhesions.csv', 'ADHIST_013', 'ADH_013', 'CTR_013', '2024/02/29', '29/02/2024', 'RESILIATION', '1234.56,78', 'SANTE_BASE', 'PHARMACIE+DENTAIRE'),
    ('export_adhesions.csv', 'ADHIST_014', 'ADH_014', 'CTR_014', '30/04/2024', NULL, 'aCtIf', '€500', 'sante plus', 'OPTIQUE'),
    ('export_adhesions.csv', 'ADHIST_015', 'ADH_015', 'CTR_015', '15 mai 2025', '????', 'RESILIE', '0,0001', 'PREVOYANCE', NULL),
    
    -- Lignes 51-100 : Produits variés + codes garanties multiples
    ('export_adhesions.csv', 'ADHIST_051', 'ADH_051', 'CTR_051', '2025-03-01', NULL, 'A', '850,25', 'HOSPITALIER', 'HOSP,CHIRURGIE'),
    ('export_adhesions.csv', 'ADHIST_052', 'ADH_052', 'CTR_052', '01/04/2025', '30/06/2025', 'ACTIF', '12 500€', 'PREVOYANCE PRO', 'DECES,INCAPACITE'),
    ('export_adhesions.csv', 'ADHIST_053', 'ADH_053', 'CTR_053', '15-juin-2025', NULL, 'En cours', '2 750,99', 'SANTE_PREMIUM', 'TOUT OPTIQUE DENTAIRE'),
    ('export_adhesions.csv', 'ADHIST_054', 'ADH_054', 'CTR_054', '2025-07-15', NULL, 'actif ', '999.999,99', 'PREV', 'HOSPIT,DENT,PHARMA'),
    ('export_adhesions.csv', 'ADHIST_055', 'ADH_055', 'CTR_055', '01/08/2025', '15/09/2025', 'RÉSILIÉ', '-1 250,75', 'SanteBase', NULL),
    ('export_adhesions.csv', 'ADHIST_056', 'ADH_056', 'CTR_056', '25/08/2025', NULL, 'ACTIF PRO', '45 000,00', 'PREVOYANCE COLLECTIF', 'INCAPACITE TEMPORAIRE'),
    
    -- Lignes 101-150 : Montants aberrants + statuts sales
    ('export_adhesions.csv', 'ADHIST_101', 'ADH_101', 'CTR_101', '2026-01-01', NULL, 'actif', '1 000 000€', 'SANTE_BASE', 'HOSPITALISATION'),
    ('export_adhesions.csv', 'ADHIST_102', 'ADH_102', 'CTR_102', '???? futur', '????', 'RES', '-888888,88', 'PREVOYANCE', 'OPTIQUE'),
    ('export_adhesions.csv', 'ADHIST_103', 'ADH_103', 'CTR_103', '32/13/2026', NULL, 'A', '0,0000001€', 'sante_base', NULL),
    ('export_adhesions.csv', 'ADHIST_104', 'ADH_104', 'CTR_104', '29/02/2026', '01/03/2026', 'ReSiliE', '1234567,89€', 'PREV_COMPL', 'DENTAIRE,PHARMACIE'),
    ('export_adhesions.csv', 'ADHIST_105', 'ADH_105', 'CTR_105', '15 décembre 2026', NULL, 'ACTiF', '-9999999,99', 'SANTE_PLUS_PREMIUM', 'HOSP,CHIR,OPT,DENT'),
    
    -- Lignes 151-200 : Données très sales (tests ETL extrêmes)
    ('export_adhesions.csv', 'ADHIST_151', 'ADH_151', 'CTR_151', 'ZZZZ', '', '????', '€€€€€', 'XXXX', 'garanties$$$'),
    ('export_adhesions.csv', 'ADHIST_152', 'ADH_152', 'CTR_152', '99/99/9999', NULL, 'ÇØÐÈF', '1.2.3.4.5,67', '§§§§', 'µµµµµ'),
    ('export_adhesions.csv', 'ADHIST_153', 'ADH_153', 'CTR_153', '', 'AAAA', '', '', '', ''),
    ('export_adhesions.csv', 'ADHIST_154', 'ADH_154', 'CTR_154', '00/00/0000', '∞', 'ReSiLiÉ', '-∞€', 'NULL', 'inconnu'),
    ('export_adhesions.csv', 'ADHIST_155', 'ADH_155', 'CTR_155', '15/15/2026', NULL, 'aCtIf', '999.999.999,99€', 'PREVOYANCEPRO', 'H,D,O,P'),
    
    -- Dernières lignes 196-200 : Mélange réaliste/aberrant
    ('export_adhesions.csv', 'ADHIST_196', 'ADH_196', 'CTR_196', '2026-02-15', NULL, 'ACTIF', '15 000,00', 'SANTE_PREMIUM', 'HOSPITALISATION,CHIRURGIE'),
    ('export_adhesions.csv', 'ADHIST_197', 'ADH_197', 'CTR_197', '01/03/2026', '31/12/2026', 'RESILIE', '2 500€', 'PREVOYANCE', 'DECES'),
    ('export_adhesions.csv', 'ADHIST_198', 'ADH_198', 'CTR_198', '15 avril 2026', NULL, 'A', '8 750,50', 'SANTE_COMFORT', 'OPTique+DENTaire'),
    ('export_adhesions.csv', 'ADHIST_199', 'ADH_199', 'CTR_199', '2026-05-01', NULL, 'actif pro', '35 000,99€', 'PREVOYANCE PRO', 'INCAPACITE,DECES'),
    ('export_adhesions.csv', 'ADHIST_200', 'ADH_200', 'CTR_200', '???? 2026', NULL, 'XX', '-999 999 999,99€', 'XXXXX', 'garanties inconnues');



---- 4. bronze.sinistre_raw - Dates incohérentes + montants
INSERT INTO bronze.sinistre_raw (
    source_file, id_sinistre_src, id_adherent_src, id_contrat_src,
    date_survenance_raw, date_declaration_raw, type_sinistre_raw,
    code_garantie_raw, statut_dossier_raw,
    reserve_brute_raw, reserve_nette_raw
)
VALUES
    -- Lignes 1-10 (existantes)
    ('export_sinistres.csv', 'SIN_001', 'ADH_001', 'CTR_001', '2024-03-15', '2024-03-20', 'HOSPITALISATION', 'GAR_HOSP', 'OUVERT', '2 500,00', '2 000,00'),
    ('export_sinistres.csv', 'SIN_002', 'ADH_002', 'CTR_002', '15/04/2024', '01/04/2024', 'DENTAIRE', 'GAR_DENT', 'CLOTURE', '450.50', '380,25'),
    ('export_sinistres.csv', 'SIN_003', 'ADH_003', 'CTR_003', '2024-06-10', '10/06/2024', 'OPTIQUE', 'GAR_OPT', 'EN_RECOURS', '250€', '200'),
    ('export_sinistres.csv', 'SIN_004', 'ADH_004', 'CTR_004', '01/07/2024', '2024-07-05', 'PHARMACIE', 'gar_phar', 'ouvert', '0,00', 'NULL'),
    ('export_sinistres.csv', 'SIN_005', 'ADH_005', 'CTR_005', '2023-12-25', '25-12-2023', 'HOSPITALISATION', 'GAR_HOSP', 'CLOTURE', '-100.00', '0'),
    ('export_sinistres.csv', 'SIN_006', 'ADH_006', 'CTR_006', '15 mai 2024', '2024-05-20', 'DENTAIRE', 'GAR_DENT', 'OUVERT', '1 250,75', '1 000'),
    ('export_sinistres.csv', 'SIN_007', 'ADH_007', 'CTR_007', '2024-08-01', '01/08/2024', 'OPTIQUE', 'GAR_OPT', 'EN_RECOURS', '99999,99', '80 000'),
    
    -- Lignes 8-50 : Variations des types de sinistres + formats sales
    ('export_sinistres.csv', 'SIN_008', 'ADH_008', 'CTR_008', '25/09/2024', '2024-09-30', 'hospitalisation', 'gar_hosp', 'OuVert', '15 000,50', '12 500€'),
    ('export_sinistres.csv', 'SIN_009', 'ADH_009', 'CTR_009', '12-nov-2023', 'NOV 15 2023', 'DENTaire', 'GAR_DENT', 'Clôturé', '0,00', '-25.75'),
    ('export_sinistres.csv', 'SIN_010', 'ADH_010', 'CTR_010', '????-06-15', '15/06/2024', 'OPTique', 'gar_opt', 'EN-RECours', '1.250,99', NULL),
    ('export_sinistres.csv', 'SIN_011', 'ADH_011', 'CTR_011', '2024-10-01', '01-oct-2024', 'PHARmacie', 'GAR-PHAR', 'ouvert ', '500.25€', '450'),
    ('export_sinistres.csv', 'SIN_012', 'ADH_012', 'CTR_012', '15 décembre 2024', '2024/12/20', 'MEDECIN', 'gar_med', 'CLOTURE', '250,75', '200.00'),
    ('export_sinistres.csv', 'SIN_013', 'ADH_013', 'CTR_013', '2025-02-28', '28/02/2025', 'ACCOUCHEMENT', 'GAR_ACC', 'OUVERT', '8 750,00', '7 500'),
    ('export_sinistres.csv', 'SIN_014', 'ADH_014', 'CTR_014', '01/01/2026', '????', 'Chirurgie', 'gar_chir', 'EN_RECOURS', '-999,99', '0'),
    ('export_sinistres.csv', 'SIN_015', 'ADH_015', 'CTR_015', '30-04-2024', '2024-04-25', 'radio', 'GAR_RADIO', 'ClOtUrE', '75.50', '65'),
    
    -- Lignes 51-100 : Nouveaux types + dates incohérentes
    ('export_sinistres.csv', 'SIN_051', 'ADH_051', 'CTR_051', '15 mars 2025', '2025-03-20', 'MANUTENTION', 'GAR_MANUT', 'ouvert', '3 250,00', '2 800'),
    ('export_sinistres.csv', 'SIN_052', 'ADH_052', 'CTR_052', '2024//07//10', '10-07-2024', 'chute hauteur', 'gar_chute_h', 'EN_RECOURS', '25 000€', '20 000'),
    ('export_sinistres.csv', 'SIN_053', 'ADH_053', 'CTR_053', '????', '01/08/2024', 'chute plain-pied', 'GAR_CHUTE_P', 'CLOTURE', '1 500,75', '1 200'),
    ('export_sinistres.csv', 'SIN_054', 'ADH_054', 'CTR_054', '2024-11-15', '15-novembre-2024', 'outillage', 'gar_outil', 'OUVERT', '850.25', NULL),
    ('export_sinistres.csv', 'SIN_055', 'ADH_055', 'CTR_055', '25/12/2024', '2024-12-26', 'agression', 'GAR_AGR', 'EN_RECOURS', '5 000', '4 250€'),
    ('export_sinistres.csv', 'SIN_056', 'ADH_056', 'CTR_056', '01-05-2025', 'mai 2025', 'accident route', 'GAR_ROUTE', 'ouvert', '12 500,50', '10 000'),
    ('export_sinistres.csv', 'SIN_057', 'ADH_057', 'CTR_057', '2023-01-01', '01/01/2023', 'MALADIE PRO', 'gar_mp', 'CLOTURE', '45 000€', '38 250'),
    ('export_sinistres.csv', 'SIN_058', 'ADH_058', 'CTR_058', '15/06/25', '25/06/2025', 'fracture', 'GAR_FRACT', 'OUVERT', '8 750,99', '7 500'),
    
    -- Lignes 101-150 : Montants aberrants + statuts sales
    ('export_sinistres.csv', 'SIN_101', 'ADH_101', 'CTR_101', '2024-12-31', '31/12/2024', 'HOSPITALISATION', 'GAR_HOSP', 'enrecours', '999 999,99', '-888 888,88'),
    ('export_sinistres.csv', 'SIN_102', 'ADH_102', 'CTR_102', '01/01/2024', '2024-01-02', 'DENTAIRE', 'gar_dent', 'ClOture', '0,0001€', '0'),
    ('export_sinistres.csv', 'SIN_103', 'ADH_103', 'CTR_103', '?????', '?????', 'OPTIQUE', 'XXX', '?????', '1 000 000€', NULL),
    ('export_sinistres.csv', 'SIN_104', 'ADH_104', 'CTR_104', '2025-06-15', '15/06/2025', 'PHARMACIE', 'gar_phar', 'ouvert', '-25 000,00', '-20 000'),
    ('export_sinistres.csv', 'SIN_105', 'ADH_105', 'CTR_105', '28/02/2024', '2024-02-29', 'MEDECIN', 'GAR_MED', 'CLOSED', '1234.56,78', '987.65'),
    
    -- Lignes 151-200 : Données très sales (pour tests extrêmes)
    ('export_sinistres.csv', 'SIN_151', 'ADH_151', 'CTR_151', 'ZZZZ', 'AAAA', 'INCONNU', 'NULL', '????', '€€€', '$$$$'),
    ('export_sinistres.csv', 'SIN_152', 'ADH_152', 'CTR_152', '32/13/2024', '00/00/0000', 'hOsPi', 'gArHoSp', 'oUvErT', '1.2.3.4', ',.'),
    ('export_sinistres.csv', 'SIN_153', 'ADH_153', 'CTR_153', '', '', '', '', '', '', ''),
    ('export_sinistres.csv', 'SIN_154', 'ADH_154', 'CTR_154', '2024-99-99', 'déCEMbre 2042', 'ČØµµµ', 'G4R_µµµ', 'øV3rT', '999999999,99€', '-∞'),
    ('export_sinistres.csv', 'SIN_155', 'ADH_155', 'CTR_155', '15/15/2024', '2024-15-15', 'dent@ire', 'G@R_D3NT', 'cl0tûr3', '€500', '500$'),
    
    -- Dernières lignes 196-200
    ('export_sinistres.csv', 'SIN_196', 'ADH_196', 'CTR_196', '31/12/2025', '01/01/2026', 'HOSPITALISATION URGENCE', 'GAR_HOSP_URG', 'EN TRAITEMENT', '150 000,00', '125 000'),
    ('export_sinistres.csv', 'SIN_197', 'ADH_197', 'CTR_197', '???? futur', '????', 'PROTHESE', 'GAR_PROTH', 'OUVERT', '35 000€', '28 000'),
    ('export_sinistres.csv', 'SIN_198', 'ADH_198', 'CTR_198', '2024-04-01', '01/04/2024', 'POIDS EXCES', 'GAR_Poids', 'CLOTURE', '2 500,75', '2 125'),
    ('export_sinistres.csv', 'SIN_199', 'ADH_199', 'CTR_199', '15 août 2024', '2024-08-20', 'THERAPIE', 'gar_ther', 'EN_RECOURS', '7 850,50', '6 500'),
    ('export_sinistres.csv', 'SIN_200', 'ADH_200', 'CTR_200', '?????', 'inconnu', 'SINISTRE INVALIDE', 'XXX', '?????', '999 999 999,99', '-1 000 000€');


-- 5. bronze.reglement_raw - Montants négatifs + formats
INSERT INTO bronze.reglement_raw (
    source_file, id_reglement_src, id_sinistre_src,
    date_reglement_raw, montant_reglement_raw,
    type_reglement_raw, mode_paiement_raw
)
VALUES
    -- Lignes 1-10 (existantes + variations)
    ('export_reglements.csv', 'REG_001', 'SIN_001', '2024-04-10', '1 800,00', 'DEFINITIF', 'VIREMENT'),
    ('export_reglements.csv', 'REG_002', 'SIN_002', '15/05/2024', '350.25', 'PROVISOIRE', 'CHEQUE'),
    ('export_reglements.csv', 'REG_003', 'SIN_003', '2024-07-15', '180€', 'DEFINITIF', 'VIREMENT'),
    ('export_reglements.csv', 'REG_004', 'SIN_004', '10/08/2024', '0,00', 'PROVISOIRE', 'PRELEVEMENT'),
    ('export_reglements.csv', 'REG_005', 'SIN_005', '2024-01-05', '-95.50', 'DEFINITIF', 'CHEQUE'),
    ('export_reglements.csv', 'REG_006', 'SIN_006', '01/06/2024', '950,00', 'DEFINITIF', 'VIREMENT'),
    ('export_reglements.csv', 'REG_007', 'SIN_007', '2024-09-01', '75 000,00', 'PROVISOIRE', NULL),
    ('export_reglements.csv', 'REG_008', 'SIN_008', '25/10/2024', '12 500€', 'déFinItIf', 'Virement SEPA'),
    ('export_reglements.csv', 'REG_009', 'SIN_009', '15-nov-2024', '0.01', 'PROVISOIRE', 'Chèque'),
    ('export_reglements.csv', 'REG_010', 'SIN_010', '????', '-999,99', 'DEFINITIF', NULL),
    
    -- Lignes 11-50 : Montants variés + formats dates sales
    ('export_reglements.csv', 'REG_011', 'SIN_011', '01 décembre 2024', '2 750,25', 'PROVISOIRE', 'Prélèvement'),
    ('export_reglements.csv', 'REG_012', 'SIN_012', '2024/12/15', '150.75€', 'Définitif', 'Virement'),
    ('export_reglements.csv', 'REG_013', 'SIN_013', '25-12-2024', '0,00', 'provisoire', 'CHEQUE'),
    ('export_reglements.csv', 'REG_014', 'SIN_014', '31/01/2025', '-250.50', 'DEFINITIF', 'PRELEVEMENT SEPA'),
    ('export_reglements.csv', 'REG_015', 'SIN_015', '15 mars 2025', '8 500,00', 'PROVISOIRE', NULL),
    ('export_reglements.csv', 'REG_016', 'SIN_016', '2025-04-01', '1.250,99', 'dEfInItIf', 'VIREMENT URBAIN'),
    ('export_reglements.csv', 'REG_017', 'SIN_017', 'mai 2025', '45 000€', 'PROVISOIRE', 'Chèque trésorerie'),
    ('export_reglements.csv', 'REG_018', 'SIN_018', '15/06/25', '-1 500,75', 'DEFINITIF', 'PRELEVEMENT'),
    ('export_reglements.csv', 'REG_019', 'SIN_019', '30/07/2025', '99999,99', 'Provisoire', 'Virement international'),
    ('export_reglements.csv', 'REG_020', 'SIN_020', '???? futur', '0.0001', 'Définitif', NULL),
    
    -- Lignes 51-100 : Types de règlements variés + montants aberrants
    ('export_reglements.csv', 'REG_051', 'SIN_051', '2025-03-20', '2 800,00', 'PARTIEL', 'VIREMENT'),
    ('export_reglements.csv', 'REG_052', 'SIN_052', '10/08/2025', '20 000€', 'SOLDE DEFINITIF', 'CHEQUE'),
    ('export_reglements.csv', 'REG_053', 'SIN_053', '15-09-2025', '1 200,50', 'AVANCE', 'PRELEVEMENT'),
    ('export_reglements.csv', 'REG_054', 'SIN_054', '01/10/2025', '-850.25', 'A COMPTER', 'VIREMENT'),
    ('export_reglements.csv', 'REG_055', 'SIN_055', '25/11/2025', '4 250€', 'PROVISIONNE', 'CHEQUE'),
    ('export_reglements.csv', 'REG_056', 'SIN_056', '2025-12-01', '10 000,00', 'DEFINITIF FINAL', NULL),
    ('export_reglements.csv', 'REG_057', 'SIN_057', '15/12/2025', '38 250', 'PARTIEL RECOURS', 'VIREMENT RECOURS'),
    ('export_reglements.csv', 'REG_058', 'SIN_058', '31/12/2025', '7 500€', 'SOLDE', 'PRELEVEMENT'),
    
    -- Lignes 101-150 : Modes de paiement étendus + formats sales
    ('export_reglements.csv', 'REG_101', 'SIN_101', '2026-01-15', '-888 888,88', 'dEfInItIf', 'VirementSEPA'),
    ('export_reglements.csv', 'REG_102', 'SIN_102', '01/02/2026', '0,0001€', 'PROVISOIRE', 'Chèque trésorerie'),
    ('export_reglements.csv', 'REG_103', 'SIN_103', '?????', '1 000 000€', '????', 'Inconnu'),
    ('export_reglements.csv', 'REG_104', 'SIN_104', '15/03/2026', '-20 000', 'DEFINITIF', 'PrélèvemenT'),
    ('export_reglements.csv', 'REG_105', 'SIN_105', '30/04/2026', '987.65€', 'PARTIEL', 'Virement express'),
    ('export_reglements.csv', 'REG_106', 'SIN_106', '2026//05//01', '25 000,99', 'SOLDE DEFINITIF', 'CHÈQUE'),
    ('export_reglements.csv', 'REG_107', 'SIN_107', '15-juin-2026', '-5 000€', 'A RECUPERER', 'PRELEVMT'),
    ('export_reglements.csv', 'REG_108', 'SIN_108', '01/07/2026', '150 000,00', 'DEFINITIF', 'Virement bancaire'),
    
    -- Lignes 151-200 : Données très sales (tests extrêmes ETL)
    ('export_reglements.csv', 'REG_151', 'SIN_151', 'ZZZZ', '€€€€', 'DéFïNiTiF', '$$$$'),
    ('export_reglements.csv', 'REG_152', 'SIN_152', '32/13/2026', '1.2.3.4.5', 'Pr0v1s0ir3', 'Ch3que'),
    ('export_reglements.csv', 'REG_153', 'SIN_153', '', '', '', ''),
    ('export_reglements.csv', 'REG_154', 'SIN_154', '99/99/9999', '999.999.999,99€', 'ÇØÐÈFÏÑÏŢÏV', 'VïRÈMÇŢ'),
    ('export_reglements.csv', 'REG_155', 'SIN_155', '00/00/0000', '-∞', 'NULL', 'Inconnu'),
    ('export_reglements.csv', 'REG_156', 'SIN_156', '29/02/2026', '1234567890123,45', 'proVisoire', 'PrélèvementSEPA'),
    
    -- Dernières lignes 195-200 : Montants réalistes + aberrants
    ('export_reglements.csv', 'REG_195', 'SIN_195', '15/02/2026', '125 000,00', 'DEFINITIF FINAL', 'VIREMENT SEPA'),
    ('export_reglements.csv', 'REG_196', 'SIN_196', '28/02/2026', '2 125€', 'SOLDE', 'CHEQUE TRE SORERIE'),
    ('export_reglements.csv', 'REG_197', 'SIN_197', '15/03/2026', '28 000,00', 'PARTIEL', 'Virement'),
    ('export_reglements.csv', 'REG_198', 'SIN_198', '01/04/2026', '-1 250,75', 'A COMPTER', 'PRELEVEMENT'),
    ('export_reglements.csv', 'REG_199', 'SIN_199', '30/04/2026', '6 500€', 'DEFINITIF', 'VIREMENT'),
    ('export_reglements.csv', 'REG_200', 'SIN_200', '???? 2026', '-1 000 000,00€', 'INVALIDE', 'NULL');



