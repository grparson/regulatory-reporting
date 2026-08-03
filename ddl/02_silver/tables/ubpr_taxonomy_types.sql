CREATE TABLE IF NOT EXISTS FFIEC.SILVER.UBPR_TAXONOMY_TYPES (
    MDRM_CODE           VARCHAR,
    XBRL_TYPE           VARCHAR,
    SUBSTITUTION_GROUP  VARCHAR,
    PERIOD_TYPE         VARCHAR,
    NILLABLE            BOOLEAN
)
COMMENT = 'XBRL data type per UBPR/cc concept from ubpr-v183-Concepts.xsd. Used to drive numeric vs text casting and gold-layer DATA_TYPE.';
