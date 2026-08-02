-- One row per institution per filing period from Panel of Reporters
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.SILVER.INSTITUTIONS (
  IDRSSD NUMBER(38,0),
  PERIOD_END DATE,
  FDIC_CERT_NUMBER VARCHAR,
  OCC_CHARTER_NUMBER VARCHAR,
  FI_NAME VARCHAR,
  FI_ADDRESS VARCHAR,
  FI_CITY VARCHAR,
  FI_STATE VARCHAR,
  FI_ZIP_CODE VARCHAR,
  FI_FILING_TYPE VARCHAR,
  LAST_SUBMISSION_UPDATED_ON TIMESTAMP_NTZ(9)
)
COMMENT = 'One row per institution per filing period. Sourced from Panel of Reporters. Filing type (051/041/031) determines which schedules/items the bank reports.';
