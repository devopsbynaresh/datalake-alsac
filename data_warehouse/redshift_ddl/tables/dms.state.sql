CREATE TABLE IF NOT EXISTS dms.state
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,countryid VARCHAR(36) NOT NULL  ENCODE zstd
	,description VARCHAR(300) NOT NULL  ENCODE zstd
	,abbreviation VARCHAR(15) NOT NULL  ENCODE zstd
	,active BOOLEAN NOT NULL  ENCODE zstd
	,"sequence" INTEGER NOT NULL  ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on dms.state to group devgroup;
GRANT ALL on dms.state to group dw_dev_users;
GRANT ALL on dms.state to group dev_redshiftcoredevgroup;
GRANT ALL on dms.state to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.state to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.state to group dev_redshiftcorereadgroup;


