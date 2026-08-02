-- Maps landing table column positions (COLn) to MDRM codes per schedule/period/part
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.SILVER.SCHEDULE_HEADER_MAP (
  SCHEDULE_NAME VARCHAR,
  PERIOD_END DATE,
  COL_NAME VARCHAR,
  MDRM_CODE VARCHAR,
  ITEM_DESCRIPTION VARCHAR,
  PART_NUM NUMBER(38,0)
)
COMMENT = 'Maps landing table column position (COLn) to MDRM code + short description, per schedule/period/part. PART_NUM disambiguates multi-file schedules (e.g. RCRII) where each file part reuses the same COLn namespace for different codes; NULL for single-file schedules.';
