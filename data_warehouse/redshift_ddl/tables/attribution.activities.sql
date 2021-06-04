CREATE TABLE IF NOT EXISTS attribution.activities
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,activity VARCHAR(12) NOT NULL  ENCODE lzo
	,description VARCHAR(120)   ENCODE zstd
	,fund_type VARCHAR(3)   ENCODE zstd
	,activity_type VARCHAR(9)   ENCODE zstd
	,group_type VARCHAR(3)   ENCODE zstd
	,debit_account VARCHAR(60)   ENCODE zstd
	,credit_account VARCHAR(60)   ENCODE zstd
	,staff VARCHAR(36)   ENCODE zstd
	,office VARCHAR(6)   ENCODE zstd
	,station_support VARCHAR(24)   ENCODE zstd
	,basic_amount NUMERIC(11,2)   ENCODE zstd
	,upgrade_field_name VARCHAR(90)   ENCODE zstd
	,upgrade_field_name_desc VARCHAR(180)   ENCODE zstd
	,renewal_window_start INTEGER   ENCODE zstd
	,renewal_window_end INTEGER   ENCODE zstd
	,current_start_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,gift_type_rules VARCHAR(24)   ENCODE zstd
	,renewal_amount_gift_types VARCHAR(240)   ENCODE zstd
	,period_amount_gift_types VARCHAR(240)   ENCODE zstd
	,giving_level_gift_types VARCHAR(240)   ENCODE zstd
	,renewal_gift_types VARCHAR(240)   ENCODE zstd
	,upgrade_gift_types VARCHAR(240)   ENCODE zstd
	,upgrade_amount_gift_types VARCHAR(240)   ENCODE zstd
	,sts VARCHAR(6)   ENCODE zstd
	,date_inserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_inserting VARCHAR(600)   ENCODE zstd
	,date_updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_updating VARCHAR(600)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (activity)
;

GRANT ALL on attribution.activities to group dw_dev_users;
GRANT ALL on attribution.activities to group devgroup;
GRANT ALL on attribution.activities to group dev_redshiftcoredevgroup;
GRANT ALL on attribution.activities to group dev_redshiftcoreadmingroup;
GRANT SELECT on attribution.activities to group dev_redshiftcorereadngroup;
GRANT SELECT on attribution.activities to group dev_redshiftcorereadgroup;


