CREATE TABLE IF NOT EXISTS dms.usr_directdebitpaymentmethoddetail
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,requestid VARCHAR(84)   ENCODE lzo
	,reconciliationid VARCHAR(180)   ENCODE zstd
	,bankapprovalstatus VARCHAR(6)   ENCODE zstd
	,bankmerchantnote VARCHAR(6)   ENCODE zstd
	,prenotedate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,eftstatus VARCHAR(30)   ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.usr_directdebitpaymentmethoddetail to group dw_dev_users;
GRANT ALL on dms.usr_directdebitpaymentmethoddetail to group devgroup;
GRANT ALL on dms.usr_directdebitpaymentmethoddetail to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_directdebitpaymentmethoddetail to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_directdebitpaymentmethoddetail to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_directdebitpaymentmethoddetail to group dev_redshiftcorereadgroup;


