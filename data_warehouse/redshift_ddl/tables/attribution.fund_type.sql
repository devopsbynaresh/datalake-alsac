CREATE TABLE IF NOT EXISTS attribution.fund_type
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,fund_type VARCHAR(3) NOT NULL  ENCODE lzo
	,description VARCHAR(120)   ENCODE zstd
	,sts VARCHAR(6)   ENCODE zstd
	,date_inserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_inserting VARCHAR(600)   ENCODE zstd
	,date_updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_updating VARCHAR(600)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (fund_type)
;

GRANT ALL on attribution.fund_type to group dw_dev_users;
GRANT ALL on attribution.fund_type to group devgroup;
GRANT ALL on attribution.fund_type to group dev_redshiftcoredevgroup;
GRANT ALL on attribution.fund_type to group dev_redshiftcoreadmingroup;
GRANT SELECT on attribution.fund_type to group dev_redshiftcorereadngroup;
GRANT SELECT on attribution.fund_type to group dev_redshiftcorereadgroup;


