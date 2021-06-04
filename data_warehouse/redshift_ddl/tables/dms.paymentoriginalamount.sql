CREATE TABLE IF NOT EXISTS dms.paymentoriginalamount
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,originalamount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,transactionamount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,organizationamount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300) NOT NULL  ENCODE zstd
	,basecurrencyid VARCHAR(36)   ENCODE zstd
	,organizationexchangerateid VARCHAR(36)   ENCODE zstd
	,transactioncurrencyid VARCHAR(36)   ENCODE zstd
	,baseexchangerateid VARCHAR(36)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.paymentoriginalamount to group devgroup;
GRANT ALL on dms.paymentoriginalamount to group dw_dev_users;
GRANT ALL on dms.paymentoriginalamount to group dev_redshiftcoredevgroup;
GRANT ALL on dms.paymentoriginalamount to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.paymentoriginalamount to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.paymentoriginalamount to group dev_redshiftcorereadgroup;


