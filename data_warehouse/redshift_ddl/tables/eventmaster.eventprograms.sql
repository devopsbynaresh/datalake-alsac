CREATE TABLE IF NOT EXISTS eventmaster.eventprograms
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,eventprogramid VARCHAR(36) NOT NULL  ENCODE zstd
	,eventprogram VARCHAR(120) NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on eventmaster.eventprograms to group devgroup;
GRANT ALL on eventmaster.eventprograms to group dw_dev_users;
GRANT ALL on eventmaster.eventprograms to group dev_redshiftcoredevgroup;
GRANT ALL on eventmaster.eventprograms to group dev_redshiftcoreadmingroup;
GRANT SELECT on eventmaster.eventprograms to group dev_redshiftcorereadngroup;
GRANT SELECT on eventmaster.eventprograms to group dev_redshiftcorereadgroup;


