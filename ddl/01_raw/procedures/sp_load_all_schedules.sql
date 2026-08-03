CREATE OR REPLACE PROCEDURE "SP_LOAD_ALL_SCHEDULES"()
RETURNS VARCHAR
LANGUAGE SQL
COMMENT='Bulk-creates landing tables and loads all Call Report schedule files from stage for a single quarter. Reads schedule metadata (file names, column counts, part numbers) from SCHEDULE_LOAD_META temp table. Currently hardcoded to 2026-Q1 file naming convention. For future quarters: refresh SCHEDULE_LOAD_META with new filenames, change CREATE OR REPLACE to IF NOT EXISTS for incremental loads. Uses dynamic SQL (EXECUTE IMMEDIATE) to handle variable column counts across schedules without manual DDL per schedule.'
EXECUTE AS OWNER
AS '
DECLARE
  c_schedules CURSOR FOR
    SELECT SCHEDULE_NAME, MAX(NUM_COLS) AS MAX_COLS
    FROM FFIEC.RAW.SCHEDULE_LOAD_META
    GROUP BY SCHEDULE_NAME;
  c_files CURSOR FOR
    SELECT SCHEDULE_NAME, FILE_NAME, NUM_COLS, PART_NUM
    FROM FFIEC.RAW.SCHEDULE_LOAD_META
    ORDER BY SCHEDULE_NAME, PART_NUM;
  v_col_ddl VARCHAR;
  v_col_list VARCHAR;
  v_col_select VARCHAR;
  v_sql VARCHAR;
  v_sched VARCHAR;
  v_max_cols NUMBER;
  v_file VARCHAR;
  v_num_cols NUMBER;
  v_part NUMBER;
  v_tables_created NUMBER DEFAULT 0;
  v_files_loaded NUMBER DEFAULT 0;
BEGIN
  OPEN c_schedules;
  FOR rec IN c_schedules DO
    v_sched := rec.SCHEDULE_NAME;
    v_max_cols := rec.MAX_COLS;
    v_col_ddl := '''';
    FOR i IN 0 TO v_max_cols - 1 DO
      v_col_ddl := v_col_ddl || CASE WHEN i > 0 THEN '', '' ELSE '''' END || ''COL'' || i::VARCHAR || '' VARCHAR'';
    END FOR;
    v_sql := ''CREATE OR REPLACE TABLE FFIEC.RAW.CALL_'' || v_sched || ''_LANDING (SCHEDULE_NAME VARCHAR, PERIOD_END DATE, PART_NUM NUMBER, FILE_ROW_NUM NUMBER, '' || v_col_ddl || '')'';
    EXECUTE IMMEDIATE v_sql;
    v_tables_created := v_tables_created + 1;
  END FOR;
  CLOSE c_schedules;

  OPEN c_files;
  FOR rec IN c_files DO
    v_sched := rec.SCHEDULE_NAME;
    v_file := rec.FILE_NAME;
    v_num_cols := rec.NUM_COLS;
    v_part := rec.PART_NUM;
    v_col_list := '''';
    v_col_select := '''';
    FOR i IN 0 TO v_num_cols - 1 DO
      v_col_list := v_col_list || CASE WHEN i > 0 THEN '', '' ELSE '''' END || ''COL'' || i::VARCHAR;
      v_col_select := v_col_select || CASE WHEN i > 0 THEN '', '' ELSE '''' END || ''$'' || (i + 1)::VARCHAR;
    END FOR;
    v_sql := ''COPY INTO FFIEC.RAW.CALL_'' || v_sched || ''_LANDING (SCHEDULE_NAME, PERIOD_END, PART_NUM, FILE_ROW_NUM, '' || v_col_list || '') FROM (SELECT '''''' || v_sched || '''''', ''''2026-03-31''''::DATE, '' || COALESCE(v_part::VARCHAR, ''NULL'') || '', METADATA$FILE_ROW_NUMBER, '' || v_col_select || '' FROM @FFIEC.RAW.STG_CALL_BULK/'' || v_file || '') FILE_FORMAT = (FORMAT_NAME = FFIEC.RAW.FF_TAB_DELIM) ON_ERROR = ''''ABORT_STATEMENT'''''';
    EXECUTE IMMEDIATE v_sql;
    v_files_loaded := v_files_loaded + 1;
  END FOR;
  CLOSE c_files;

  RETURN ''Created '' || v_tables_created::VARCHAR || '' tables, loaded '' || v_files_loaded::VARCHAR || '' files'';
END
';