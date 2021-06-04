CREATE TABLE IF NOT EXISTS eventmaster.statuses
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,statusid VARCHAR(36) NOT NULL  
	,status VARCHAR(300)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (statusid)
SORTKEY (statusid)
;

GRANT ALL on eventmaster.statuses to group dw_dev_users;
GRANT ALL on eventmaster.statuses to group devgroup;
GRANT ALL on eventmaster.statuses to group dev_redshiftcoredevgroup;
GRANT ALL on eventmaster.statuses to group dev_redshiftcoreadmingroup;
GRANT SELECT on eventmaster.statuses to group dev_redshiftcorereadngroup;
GRANT SELECT on eventmaster.statuses to group dev_redshiftcorereadgroup;


