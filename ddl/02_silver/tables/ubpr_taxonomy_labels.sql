CREATE TABLE IF NOT EXISTS FFIEC.SILVER.UBPR_TAXONOMY_LABELS (
    CONCEPT_ID   VARCHAR,
    CONCEPT_REF  VARCHAR,
    LABEL_ROLE   VARCHAR,
    LABEL_TEXT   VARCHAR
)
COMMENT = 'Human-readable captions per UBPR concept from ubpr-v183-Label.xml. lineCaption = page/section title, columnCaption = column identifier (A/B/C).';
