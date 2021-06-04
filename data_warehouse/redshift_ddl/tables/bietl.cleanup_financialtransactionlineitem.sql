CREATE TABLE IF NOT EXISTS bietl.cleanup_financialtransactionlineitem
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36)   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on bietl.cleanup_financialtransactionlineitem to group devgroup;
GRANT ALL on bietl.cleanup_financialtransactionlineitem to group dw_dev_users;
GRANT ALL on bietl.cleanup_financialtransactionlineitem to group dev_redshiftcoredevgroup;
GRANT ALL on bietl.cleanup_financialtransactionlineitem to group dev_redshiftcoreadmingroup;
GRANT SELECT on bietl.cleanup_financialtransactionlineitem to group dev_redshiftcorereadngroup;
GRANT SELECT on bietl.cleanup_financialtransactionlineitem to group dev_redshiftcorereadgroup;


