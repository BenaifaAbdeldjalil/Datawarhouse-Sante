/*
=========================================================
01_init_schemas.sql
Initialisation des schémas du Data Warehouse
Architecture : Bronze / Silver / Gold
=========================================================
*/

-- Suppression si existant (DEV uniquement)
DROP SCHEMA IF EXISTS bronze CASCADE;
DROP SCHEMA IF EXISTS silver CASCADE;
DROP SCHEMA IF EXISTS gold CASCADE;

-- Création des couches
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

COMMENT ON SCHEMA bronze IS 'Zone de données brutes historisées';
COMMENT ON SCHEMA silver IS 'Zone de données nettoyées et standardisées';
COMMENT ON SCHEMA gold IS 'Zone de datamarts métiers (Data Products)';
