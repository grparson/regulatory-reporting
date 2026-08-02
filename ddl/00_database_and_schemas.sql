-- Database and schema creation for the FFIEC regulatory reporting medallion architecture
-- Co-authored with CoCo

CREATE DATABASE IF NOT EXISTS FFIEC;

CREATE SCHEMA IF NOT EXISTS FFIEC.RAW;
CREATE SCHEMA IF NOT EXISTS FFIEC.SILVER;
CREATE SCHEMA IF NOT EXISTS FFIEC.GOLD;
