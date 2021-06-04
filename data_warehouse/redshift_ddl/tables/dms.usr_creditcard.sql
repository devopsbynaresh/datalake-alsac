CREATE TABLE IF NOT EXISTS dms.usr_creditcard
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,merchant_id VARCHAR(300)   
	,merchant_key VARCHAR(300)   
	,merchant_name VARCHAR(300)   
	,merchantreferencecode VARCHAR(600)   
	,requestid VARCHAR(84)   
	,reconciliationid VARCHAR(180)   
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,creditcardsubtypecodeid VARCHAR(36)   ENCODE zstd
	,paymentnetworktransactionid VARCHAR(45)   ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.usr_creditcard to group devgroup;
GRANT ALL on dms.usr_creditcard to group dw_dev_users;
GRANT ALL on dms.usr_creditcard to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_creditcard to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_creditcard to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_creditcard to group dev_redshiftcorereadgroup;


