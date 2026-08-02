-- Landing table for Form041 concepts.xsd
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.RAW.TAXONOMY_CONCEPTS_XML_LANDING (
  SOURCE_FORM VARCHAR,
  TAXONOMY_VERSION VARCHAR,
  XML_DOC VARIANT
)
COMMENT = 'Bronze landing for Form041 concepts.xsd - whole document as one VARIANT row. Source-as-source: raw parsed XML, no transformation beyond PARSE_XML. Form-level artifact, covers all Call Report schedules for this form/version.';
