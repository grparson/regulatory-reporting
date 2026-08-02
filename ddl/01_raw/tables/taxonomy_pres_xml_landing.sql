-- Landing table for Form041 presentation linkbase
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.RAW.TAXONOMY_PRES_XML_LANDING (
  SOURCE_FORM VARCHAR,
  TAXONOMY_VERSION VARCHAR,
  XML_DOC VARIANT
)
COMMENT = 'Bronze landing for Form041 presentation linkbase (concept to presentation-node arcs) - whole document as one VARIANT row.';
