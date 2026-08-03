CREATE STAGE IF NOT EXISTS FFIEC.RAW.STG_UBPR_BULK
  COMMENT = 'UBPR bulk XBRL instance documents - one file per bank per quarter, parsed natively via PARSE_XML';
