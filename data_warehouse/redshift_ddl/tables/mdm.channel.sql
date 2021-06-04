CREATE TABLE IF NOT EXISTS mdm.channel
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,channel_id VARCHAR(36) NOT NULL  ENCODE zstd
	,channel_type VARCHAR(36) NOT NULL  ENCODE zstd
	,description VARCHAR(135)   ENCODE zstd
	,status_id VARCHAR(36)   ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,updated_by VARCHAR(768)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on mdm.channel to group devgroup;
GRANT ALL on mdm.channel to group dw_dev_users;
GRANT ALL on mdm.channel to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.channel to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.channel to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.channel to group dev_redshiftcorereadgroup;


