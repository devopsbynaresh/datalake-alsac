CREATE TABLE IF NOT EXISTS attribution.fund
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,fund VARCHAR(48) NOT NULL  ENCODE lzo
	,description VARCHAR(120)   ENCODE zstd
	,fund_group VARCHAR(24)   ENCODE zstd
	,fund_type VARCHAR(3)   ENCODE zstd
	,gl_account VARCHAR(60)   ENCODE zstd
	,gl_offset_account VARCHAR(60)   ENCODE zstd
	,gl_min_pledge_amt NUMERIC(11,2)   ENCODE zstd
	,sts VARCHAR(6)   ENCODE zstd
	,fund_description VARCHAR(240)   ENCODE zstd
	,date_inserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_inserting VARCHAR(600)   ENCODE zstd
	,date_updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_updating VARCHAR(600)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (fund)
;

GRANT ALL on attribution.fund to group dw_dev_users;
GRANT ALL on attribution.fund to group devgroup;
GRANT ALL on attribution.fund to group dev_redshiftcoredevgroup;
GRANT ALL on attribution.fund to group dev_redshiftcoreadmingroup;
GRANT SELECT on attribution.fund to group dev_redshiftcorereadngroup;
GRANT SELECT on attribution.fund to group dev_redshiftcorereadgroup;


