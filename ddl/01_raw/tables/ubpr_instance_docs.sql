CREATE TABLE IF NOT EXISTS FFIEC.RAW.UBPR_INSTANCE_DOCS (
    SOURCE_FILE       VARCHAR       COMMENT 'Original filename from stage (includes ID_RSSD in name)',
    BULK_PERIOD_END   DATE          COMMENT 'Quarter-end date of the bulk download this file belongs to',
    RAW_XML           VARIANT       COMMENT 'Full XBRL instance document parsed to VARIANT via PARSE_XML',
    LOADED_AT         TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP() COMMENT 'When this row was loaded'
)
COMMENT = 'Bronze landing for UBPR XBRL instance documents - one row per bank per bulk download quarter. Raw XML preserved as VARIANT for re-parsing.';
