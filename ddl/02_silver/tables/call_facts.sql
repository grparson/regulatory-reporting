-- Tall/EAV Call Report facts with type-aware numeric casting
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.SILVER.CALL_FACTS (
  IDRSSD NUMBER(38,0),
  PERIOD_END DATE,
  SCHEDULE_NAME VARCHAR,
  MDRM_CODE VARCHAR,
  DATA_TYPE VARCHAR,
  VALUE_TEXT VARCHAR,
  VALUE_NUMERIC NUMBER(38,2)
)
COMMENT = 'Tall/EAV Call Report facts. DATA_TYPE sourced from TAXONOMY_CONCEPT_TYPES (MDRM ITEM_TYPE as fallback for codes the current taxonomy does not cover). VALUE_NUMERIC is populated ONLY for numeric XBRL types (monetary, nonNegativeMonetary, integer, nonNegativeInteger, pure) - string/boolean-typed codes keep VALUE_TEXT as the sole representation even if the text happens to look numeric, avoiding silent miscasting of categorical codes (e.g. audit indicator "1a"). Absent items produce no row (absence != zero). Dollar amounts as reported by source = THOUSANDS of USD, not yet scaled here.';
