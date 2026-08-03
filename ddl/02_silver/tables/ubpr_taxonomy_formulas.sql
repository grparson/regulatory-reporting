CREATE TABLE IF NOT EXISTS FFIEC.SILVER.UBPR_TAXONOMY_FORMULAS (
    CONCEPT_ID          VARCHAR,
    FORMULA_TARGET      VARCHAR,
    FORMULA_ROLE        VARCHAR,
    FORMULA_EXPRESSION  VARCHAR
)
COMMENT = 'UBPR calculation formulas from ubpr-v183-Formula.xml. DSL expressions show how each ratio/total is computed from source concepts (uc: UBPR items, cc: Call Report items).';
