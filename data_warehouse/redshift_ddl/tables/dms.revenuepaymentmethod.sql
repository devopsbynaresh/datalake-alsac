CREATE TABLE IF NOT EXISTS dms.revenuepaymentmethod
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,revenueid VARCHAR(36) NOT NULL  ENCODE lzo
	,paymentmethodcode SMALLINT NOT NULL  ENCODE az64
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,paymentmethod VARCHAR(42)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.revenuepaymentmethod to group devgroup;
GRANT ALL on dms.revenuepaymentmethod to group dw_dev_users;
GRANT ALL on dms.revenuepaymentmethod to group dev_redshiftcoredevgroup;
GRANT ALL on dms.revenuepaymentmethod to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.revenuepaymentmethod to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.revenuepaymentmethod to group dev_redshiftcorereadgroup;


