-- Examiner narrative text modeled separately from EAV facts
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.SILVER.EXAMINER_NARRATIVES (
  IDRSSD NUMBER(38,0),
  PERIOD_END DATE,
  HAS_COMMENT BOOLEAN,
  NARRATIVE_TEXT VARCHAR
)
COMMENT = 'Schedule NARR (examiner narrative), modeled separately from CALL_FACTS rather than as EAV rows - free text is not a measurement to aggregate, unlike every other Call Report item.';
