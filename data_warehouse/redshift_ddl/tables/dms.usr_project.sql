CREATE TABLE IF NOT EXISTS dms.usr_project
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,project VARCHAR(60) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  
	,"ts" VARCHAR(1300)   ENCODE zstd
	,description VARCHAR(300)   ENCODE zstd
	,active BOOLEAN   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
SORTKEY (birowversion)
;

GRANT ALL on dms.usr_project to group devgroup;
GRANT ALL on dms.usr_project to group dw_dev_users;
GRANT ALL on dms.usr_project to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_project to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_project to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_project to group dev_redshiftcorereadgroup;


