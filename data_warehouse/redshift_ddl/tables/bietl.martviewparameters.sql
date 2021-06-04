CREATE TABLE IF NOT EXISTS bietl.martviewparameters
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,martviewparameterid BIGINT NOT NULL DEFAULT "identity"(109864, 2, '1,1'::text) ENCODE az64
	,parametername VARCHAR(300) NOT NULL  ENCODE zstd
	,parametervalue VARCHAR(12000) NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (martviewparameterid)
;

GRANT ALL on bietl.martviewparameters to group devgroup;
GRANT ALL on bietl.martviewparameters to group dw_dev_users;
GRANT ALL on bietl.martviewparameters to group dev_redshiftcoredevgroup;
GRANT ALL on bietl.martviewparameters to group dev_redshiftcoreadmingroup;
GRANT SELECT on bietl.martviewparameters to group dev_redshiftcorereadngroup;
GRANT SELECT on bietl.martviewparameters to group dev_redshiftcorereadgroup;


