CREATE TABLE IF NOT EXISTS FFIEC.SILVER.UBPR_FACTS (
    ID_RSSD           NUMBER          COMMENT 'Federal Reserve institution identifier, parsed from XBRL context',
    PERIOD_END        DATE            COMMENT 'Reporting period end date (instant date or duration endDate)',
    PERIOD_TYPE       VARCHAR(8)      COMMENT 'instant or duration - from XBRL context type',
    BULK_PERIOD_END   DATE            COMMENT 'Quarter-end of the bulk download file (for refiling/snapshot tracking)',
    MDRM_CODE         VARCHAR(12)     COMMENT 'MDRM code (e.g. UBPR7204, RCON2170) - namespace prefix stripped',
    NAMESPACE         VARCHAR(4)      COMMENT 'uc = UBPR computed value, cc = Call Report source concept',
    VALUE_TEXT        VARCHAR         COMMENT 'Raw string value as reported in XBRL',
    VALUE_NUMERIC     NUMBER(38,6)    COMMENT 'Numeric cast of value (NULL if non-numeric). USD values in FULL DOLLARS (not thousands)',
    UNIT              VARCHAR(20)     COMMENT 'XBRL unit: USD, PURE (ratio/percent), NON-MONETARY',
    DECIMALS          NUMBER(2)       COMMENT 'XBRL decimals attribute (precision indicator)',
    SOURCE_FILE       VARCHAR         COMMENT 'Stage filename for lineage/debugging'
)
COMMENT = 'Silver UBPR facts - tall/EAV, all periods from each bulk download tagged with BULK_PERIOD_END. Values in FULL DOLLARS (not thousands like Call Report TDF).';
