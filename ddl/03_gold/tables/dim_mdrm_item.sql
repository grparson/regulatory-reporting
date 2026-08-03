CREATE TABLE IF NOT EXISTS FFIEC.GOLD.DIM_MDRM_ITEM (
    MDRM_CODE           VARCHAR NOT NULL PRIMARY KEY,
    MNEMONIC            VARCHAR,
    ITEM_CODE           VARCHAR,
    ITEM_NAME           VARCHAR,
    ITEM_TYPE           VARCHAR,
    REPORTING_FORM      VARCHAR,
    XBRL_TYPE           VARCHAR,
    FORMULA_EXPRESSION  VARCHAR COMMENT 'UBPR calculation formula from taxonomy (NULL for Call Report items)'
)
COMMENT = 'One row per MDRM code - current label only, deduped from silver.mdrm_dictionary preferring open (end_date=9999-12-31) Call Report forms (031/041/051) since that is the population this project covers. Full validity history remains in silver.mdrm_dictionary for provenance.';
