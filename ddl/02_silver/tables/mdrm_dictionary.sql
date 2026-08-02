-- Validity-windowed MDRM data dictionary with one row per (code, form, period)
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.SILVER.MDRM_DICTIONARY (
  MDRM_CODE VARCHAR,
  MNEMONIC VARCHAR,
  ITEM_CODE VARCHAR,
  START_DATE DATE,
  END_DATE DATE,
  ITEM_NAME VARCHAR,
  ITEM_TYPE VARCHAR,
  REPORTING_FORM VARCHAR,
  DESCRIPTION VARCHAR
)
COMMENT = 'Validity-windowed MDRM dictionary. One row per (code, form, validity period) - deliberately NOT collapsed to current-only, since 5-10 years of history means a code''s definition may have changed. Facts should join on period_end BETWEEN start_date AND end_date.';
