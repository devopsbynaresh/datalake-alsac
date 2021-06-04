CREATE TABLE IF NOT EXISTS dms.usr_gpstafftype
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,stafftype VARCHAR(6) NOT NULL  ENCODE zstd
	,description VARCHAR(150) NOT NULL  ENCODE zstd
	,active BOOLEAN NOT NULL  ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on dms.usr_gpstafftype to group devgroup;
GRANT ALL on dms.usr_gpstafftype to group dw_dev_users;
GRANT ALL on dms.usr_gpstafftype to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_gpstafftype to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_gpstafftype to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_gpstafftype to group dev_redshiftcorereadgroup;


