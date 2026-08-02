-- Landing table for Call Report Schedule NARR (examiner narrative)
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.RAW.CALL_NARR_LANDING (
  SCHEDULE_NAME VARCHAR,
  PERIOD_END DATE,
  FILE_ROW_NUM NUMBER(38,0),
  COL0 VARCHAR,
  COL1 VARCHAR,
  COL2 VARCHAR
)
COMMENT = 'Bronze landing for Call Report Schedule NARR (examiner narrative). RCON6979 = has-comment boolean flag, TEXT6980 = free-text narrative (stringItemType). Confirmed genuinely useful content (banks explaining specific balance sheet items/adjustments) - candidate for future Cortex AI text analysis (AI_SUMMARIZE_AGG/AI_CLASSIFY), not built in this pass.';
