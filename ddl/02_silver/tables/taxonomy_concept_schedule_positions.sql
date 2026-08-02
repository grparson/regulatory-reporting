-- Schedule/line/column positions per MDRM code from reference linkbase
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.SILVER.TAXONOMY_CONCEPT_SCHEDULE_POSITIONS (
  MDRM_CODE VARCHAR,
  REPORT VARCHAR,
  SCHEDULE_NAME VARCHAR,
  LINE_NUM VARCHAR,
  COLUMN_LETTER VARCHAR,
  SOURCE_FORM VARCHAR,
  TAXONOMY_VERSION VARCHAR
)
COMMENT = 'One-to-many schedule/line/column position per MDRM code, parsed from ref.xml. A concept can appear on multiple schedules (confirmed RCON2170 appears on both RC and RCRII) - deliberately not collapsed to one row per code.';
