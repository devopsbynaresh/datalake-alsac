CREATE TABLE IF NOT EXISTS mdm.address
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,address_id VARCHAR(36) NOT NULL  
	,address_type_lookup_id VARCHAR(36)   ENCODE zstd
	,city VARCHAR(300)   ENCODE zstd
	,state VARCHAR(9)   ENCODE zstd
	,country VARCHAR(12)   ENCODE zstd
	,zip VARCHAR(24)   ENCODE zstd
	,zip_ext VARCHAR(24)   ENCODE zstd
	,preferred_during_dates VARCHAR(150)   ENCODE zstd
	,from_date VARCHAR(30)   ENCODE zstd
	,through_date VARCHAR(30)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,created_by VARCHAR(768)   ENCODE zstd
	,status_id VARCHAR(36)   ENCODE zstd
	,last_ncoa TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,delivery_score SMALLINT   ENCODE zstd
	,comments VARCHAR(3000)   ENCODE zstd
	,channel_inserted_by VARCHAR(36)   ENCODE zstd
	,channel_updated_by VARCHAR(36)   ENCODE zstd
	,congressional_district VARCHAR(600)   ENCODE zstd
	,undeliverable_count INTEGER   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (address_id)
SORTKEY (address_id)
;

GRANT ALL on mdm.address to group devgroup;
GRANT ALL on mdm.address to group dw_dev_users;
GRANT ALL on mdm.address to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.address to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.address to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.address to group dev_redshiftcorereadgroup;


