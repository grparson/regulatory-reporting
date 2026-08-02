-- Internal stage for XBRL taxonomy linkbase files (concepts.xsd, ref.xml, pres.xml, cap.xml)
-- Co-authored with CoCo

CREATE OR REPLACE STAGE FFIEC.RAW.STG_TAXONOMY
  COMMENT = 'Internal stage for XBRL taxonomy linkbase files (concepts.xsd, ref.xml, pres.xml, cap.xml) - form-level artifacts, one set per Call Report form/version, reused across all schedules.';
