CREATE TABLE IF NOT EXISTS mdm.household
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,constituent_id VARCHAR(36) NOT NULL  
	,staff VARCHAR(315)   ENCODE zstd
	,status_id VARCHAR(36)   ENCODE zstd
	,num_members INTEGER   ENCODE zstd
	,uuid VARCHAR(36)   ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,discrepancy_id INTEGER   ENCODE zstd
	,comments VARCHAR(3000)   ENCODE zstd
	,channel_inserted_by VARCHAR(36)   ENCODE zstd
	,channel_updated_by VARCHAR(36)   ENCODE zstd
	,default_currency VARCHAR(12)   ENCODE zstd
	,match_ratio NUMERIC(6,2)   ENCODE zstd
	,min_contribution NUMERIC(8,2)   ENCODE zstd
	,max_contribution NUMERIC(8,2)   ENCODE zstd
	,max_matched NUMERIC(8,2)   ENCODE zstd
	,anonymous_gift_account BOOLEAN   ENCODE zstd
	,is_vsc BOOLEAN   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (constituent_id)
SORTKEY (constituent_id)
;

GRANT ALL on mdm.household to group dw_dev_users;
GRANT ALL on mdm.household to group devgroup;
GRANT ALL on mdm.household to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.household to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.household to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.household to group dev_redshiftcorereadgroup;


