CREATE TABLE IF NOT EXISTS dms.usr_revenuetribute
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,revenueid VARCHAR(36)   
	,tmsid VARCHAR(36)   ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  
	,"ts" VARCHAR(1300)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (revenueid)
SORTKEY (revenueid)
;

GRANT ALL on dms.usr_revenuetribute to group devgroup;
GRANT ALL on dms.usr_revenuetribute to group dw_dev_users;
GRANT ALL on dms.usr_revenuetribute to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_revenuetribute to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_revenuetribute to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_revenuetribute to group dev_redshiftcorereadgroup;


