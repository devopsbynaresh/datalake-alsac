CREATE TABLE IF NOT EXISTS bietl.cleanup_financialtransaction
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36)   ENCODE zstd
	,excludereason VARCHAR(600)   ENCODE zstd
	,exclude BOOLEAN   ENCODE zstd
	,updatedate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on bietl.cleanup_financialtransaction to group devgroup;
GRANT ALL on bietl.cleanup_financialtransaction to group dw_dev_users;
GRANT ALL on bietl.cleanup_financialtransaction to group dev_redshiftcoredevgroup;
GRANT ALL on bietl.cleanup_financialtransaction to group dev_redshiftcoreadmingroup;
GRANT SELECT on bietl.cleanup_financialtransaction to group dev_redshiftcorereadngroup;
GRANT SELECT on bietl.cleanup_financialtransaction to group dev_redshiftcorereadgroup;


