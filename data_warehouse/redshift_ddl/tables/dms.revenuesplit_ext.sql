CREATE TABLE IF NOT EXISTS dms.revenuesplit_ext
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,applicationcode SMALLINT NOT NULL  
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  
	,"ts" VARCHAR(1300)   ENCODE zstd
	,application VARCHAR(81)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.revenuesplit_ext to group devgroup;
GRANT ALL on dms.revenuesplit_ext to group dw_dev_users;
GRANT ALL on dms.revenuesplit_ext to group dev_redshiftcoredevgroup;
GRANT ALL on dms.revenuesplit_ext to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.revenuesplit_ext to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.revenuesplit_ext to group dev_redshiftcorereadgroup;


