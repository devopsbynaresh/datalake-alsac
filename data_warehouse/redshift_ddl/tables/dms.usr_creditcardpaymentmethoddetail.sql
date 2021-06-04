CREATE TABLE IF NOT EXISTS dms.usr_creditcardpaymentmethoddetail
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,merchantid VARCHAR(300) NOT NULL  ENCODE zstd
	,merchantkey VARCHAR(300)   ENCODE zstd
	,bankapprovalcode VARCHAR(18)   ENCODE zstd
	,depositreferencenumber VARCHAR(120)   ENCODE zstd
	,bankapprovalstatus VARCHAR(6)   ENCODE zstd
	,bankapprovaldate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,refundamount NUMERIC(20,4)   ENCODE zstd
	,requestid VARCHAR(84)   ENCODE zstd
	,reconciliationid VARCHAR(180)   ENCODE zstd
	,requirescharging BOOLEAN   ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,creditcardsubtypecodeid VARCHAR(36)   ENCODE zstd
	,paymentnetworktransactionid VARCHAR(45)   ENCODE zstd
	,"ts" VARCHAR(130)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.usr_creditcardpaymentmethoddetail to group devgroup;
GRANT ALL on dms.usr_creditcardpaymentmethoddetail to group dw_dev_users;
GRANT ALL on dms.usr_creditcardpaymentmethoddetail to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_creditcardpaymentmethoddetail to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_creditcardpaymentmethoddetail to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_creditcardpaymentmethoddetail to group dev_redshiftcorereadgroup;


