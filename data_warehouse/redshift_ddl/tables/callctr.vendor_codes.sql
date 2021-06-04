CREATE TABLE IF NOT EXISTS callctr.vendor_codes
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,vendor_code VARCHAR(30) NOT NULL  ENCODE lzo
	,vendor_description VARCHAR(150) NOT NULL  ENCODE zstd
	,sts VARCHAR(3) NOT NULL  ENCODE zstd
	,date_inserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_inserting VARCHAR(36)   ENCODE zstd
	,date_updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_updating VARCHAR(36)   ENCODE zstd
	,vendor_type VARCHAR(60) NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (vendor_code)
;

GRANT ALL on callctr.vendor_codes to group devgroup;
GRANT ALL on callctr.vendor_codes to group dw_dev_users;
GRANT ALL on callctr.vendor_codes to group dev_redshiftcoredevgroup;
GRANT ALL on callctr.vendor_codes to group dev_redshiftcoreadmingroup;
GRANT SELECT on callctr.vendor_codes to group dev_redshiftcorereadngroup;
GRANT SELECT on callctr.vendor_codes to group dev_redshiftcorereadgroup;


