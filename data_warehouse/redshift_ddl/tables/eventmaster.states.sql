CREATE TABLE IF NOT EXISTS eventmaster.states
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,stateid VARCHAR(36) NOT NULL  ENCODE zstd
	,statecode VARCHAR(6)   ENCODE zstd
	,statedescription VARCHAR(120)   ENCODE zstd
	,statestatus VARCHAR(6)   ENCODE zstd
	,countryid VARCHAR(36)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on eventmaster.states to group dw_dev_users;
GRANT ALL on eventmaster.states to group devgroup;
GRANT ALL on eventmaster.states to group dev_redshiftcoredevgroup;
GRANT ALL on eventmaster.states to group dev_redshiftcoreadmingroup;
GRANT SELECT on eventmaster.states to group dev_redshiftcorereadngroup;
GRANT SELECT on eventmaster.states to group dev_redshiftcorereadgroup;


