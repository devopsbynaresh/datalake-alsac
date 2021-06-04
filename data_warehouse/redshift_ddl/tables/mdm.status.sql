CREATE TABLE IF NOT EXISTS mdm.status
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,status_id VARCHAR(36) NOT NULL  ENCODE zstd
	,description VARCHAR(900) NOT NULL  ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE ALL
;

GRANT ALL on mdm.status to group dw_dev_users;
GRANT ALL on mdm.status to group devgroup;
GRANT ALL on mdm.status to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.status to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.status to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.status to group dev_redshiftcorereadgroup;


