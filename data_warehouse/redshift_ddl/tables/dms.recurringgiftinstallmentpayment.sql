CREATE TABLE IF NOT EXISTS dms.recurringgiftinstallmentpayment
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,paymentid VARCHAR(36) NOT NULL  ENCODE zstd
	,recurringgiftinstallmentid VARCHAR(36) NOT NULL  
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (recurringgiftinstallmentid)
SORTKEY (recurringgiftinstallmentid)
;

GRANT ALL on dms.recurringgiftinstallmentpayment to group devgroup;
GRANT ALL on dms.recurringgiftinstallmentpayment to group dw_dev_users;
GRANT ALL on dms.recurringgiftinstallmentpayment to group dev_redshiftcoredevgroup;
GRANT ALL on dms.recurringgiftinstallmentpayment to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.recurringgiftinstallmentpayment to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.recurringgiftinstallmentpayment to group dev_redshiftcorereadgroup;


