CREATE OR REPLACE PROCEDURE "SP_BUILD_HEADER_MAPS_AND_UNPIVOT"()
RETURNS VARCHAR
LANGUAGE SQL
COMMENT='Builds SCHEDULE_HEADER_MAP entries and unpivots landing tables into SILVER.CALL_FACTS for all schedules in SCHEDULE_LOAD_META that do not already have facts loaded. Includes TRY_TO_NUMBER(COL0) defense against source data defects (embedded newlines splitting text into phantom rows where COL0 is non-numeric). Skips schedules already present in CALL_FACTS to allow safe re-runs after partial failures.'
EXECUTE AS OWNER
AS '
DECLARE
  c_schedules CURSOR FOR
    SELECT DISTINCT m.SCHEDULE_NAME
    FROM FFIEC.RAW.SCHEDULE_LOAD_META m
    WHERE m.SCHEDULE_NAME NOT IN (SELECT DISTINCT SCHEDULE_NAME FROM FFIEC.SILVER.CALL_FACTS);
  v_sched VARCHAR;
  v_sql VARCHAR;
  v_maps_built NUMBER DEFAULT 0;
  v_facts_inserted NUMBER DEFAULT 0;
BEGIN
  OPEN c_schedules;
  FOR rec IN c_schedules DO
    v_sched := rec.SCHEDULE_NAME;

    -- Build header map (skip if already exists for this schedule)
    v_sql := ''
    INSERT INTO FFIEC.SILVER.SCHEDULE_HEADER_MAP (SCHEDULE_NAME, PERIOD_END, COL_NAME, MDRM_CODE, ITEM_DESCRIPTION, PART_NUM)
    WITH base AS (
      SELECT SCHEDULE_NAME, PERIOD_END, PART_NUM, FILE_ROW_NUM, OBJECT_CONSTRUCT(*) AS ROW_OBJ
      FROM FFIEC.RAW.CALL_'' || v_sched || ''_LANDING
      WHERE FILE_ROW_NUM IN (1, 2)
    ),
    codes AS (
      SELECT b.SCHEDULE_NAME, b.PERIOD_END, b.PART_NUM, f.KEY AS COL_NAME, f.VALUE::STRING AS MDRM_CODE
      FROM base b, LATERAL FLATTEN(INPUT => b.ROW_OBJ) f
      WHERE b.FILE_ROW_NUM = 1 AND f.KEY LIKE ''''COL%'''' AND f.KEY != ''''COL0''''
    ),
    descs AS (
      SELECT b.SCHEDULE_NAME, b.PERIOD_END, b.PART_NUM, f.KEY AS COL_NAME, f.VALUE::STRING AS ITEM_DESCRIPTION
      FROM base b, LATERAL FLATTEN(INPUT => b.ROW_OBJ) f
      WHERE b.FILE_ROW_NUM = 2 AND f.KEY LIKE ''''COL%'''' AND f.KEY != ''''COL0''''
    )
    SELECT c.SCHEDULE_NAME, c.PERIOD_END, c.COL_NAME, c.MDRM_CODE, d.ITEM_DESCRIPTION, c.PART_NUM
    FROM codes c
    JOIN descs d
      ON c.SCHEDULE_NAME = d.SCHEDULE_NAME AND c.PERIOD_END = d.PERIOD_END
      AND COALESCE(c.PART_NUM,-1) = COALESCE(d.PART_NUM,-1) AND c.COL_NAME = d.COL_NAME
    WHERE c.MDRM_CODE IS NOT NULL
      AND c.SCHEDULE_NAME NOT IN (SELECT DISTINCT SCHEDULE_NAME FROM FFIEC.SILVER.SCHEDULE_HEADER_MAP WHERE SCHEDULE_NAME = '''''' || v_sched || '''''')'';
    EXECUTE IMMEDIATE v_sql;
    v_maps_built := v_maps_built + 1;

    -- Unpivot into CALL_FACTS with TRY_TO_NUMBER defense on COL0
    v_sql := ''
    INSERT INTO FFIEC.SILVER.CALL_FACTS
    WITH base AS (
      SELECT SCHEDULE_NAME, PERIOD_END, PART_NUM, COL0 AS IDRSSD_TEXT, OBJECT_CONSTRUCT(*) AS ROW_OBJ
      FROM FFIEC.RAW.CALL_'' || v_sched || ''_LANDING
      WHERE FILE_ROW_NUM >= 3 AND TRY_TO_NUMBER(COL0) IS NOT NULL
    ),
    data_flat AS (
      SELECT b.IDRSSD_TEXT, b.SCHEDULE_NAME, b.PERIOD_END, b.PART_NUM, f.KEY AS COL_NAME, f.VALUE::STRING AS VALUE_TEXT
      FROM base b, LATERAL FLATTEN(INPUT => b.ROW_OBJ) f
      WHERE f.KEY LIKE ''''COL%'''' AND f.KEY != ''''COL0''''
    ),
    typed AS (
      SELECT
        d.IDRSSD_TEXT::NUMBER AS IDRSSD, d.PERIOD_END, d.SCHEDULE_NAME, h.MDRM_CODE, d.VALUE_TEXT,
        COALESCE(t.XBRL_TYPE, CASE dm.ITEM_TYPE WHEN ''''F'''' THEN NULL ELSE dm.ITEM_TYPE END) AS DATA_TYPE
      FROM data_flat d
      JOIN FFIEC.SILVER.SCHEDULE_HEADER_MAP h
        ON d.SCHEDULE_NAME = h.SCHEDULE_NAME AND d.PERIOD_END = h.PERIOD_END AND d.COL_NAME = h.COL_NAME
        AND COALESCE(d.PART_NUM,-1) = COALESCE(h.PART_NUM,-1)
      LEFT JOIN FFIEC.SILVER.TAXONOMY_CONCEPT_TYPES t ON h.MDRM_CODE = t.MDRM_CODE
      LEFT JOIN FFIEC.GOLD.DIM_MDRM_ITEM dm ON h.MDRM_CODE = dm.MDRM_CODE
      WHERE d.VALUE_TEXT IS NOT NULL
    )
    SELECT IDRSSD, PERIOD_END, SCHEDULE_NAME, MDRM_CODE, DATA_TYPE, VALUE_TEXT,
      CASE
        WHEN DATA_TYPE IN (''''xbrli:monetaryItemType'''',''''ffieci:nonNegativeMonetaryItemType'''',''''xbrli:integerItemType'''',''''xbrli:nonNegativeIntegerItemType'''',''''xbrli:pureItemType'''') THEN TRY_TO_NUMBER(VALUE_TEXT, 38, 2)
        WHEN DATA_TYPE IN (''''xbrli:stringItemType'''',''''xbrli:booleanItemType'''') THEN NULL
        ELSE TRY_TO_NUMBER(VALUE_TEXT, 38, 2)
      END AS VALUE_NUMERIC
    FROM typed'';
    EXECUTE IMMEDIATE v_sql;
    v_facts_inserted := v_facts_inserted + 1;
  END FOR;
  CLOSE c_schedules;

  RETURN ''Header maps built for '' || v_maps_built::VARCHAR || '' schedules, facts inserted for '' || v_facts_inserted::VARCHAR || '' schedules'';
END
';