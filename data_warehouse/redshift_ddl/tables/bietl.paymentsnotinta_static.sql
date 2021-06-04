CREATE TABLE IF NOT EXISTS bietl.paymentsnotinta_static
(
	dmsid VARCHAR(36)   ENCODE zstd
	,op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on bietl.paymentsnotinta_static to group devgroup;
GRANT ALL on bietl.paymentsnotinta_static to group dw_dev_users;
GRANT ALL on bietl.paymentsnotinta_static to group dev_redshiftcoredevgroup;
GRANT ALL on bietl.paymentsnotinta_static to group dev_redshiftcoreadmingroup;
GRANT SELECT on bietl.paymentsnotinta_static to group dev_redshiftcorereadngroup;
GRANT SELECT on bietl.paymentsnotinta_static to group dev_redshiftcorereadgroup;


