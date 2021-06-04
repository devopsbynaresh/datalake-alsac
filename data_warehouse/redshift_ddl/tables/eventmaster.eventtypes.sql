CREATE TABLE IF NOT EXISTS eventmaster.eventtypes
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,eventtypeid VARCHAR(36) NOT NULL  ENCODE zstd
	,eventtypename VARCHAR(120) NOT NULL  ENCODE zstd
	,eventprogramid VARCHAR(36) NOT NULL  ENCODE zstd
	,statusid VARCHAR(36) NOT NULL  ENCODE zstd
	,legacyprefix VARCHAR(30)   ENCODE zstd
	,activeprefix VARCHAR(30)   ENCODE zstd
	,eventtypegenerationcodeid VARCHAR(36)   ENCODE zstd
	,eventtypesequence INTEGER   ENCODE zstd
	,iseccrecruited BOOLEAN   ENCODE zstd
	,hassubtypes BOOLEAN   ENCODE zstd
	,programcode VARCHAR(60)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,recruitedevent BOOLEAN   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on eventmaster.eventtypes to group dw_dev_users;
GRANT ALL on eventmaster.eventtypes to group devgroup;
GRANT ALL on eventmaster.eventtypes to group dev_redshiftcoredevgroup;
GRANT ALL on eventmaster.eventtypes to group dev_redshiftcoreadmingroup;
GRANT SELECT on eventmaster.eventtypes to group dev_redshiftcorereadngroup;
GRANT SELECT on eventmaster.eventtypes to group dev_redshiftcorereadgroup;


