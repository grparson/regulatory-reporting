-- Landing table for Form041 label linkbase (caption text)
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.RAW.TAXONOMY_CAP_XML_LANDING (
  SOURCE_FORM VARCHAR,
  TAXONOMY_VERSION VARCHAR,
  XML_DOC VARIANT
)
COMMENT = 'Bronze landing for Form041 label linkbase (presentation-node caption text, line/column captions) - whole document as one VARIANT row.';
