CREATE TABLE IF NOT EXISTS mdm.alsac_market_regions
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,zip VARCHAR(24) NOT NULL  ENCODE lzo
	,state VARCHAR(6) NOT NULL  ENCODE zstd
	,country VARCHAR(9) NOT NULL  ENCODE zstd
	,cost_center VARCHAR(24) NOT NULL  ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on mdm.alsac_market_regions to group devgroup;
GRANT ALL on mdm.alsac_market_regions to group dw_dev_users;
GRANT ALL on mdm.alsac_market_regions to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.alsac_market_regions to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.alsac_market_regions to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.alsac_market_regions to group dev_redshiftcorereadgroup;


