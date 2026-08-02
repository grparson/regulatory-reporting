-- Form-accurate captions per (code, schedule) from presentation and label linkbases
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.SILVER.TAXONOMY_CONCEPT_CAPTIONS (
  MDRM_CODE VARCHAR,
  SCHEDULE_NAME VARCHAR,
  LINE_CAPTION VARCHAR,
  COLUMN_CAPTION VARCHAR,
  SOURCE_FORM VARCHAR,
  TAXONOMY_VERSION VARCHAR
)
COMMENT = 'Form-accurate caption per (code, schedule), assembled via a two-hop join: pres.xml gives concept->presentation-line-node->schedule-root arcs, cap.xml gives presentation-line-node->caption-text label arcs. Schedule-specific by design (confirmed RCON2170 has different captions on RC vs RCRII).';
