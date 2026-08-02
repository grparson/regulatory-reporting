-- Star schema dimension: one row per institution per period
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.GOLD.DIM_INSTITUTION (
  INSTITUTION_KEY NUMBER(38,0),
  IDRSSD NUMBER(38,0),
  PERIOD_END DATE,
  FDIC_CERT_NUMBER VARCHAR,
  OCC_CHARTER_NUMBER VARCHAR,
  FI_NAME VARCHAR,
  FI_CITY VARCHAR,
  FI_STATE VARCHAR,
  FI_FILING_TYPE VARCHAR
)
COMMENT = 'One row per institution per period. Not yet SCD-tracked - single quarter loaded so far; revisit change-tracking once multiple quarters are loaded.';
