-- Star schema dimension: one row per distinct filing period
-- Co-authored with CoCo

CREATE OR REPLACE TABLE FFIEC.GOLD.DIM_PERIOD (
  PERIOD_KEY DATE NOT NULL,
  PERIOD_END DATE,
  FISCAL_YEAR NUMBER(38,0),
  QUARTER_NUM NUMBER(38,0),
  IS_YEAR_END BOOLEAN,
  PRIMARY KEY (PERIOD_KEY)
)
COMMENT = 'One row per distinct filing period observed in the fact tables. Currently a single quarter (2026-03-31); will grow as more history is loaded.';
