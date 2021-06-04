CREATE TABLE IF NOT EXISTS dms.usr_transactionext
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,gift_type VARCHAR(6) NOT NULL  ENCODE zstd
	,pledge_number BIGINT NOT NULL  ENCODE zstd
	,fund VARCHAR(48) NOT NULL  ENCODE zstd
	,activity VARCHAR(12) NOT NULL  ENCODE zstd
	,campaign VARCHAR(6) NOT NULL  ENCODE zstd
	,initiative VARCHAR(12) NOT NULL  ENCODE zstd
	,effort VARCHAR(6) NOT NULL  ENCODE zstd
	,credit_account VARCHAR(60) NOT NULL  ENCODE zstd
	,group_type VARCHAR(6) NOT NULL  ENCODE zstd
	,batch_seq INTEGER NOT NULL  ENCODE zstd
	,acquired_batch_number VARCHAR(60) NOT NULL  ENCODE zstd
	,acquired_batch_seq VARCHAR(12) NOT NULL  ENCODE zstd
	,debit_account VARCHAR(60) NOT NULL  ENCODE zstd
	,project VARCHAR(36)   ENCODE zstd
	,package VARCHAR(24) NOT NULL  ENCODE zstd
	,gift_seq INTEGER NOT NULL  ENCODE zstd
	,processed_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,ta_date_inserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,ta_date_updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,ta_user_inserting VARCHAR(36) NOT NULL  ENCODE zstd
	,ta_user_updating VARCHAR(36) NOT NULL  ENCODE zstd
	,event VARCHAR(36)   ENCODE zstd
	,interactiontypecodeid VARCHAR(36)   ENCODE zstd
	,ack_code VARCHAR(60) NOT NULL  ENCODE zstd
	,station_support VARCHAR(24) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,fiscal_year INTEGER   ENCODE zstd
	,fiscal_month INTEGER   ENCODE zstd
	,sourcetypecodeid VARCHAR(36)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
	,special_action_comments VARCHAR(768)   ENCODE zstd
	,fairmarketvalue NUMERIC(19,4)   ENCODE zstd
	,alt_transaction_id VARCHAR(180)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.usr_transactionext to group devgroup;
GRANT ALL on dms.usr_transactionext to group dw_dev_users;
GRANT ALL on dms.usr_transactionext to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_transactionext to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_transactionext to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_transactionext to group dev_redshiftcorereadgroup;


