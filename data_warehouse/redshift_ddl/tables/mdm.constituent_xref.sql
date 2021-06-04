CREATE TABLE IF NOT EXISTS mdm.constituent_xref
(
	"timestamp" VARCHAR(36)   ENCODE zstd
	,constituent_id VARCHAR(36) NOT NULL  
	,system_id VARCHAR(36) NOT NULL  ENCODE zstd
	,constituent_type_lookup_id VARCHAR(36) NOT NULL  ENCODE zstd
	,xref_key VARCHAR(900) NOT NULL  ENCODE zstd
	,uuid VARCHAR(36)   ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,key_1 VARCHAR(150)   ENCODE lzo
	,channel_inserted_by VARCHAR(36)   ENCODE zstd
	,channel_updated_by VARCHAR(36)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (constituent_id)
SORTKEY (constituent_id)
;

GRANT ALL on mdm.constituent_xref to group dw_dev_users;
GRANT ALL on mdm.constituent_xref to group devgroup;
GRANT ALL on mdm.constituent_xref to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.constituent_xref to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.constituent_xref to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.constituent_xref to group dev_redshiftcorereadgroup;


