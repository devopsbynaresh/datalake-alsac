CREATE TABLE IF NOT EXISTS mdm.salutation
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,salutation_id VARCHAR(36) NOT NULL  ENCODE zstd
	,description VARCHAR(135)   ENCODE zstd
	,status_id VARCHAR(36)   ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on mdm.salutation to group dw_dev_users;
GRANT ALL on mdm.salutation to group devgroup;
GRANT ALL on mdm.salutation to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.salutation to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.salutation to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.salutation to group dev_redshiftcorereadgroup;


