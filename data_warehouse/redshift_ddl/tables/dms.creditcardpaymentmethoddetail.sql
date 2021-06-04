CREATE TABLE IF NOT EXISTS dms.creditcardpaymentmethoddetail
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,credittypecodeid VARCHAR(36)   ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(130)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.creditcardpaymentmethoddetail to group devgroup;
GRANT ALL on dms.creditcardpaymentmethoddetail to group dw_dev_users;
GRANT ALL on dms.creditcardpaymentmethoddetail to group dev_redshiftcoredevgroup;
GRANT ALL on dms.creditcardpaymentmethoddetail to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.creditcardpaymentmethoddetail to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.creditcardpaymentmethoddetail to group dev_redshiftcorereadgroup;


