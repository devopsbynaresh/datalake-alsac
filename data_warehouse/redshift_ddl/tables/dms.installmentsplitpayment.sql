CREATE TABLE IF NOT EXISTS dms.installmentsplitpayment
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,pledgeid VARCHAR(36) NOT NULL  ENCODE zstd
	,paymentid VARCHAR(36) NOT NULL  ENCODE zstd
	,installmentsplitid VARCHAR(36) NOT NULL  
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (installmentsplitid)
SORTKEY (installmentsplitid)
;

GRANT ALL on dms.installmentsplitpayment to group devgroup;
GRANT ALL on dms.installmentsplitpayment to group dw_dev_users;
GRANT ALL on dms.installmentsplitpayment to group dev_redshiftcoredevgroup;
GRANT ALL on dms.installmentsplitpayment to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.installmentsplitpayment to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.installmentsplitpayment to group dev_redshiftcorereadgroup;


