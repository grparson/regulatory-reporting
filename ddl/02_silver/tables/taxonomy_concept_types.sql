-- Authoritative XBRL data types per MDRM code from concepts.xsd
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.SILVER.TAXONOMY_CONCEPT_TYPES (
  MDRM_CODE VARCHAR,
  XBRL_TYPE VARCHAR,
  PERIOD_TYPE VARCHAR,
  BALANCE VARCHAR,
  SOURCE_FORM VARCHAR,
  TAXONOMY_VERSION VARCHAR
)
COMMENT = 'Authoritative per-code XBRL data type, parsed from the Form041 concepts.xsd element declarations. Replaces MDRM ITEM_TYPE (too coarse) as the type source for casting decisions in CALL_FACTS. One row per code per form/version.';
