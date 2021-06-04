CREATE TABLE IF NOT EXISTS eventmaster."region"
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,regionid VARCHAR(36) NOT NULL  ENCODE zstd
	,"region" VARCHAR(3)   ENCODE zstd
	,regioncode VARCHAR(60)   ENCODE zstd
	,regiondescription VARCHAR(120)   ENCODE zstd
	,regionstatus VARCHAR(3)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on eventmaster."region" to group dw_dev_users;
GRANT ALL on eventmaster."region" to group devgroup;
GRANT ALL on eventmaster."region" to group dev_redshiftcoredevgroup;
GRANT ALL on eventmaster."region" to group dev_redshiftcoreadmingroup;
GRANT SELECT on eventmaster."region" to group dev_redshiftcorereadngroup;
GRANT SELECT on eventmaster."region" to group dev_redshiftcorereadgroup;


