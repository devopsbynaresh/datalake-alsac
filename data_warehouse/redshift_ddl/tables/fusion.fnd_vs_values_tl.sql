CREATE TABLE IF NOT EXISTS fusion.fnd_vs_values_tl
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,value_id BIGINT NOT NULL  ENCODE az64
	,enterprise_id BIGINT   ENCODE zstd
	,sandbox_id BIGINT   ENCODE zstd
	,"language" VARCHAR(150)   ENCODE zstd
	,source_lang VARCHAR(150)   ENCODE zstd
	,translated_value VARCHAR(1500)   ENCODE zstd
	,description VARCHAR(3000)   ENCODE zstd
	,creation_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,created_by VARCHAR(300)   ENCODE zstd
	,last_update_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,last_updated_by VARCHAR(300)   ENCODE zstd
	,last_update_login VARCHAR(300)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (value_id)
;

GRANT ALL on fusion.fnd_vs_values_tl to group dw_dev_users;
GRANT ALL on fusion.fnd_vs_values_tl to group devgroup;
GRANT ALL on fusion.fnd_vs_values_tl to group dev_redshiftcoredevgroup;
GRANT ALL on fusion.fnd_vs_values_tl to group dev_redshiftcoreadmingroup;
GRANT SELECT on fusion.fnd_vs_values_tl to group dev_redshiftcorereadngroup;
GRANT SELECT on fusion.fnd_vs_values_tl to group dev_redshiftcorereadgroup;


