CREATE TABLE IF NOT EXISTS dms.revenue_ext
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,reference VARCHAR(765) NOT NULL  
	,channelcodeid VARCHAR(36)   ENCODE zstd
	,sourcecode VARCHAR(150) NOT NULL  
	,donotacknowledge BOOLEAN NOT NULL  
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,batchnumber VARCHAR(300)   
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
	,benefitswaived BOOLEAN   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.revenue_ext to group devgroup;
GRANT ALL on dms.revenue_ext to group dw_dev_users;
GRANT ALL on dms.revenue_ext to group dev_redshiftcoredevgroup;
GRANT ALL on dms.revenue_ext to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.revenue_ext to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.revenue_ext to group dev_redshiftcorereadgroup;


