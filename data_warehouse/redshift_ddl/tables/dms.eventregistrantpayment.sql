CREATE TABLE IF NOT EXISTS dms.eventregistrantpayment
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,paymentid VARCHAR(36) NOT NULL  ENCODE zstd
	,registrantid VARCHAR(36) NOT NULL  
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300) NOT NULL  ENCODE zstd
	,amount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,applicationcurrencyid VARCHAR(36)   ENCODE zstd
	,applicationexchangerateid VARCHAR(36)   ENCODE zstd
	,receiptamount NUMERIC(19,4)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (registrantid)
SORTKEY (registrantid)
;

GRANT ALL on dms.eventregistrantpayment to group devgroup;
GRANT ALL on dms.eventregistrantpayment to group dw_dev_users;
GRANT ALL on dms.eventregistrantpayment to group dev_redshiftcoredevgroup;
GRANT ALL on dms.eventregistrantpayment to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.eventregistrantpayment to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.eventregistrantpayment to group dev_redshiftcorereadgroup;


