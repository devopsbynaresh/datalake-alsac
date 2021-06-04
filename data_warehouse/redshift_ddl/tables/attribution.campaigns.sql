CREATE TABLE IF NOT EXISTS attribution.campaigns
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,activity VARCHAR(12) NOT NULL  ENCODE lzo
	,campaign VARCHAR(6) NOT NULL  ENCODE zstd
	,description VARCHAR(120)   ENCODE zstd
	,fund_type VARCHAR(3)   ENCODE zstd
	,activity_type VARCHAR(9)   ENCODE zstd
	,group_type VARCHAR(3)   ENCODE zstd
	,station_support VARCHAR(24)   ENCODE zstd
	,fund VARCHAR(48)   ENCODE zstd
	,debit_account VARCHAR(60)   ENCODE zstd
	,credit_account VARCHAR(60)   ENCODE zstd
	,office VARCHAR(6)   ENCODE zstd
	,staff VARCHAR(36)   ENCODE zstd
	,solicitor VARCHAR(36)   ENCODE zstd
	,technique VARCHAR(6)   ENCODE zstd
	,package VARCHAR(24)   ENCODE zstd
	,project VARCHAR(60)   ENCODE zstd
	,purpose VARCHAR(24)   ENCODE zstd
	,number_of_codes INTEGER   ENCODE zstd
	,code_format VARCHAR(6)   ENCODE zstd
	,subtotal VARCHAR(3)   ENCODE zstd
	,first_initiative VARCHAR(12)   ENCODE zstd
	,last_initiative VARCHAR(12)   ENCODE zstd
	,gift_type VARCHAR(6)   ENCODE zstd
	,sts VARCHAR(6)   ENCODE zstd
	,source_analysis_rule VARCHAR(120)   ENCODE zstd
	,date_inserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_inserting VARCHAR(600)   ENCODE zstd
	,date_updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_updating VARCHAR(600)   ENCODE zstd
	,gift_type_evaluation VARCHAR(6)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (activity)
;

GRANT ALL on attribution.campaigns to group dw_dev_users;
GRANT ALL on attribution.campaigns to group devgroup;
GRANT ALL on attribution.campaigns to group dev_redshiftcoredevgroup;
GRANT ALL on attribution.campaigns to group dev_redshiftcoreadmingroup;
GRANT SELECT on attribution.campaigns to group dev_redshiftcorereadngroup;
GRANT SELECT on attribution.campaigns to group dev_redshiftcorereadgroup;


