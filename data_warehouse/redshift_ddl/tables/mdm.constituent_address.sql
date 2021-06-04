CREATE TABLE IF NOT EXISTS mdm.constituent_address
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,constituent_id VARCHAR(36) NOT NULL  
	,address_id VARCHAR(36) NOT NULL  ENCODE zstd
	,preferred SMALLINT NOT NULL  ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,channel_inserted_by VARCHAR(36)   ENCODE zstd
	,channel_updated_by VARCHAR(36)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (constituent_id)
SORTKEY (constituent_id)
;

GRANT ALL on mdm.constituent_address to group devgroup;
GRANT ALL on mdm.constituent_address to group dw_dev_users;
GRANT ALL on mdm.constituent_address to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.constituent_address to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.constituent_address to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.constituent_address to group dev_redshiftcorereadgroup;


