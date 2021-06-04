CREATE TABLE IF NOT EXISTS mdm.constituent_type
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,constituent_type_lookup_id VARCHAR(36) NOT NULL  ENCODE zstd
	,description VARCHAR(135)   ENCODE zstd
	,status_id VARCHAR(36)   ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on mdm.constituent_type to group dw_dev_users;
GRANT ALL on mdm.constituent_type to group devgroup;
GRANT ALL on mdm.constituent_type to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.constituent_type to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.constituent_type to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.constituent_type to group dev_redshiftcorereadgroup;


