-- Star schema dimension: one row per MDRM code with current label
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.GOLD.DIM_MDRM_ITEM (
  MDRM_CODE VARCHAR NOT NULL,
  MNEMONIC VARCHAR,
  ITEM_CODE VARCHAR,
  ITEM_NAME VARCHAR,
  ITEM_TYPE VARCHAR,
  REPORTING_FORM VARCHAR,
  XBRL_TYPE VARCHAR,
  PRIMARY KEY (MDRM_CODE)
)
COMMENT = 'One row per MDRM code - current label only, deduped from silver.mdrm_dictionary preferring open (end_date=9999-12-31) Call Report forms (031/041/051) since that is the population this project covers.';
