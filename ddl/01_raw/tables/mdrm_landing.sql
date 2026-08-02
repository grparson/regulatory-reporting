-- Landing table for MDRM data dictionary
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.RAW.MDRM_LANDING (
  MNEMONIC VARCHAR,
  ITEM_CODE VARCHAR,
  START_DATE VARCHAR,
  END_DATE VARCHAR,
  ITEM_NAME VARCHAR,
  CONFIDENTIALITY VARCHAR,
  ITEM_TYPE VARCHAR,
  REPORTING_FORM VARCHAR,
  DESCRIPTION VARCHAR,
  SERIES_GLOSSARY VARCHAR
)
COMMENT = 'Bronze landing for MDRM data dictionary. Row 0 (PUBLIC) and row 1 (header) skipped at load. One row per (code, form, validity period) - NOT one row per code.';
