-- Populate GOLD.FACT_UBPR from silver, filtering to current quarter only.
-- Only includes facts where PERIOD_END matches the bulk download quarter.
-- Enriches with DATA_TYPE from DIM_MDRM_ITEM.
-- Run after SILVER.UBPR_FACTS and DIM_MDRM_ITEM are populated.

TRUNCATE TABLE IF EXISTS FFIEC.GOLD.FACT_UBPR;

INSERT INTO FFIEC.GOLD.FACT_UBPR
(ID_RSSD, PERIOD_END, PERIOD_TYPE, MDRM_CODE, NAMESPACE, VALUE_NUMERIC, VALUE_TEXT, DATA_TYPE, UNIT)
SELECT 
    uf.ID_RSSD
    , uf.PERIOD_END
    , uf.PERIOD_TYPE
    , uf.MDRM_CODE
    , uf.NAMESPACE
    , uf.VALUE_NUMERIC
    , uf.VALUE_TEXT
    , d.XBRL_TYPE AS DATA_TYPE
    , uf.UNIT
FROM FFIEC.SILVER.UBPR_FACTS uf
LEFT JOIN FFIEC.GOLD.DIM_MDRM_ITEM d ON d.MDRM_CODE = uf.MDRM_CODE
WHERE uf.PERIOD_END = uf.BULK_PERIOD_END;
