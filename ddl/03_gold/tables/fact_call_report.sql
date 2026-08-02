-- Star schema fact table: tall/atomic Call Report measurements
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.GOLD.FACT_CALL_REPORT (
  INSTITUTION_KEY NUMBER(38,0),
  PERIOD_KEY DATE,
  SCHEDULE_NAME VARCHAR,
  MDRM_CODE VARCHAR,
  VALUE_TEXT VARCHAR,
  VALUE_NUMERIC NUMBER(38,2)
)
COMMENT = 'Star-schema fact table, tall/atomic. Keys + measures only. Monetary items are THOUSANDS of USD, unscaled here (scaling happens in presentation views). RCON (domestic) and RCFD (consolidated) remain distinct MDRM codes.';
