-- Landing table for Form041 reference linkbase (schedule/line/column positions)
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.RAW.TAXONOMY_REF_XML_LANDING (
  SOURCE_FORM VARCHAR,
  TAXONOMY_VERSION VARCHAR,
  XML_DOC VARIANT
)
COMMENT = 'Bronze landing for Form041 reference linkbase (schedule/line/column position per concept) - whole document as one VARIANT row.';
