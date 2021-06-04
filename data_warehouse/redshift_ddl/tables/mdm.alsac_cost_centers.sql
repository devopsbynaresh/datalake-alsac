CREATE TABLE IF NOT EXISTS mdm.alsac_cost_centers
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,cost_center VARCHAR(24) NOT NULL  ENCODE lzo
	,description VARCHAR(120)   ENCODE zstd
	,"region" VARCHAR(3)   ENCODE zstd
	,region_code VARCHAR(60)   ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,market_identifier VARCHAR(15)   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on mdm.alsac_cost_centers to group devgroup;
GRANT ALL on mdm.alsac_cost_centers to group dw_dev_users;
GRANT ALL on mdm.alsac_cost_centers to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.alsac_cost_centers to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.alsac_cost_centers to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.alsac_cost_centers to group dev_redshiftcorereadgroup;


