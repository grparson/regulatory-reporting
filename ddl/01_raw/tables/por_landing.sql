-- Landing table for Call Report Panel of Reporters (institution metadata)
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.RAW.POR_LANDING (
  IDRSSD NUMBER(38,0),
  FDIC_CERT_NUMBER VARCHAR,
  OCC_CHARTER_NUMBER VARCHAR,
  OTS_DOCKET_NUMBER VARCHAR,
  PRIMARY_ABA_ROUTING_NUMBER VARCHAR,
  FI_NAME VARCHAR,
  FI_ADDRESS VARCHAR,
  FI_CITY VARCHAR,
  FI_STATE VARCHAR,
  FI_ZIP_CODE VARCHAR,
  FI_FILING_TYPE VARCHAR,
  LAST_SUBMISSION_UPDATED_ON VARCHAR,
  PERIOD_END DATE
)
COMMENT = 'Bronze landing for Call Report Panel of Reporters (institution metadata). Schema is stable across quarters per source docs.';
