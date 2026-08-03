-- Populate UBPR labels from Label.xml landing table.
-- Extracts loc/labelArc/label triples joined by xlink:label.
-- Run after UBPR_TAXONOMY_LABEL_LANDING is loaded from @STG_TAXONOMY/ubpr/.

TRUNCATE TABLE IF EXISTS FFIEC.SILVER.UBPR_TAXONOMY_LABELS;

INSERT INTO FFIEC.SILVER.UBPR_TAXONOMY_LABELS
(CONCEPT_ID, CONCEPT_REF, LABEL_ROLE, LABEL_TEXT)
WITH link_children AS (
    SELECT f.VALUE AS elem
    FROM FFIEC.RAW.UBPR_TAXONOMY_LABEL_LANDING
        , LATERAL FLATTEN(input => RAW_XML:"$") f
    WHERE f.VALUE:"@"::VARCHAR = 'labelLink'
),
labels AS (
    SELECT 
        c.VALUE:"@xlink:label"::VARCHAR AS label_id
        , c.VALUE:"@xlink:role"::VARCHAR AS label_role
        , c.VALUE:"$"::VARCHAR AS label_text
    FROM link_children lc
        , LATERAL FLATTEN(input => lc.elem:"$") c
    WHERE c.VALUE:"@"::VARCHAR = 'label'
),
locs AS (
    SELECT 
        c.VALUE:"@xlink:label"::VARCHAR AS loc_label
        , c.VALUE:"@xlink:href"::VARCHAR AS href
    FROM link_children lc
        , LATERAL FLATTEN(input => lc.elem:"$") c
    WHERE c.VALUE:"@"::VARCHAR = 'loc'
),
arcs AS (
    SELECT 
        c.VALUE:"@xlink:from"::VARCHAR AS arc_from
        , c.VALUE:"@xlink:to"::VARCHAR AS arc_to
    FROM link_children lc
        , LATERAL FLATTEN(input => lc.elem:"$") c
    WHERE c.VALUE:"@"::VARCHAR = 'labelArc'
)
SELECT 
    l.loc_label AS CONCEPT_ID
    , SPLIT_PART(l.href, '#', 2) AS CONCEPT_REF
    , REPLACE(lab.label_role, 'https://www.cdr.ffiec.gov/xbrl/report/', '') AS LABEL_ROLE
    , lab.label_text AS LABEL_TEXT
FROM locs l
JOIN arcs a ON a.arc_from = l.loc_label
JOIN labels lab ON lab.label_id = a.arc_to;
