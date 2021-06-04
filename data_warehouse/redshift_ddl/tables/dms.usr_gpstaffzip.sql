CREATE TABLE IF NOT EXISTS dms.usr_gpstaffzip
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,stateid VARCHAR(36) NOT NULL  ENCODE zstd
	,shortzip VARCHAR(9) NOT NULL  ENCODE zstd
	,stafftypeid VARCHAR(36) NOT NULL  ENCODE zstd
	,staffid VARCHAR(36) NOT NULL  ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on dms.usr_gpstaffzip to group devgroup;
GRANT ALL on dms.usr_gpstaffzip to group dw_dev_users;
GRANT ALL on dms.usr_gpstaffzip to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_gpstaffzip to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_gpstaffzip to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_gpstaffzip to group dev_redshiftcorereadgroup;


