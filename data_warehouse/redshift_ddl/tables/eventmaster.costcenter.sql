CREATE TABLE IF NOT EXISTS eventmaster.costcenter
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,costcenterid VARCHAR(36) NOT NULL  ENCODE zstd
	,costcenter VARCHAR(24)   ENCODE zstd
	,costcenterdescription VARCHAR(120)   ENCODE zstd
	,costcenterstatus VARCHAR(6)   ENCODE zstd
	,regionid VARCHAR(36)   ENCODE zstd
	,ismainoffice BOOLEAN   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on eventmaster.costcenter to group devgroup;
GRANT ALL on eventmaster.costcenter to group dw_dev_users;
GRANT ALL on eventmaster.costcenter to group dev_redshiftcoredevgroup;
GRANT ALL on eventmaster.costcenter to group dev_redshiftcoreadmingroup;
GRANT SELECT on eventmaster.costcenter to group dev_redshiftcorereadngroup;
GRANT SELECT on eventmaster.costcenter to group dev_redshiftcorereadgroup;


