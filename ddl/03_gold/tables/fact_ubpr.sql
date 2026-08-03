CREATE TABLE IF NOT EXISTS FFIEC.GOLD.FACT_UBPR (
    ID_RSSD         NUMBER          COMMENT 'Federal Reserve institution identifier',
    PERIOD_END      DATE            COMMENT 'Reporting period end date',
    PERIOD_TYPE     VARCHAR(8)      COMMENT 'instant or duration',
    MDRM_CODE       VARCHAR(12)     COMMENT 'MDRM code (UBPR or Call Report source concept)',
    NAMESPACE       VARCHAR(4)      COMMENT 'uc = UBPR computed, cc = Call Report source',
    VALUE_NUMERIC   NUMBER(38,6)    COMMENT 'Numeric value. USD amounts in FULL DOLLARS (not thousands)',
    VALUE_TEXT      VARCHAR         COMMENT 'Raw text value (all codes; useful for non-numeric items)',
    DATA_TYPE       VARCHAR(50)     COMMENT 'XBRL type from taxonomy (monetaryItemType, pureItemType, etc.)',
    UNIT            VARCHAR(20)     COMMENT 'XBRL unit: USD, PURE, NON-MONETARY'
)
COMMENT = 'Gold UBPR fact table - current quarter only (PERIOD_END = BULK_PERIOD_END). Star schema: joins to DIM_MDRM_ITEM, DIM_INSTITUTION, DIM_PERIOD. Values in FULL DOLLARS.';
