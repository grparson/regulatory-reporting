-- Populate UBPR formulas from Formula.xml landing table.
-- Extracts loc/formulaArc/formula triples joined by xlink:label.
-- Run after UBPR_TAXONOMY_FORMULA_LANDING is loaded from @STG_TAXONOMY/ubpr/.

TRUNCATE TABLE IF EXISTS FFIEC.SILVER.UBPR_TAXONOMY_FORMULAS;

INSERT INTO FFIEC.SILVER.UBPR_TAXONOMY_FORMULAS
(CONCEPT_ID, FORMULA_TARGET, FORMULA_ROLE, FORMULA_EXPRESSION)
WITH link_children AS (
    SELECT f.VALUE AS elem
    FROM FFIEC.RAW.UBPR_TAXONOMY_FORMULA_LANDING
        , LATERAL FLATTEN(input => RAW_XML:"$") f
    WHERE f.VALUE:"@"::VARCHAR = 'formulaLink'
),
locs AS (
    SELECT 
        c.VALUE:"@xlink:label"::VARCHAR AS loc_label
        , c.VALUE:"@xlink:href"::VARCHAR AS href
    FROM link_children lc
        , LATERAL FLATTEN(input => lc.elem:"$") c
    WHERE c.VALUE:"@"::VARCHAR = 'loc'
),
formulas AS (
    SELECT 
        c.VALUE:"@xlink:label"::VARCHAR AS formula_label
        , c.VALUE:"@xlink:role"::VARCHAR AS formula_role
        , c.VALUE:"@select"::VARCHAR AS formula_expression
    FROM link_children lc
        , LATERAL FLATTEN(input => lc.elem:"$") c
    WHERE c.VALUE:"@"::VARCHAR = 'formula'
)
SELECT 
    l.loc_label AS CONCEPT_ID
    , REPLACE(l.loc_label, 'uc_', '') AS FORMULA_TARGET
    , REPLACE(f.formula_role, 'https://www.cdr.ffiec.gov/xbrl/role/', '') AS FORMULA_ROLE
    , f.formula_expression AS FORMULA_EXPRESSION
FROM locs l
JOIN formulas f ON f.formula_label = l.loc_label || '_formula';
