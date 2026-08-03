-- Load UBPR facts from bronze VARIANT into silver EAV table.
-- Processes all periods from each XBRL instance document.
-- Run after UBPR_INSTANCE_DOCS is populated from @STG_UBPR_BULK.
--
-- Facts identified by @contextRef IS NOT NULL (only fact elements have this attribute).
-- Context ID pattern: {CI|CD}_{RSSD}_{YYYY-MM-DD} parsed via string functions.
-- Both uc: (UBPR computed) and cc: (Call Report source) namespaces extracted.

TRUNCATE TABLE IF EXISTS FFIEC.SILVER.UBPR_FACTS;

INSERT INTO FFIEC.SILVER.UBPR_FACTS
(ID_RSSD, PERIOD_END, PERIOD_TYPE, BULK_PERIOD_END, MDRM_CODE, NAMESPACE, VALUE_TEXT, VALUE_NUMERIC, UNIT, DECIMALS, SOURCE_FILE)
SELECT 
    TRY_TO_NUMBER(SPLIT_PART(f.VALUE:"@contextRef"::VARCHAR, '_', 2)) AS id_rssd
    , TRY_TO_DATE(SUBSTR(
        f.VALUE:"@contextRef"::VARCHAR
        , LEN(SPLIT_PART(f.VALUE:"@contextRef"::VARCHAR, '_', 1)) + 1 
          + LEN(SPLIT_PART(f.VALUE:"@contextRef"::VARCHAR, '_', 2)) + 2
    )) AS period_end
    , CASE WHEN LEFT(f.VALUE:"@contextRef"::VARCHAR, 2) = 'CI' THEN 'instant' ELSE 'duration' END AS period_type
    , d.BULK_PERIOD_END
    , CASE 
        WHEN f.VALUE:"@"::VARCHAR LIKE 'uc:%' THEN SUBSTR(f.VALUE:"@"::VARCHAR, 4)
        WHEN f.VALUE:"@"::VARCHAR LIKE 'cc:%' THEN SUBSTR(f.VALUE:"@"::VARCHAR, 4)
        ELSE f.VALUE:"@"::VARCHAR
      END AS mdrm_code
    , CASE 
        WHEN f.VALUE:"@"::VARCHAR LIKE 'uc:%' THEN 'uc'
        WHEN f.VALUE:"@"::VARCHAR LIKE 'cc:%' THEN 'cc'
        ELSE 'other'
      END AS namespace
    , f.VALUE:"$"::VARCHAR AS value_text
    , TRY_TO_NUMBER(f.VALUE:"$"::VARCHAR, 38, 6) AS value_numeric
    , f.VALUE:"@unitRef"::VARCHAR AS unit
    , f.VALUE:"@decimals"::NUMBER AS decimals
    , d.SOURCE_FILE
FROM FFIEC.RAW.UBPR_INSTANCE_DOCS d
    , LATERAL FLATTEN(input => d.RAW_XML:"$") f
WHERE f.VALUE:"@contextRef" IS NOT NULL;
