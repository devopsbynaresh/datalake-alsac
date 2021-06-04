CREATE TABLE IF NOT EXISTS fusion.fnd_vs_values_b
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,enterprise_id BIGINT NOT NULL  ENCODE zstd
	,value_id BIGINT NOT NULL  ENCODE az64
	,value_set_id BIGINT NOT NULL  ENCODE zstd
	,value VARCHAR(450) NOT NULL  ENCODE zstd
	,value_number DOUBLE PRECISION   ENCODE zstd
	,value_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,value_timestamp TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,independent_value VARCHAR(450)   ENCODE zstd
	,independent_value_number DOUBLE PRECISION   ENCODE zstd
	,independent_value_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,independent_value_timestamp TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,enabled_flag VARCHAR(3) NOT NULL  ENCODE zstd
	,start_date_active TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,end_date_active TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,sort_order BIGINT   ENCODE zstd
	,attribute_category VARCHAR(180)   ENCODE zstd
	,attribute1 VARCHAR(720)   ENCODE zstd
	,attribute2 VARCHAR(720)   ENCODE zstd
	,attribute3 VARCHAR(720)   ENCODE zstd
	,attribute4 VARCHAR(720)   ENCODE zstd
	,attribute5 VARCHAR(720)   ENCODE zstd
	,attribute6 VARCHAR(720)   ENCODE zstd
	,attribute7 VARCHAR(720)   ENCODE zstd
	,attribute8 VARCHAR(720)   ENCODE zstd
	,attribute9 VARCHAR(720)   ENCODE zstd
	,attribute10 VARCHAR(720)   ENCODE zstd
	,attribute11 VARCHAR(720)   ENCODE zstd
	,attribute12 VARCHAR(720)   ENCODE zstd
	,attribute13 VARCHAR(720)   ENCODE zstd
	,attribute14 VARCHAR(720)   ENCODE zstd
	,attribute15 VARCHAR(720)   ENCODE zstd
	,attribute16 VARCHAR(720)   ENCODE zstd
	,attribute17 VARCHAR(720)   ENCODE zstd
	,attribute18 VARCHAR(720)   ENCODE zstd
	,attribute19 VARCHAR(720)   ENCODE zstd
	,attribute20 VARCHAR(720)   ENCODE zstd
	,attribute21 VARCHAR(720)   ENCODE zstd
	,attribute22 VARCHAR(720)   ENCODE zstd
	,attribute23 VARCHAR(720)   ENCODE zstd
	,attribute24 VARCHAR(720)   ENCODE zstd
	,attribute25 VARCHAR(720)   ENCODE zstd
	,attribute26 VARCHAR(720)   ENCODE zstd
	,attribute27 VARCHAR(720)   ENCODE zstd
	,attribute28 VARCHAR(720)   ENCODE zstd
	,attribute29 VARCHAR(720)   ENCODE zstd
	,attribute30 VARCHAR(720)   ENCODE zstd
	,attribute31 VARCHAR(720)   ENCODE zstd
	,attribute32 VARCHAR(720)   ENCODE zstd
	,attribute33 VARCHAR(720)   ENCODE zstd
	,attribute34 VARCHAR(720)   ENCODE zstd
	,attribute35 VARCHAR(720)   ENCODE zstd
	,attribute36 VARCHAR(720)   ENCODE zstd
	,attribute37 VARCHAR(720)   ENCODE zstd
	,attribute38 VARCHAR(720)   ENCODE zstd
	,attribute39 VARCHAR(720)   ENCODE zstd
	,attribute40 VARCHAR(720)   ENCODE zstd
	,attribute41 VARCHAR(720)   ENCODE zstd
	,attribute42 VARCHAR(720)   ENCODE zstd
	,attribute43 VARCHAR(720)   ENCODE zstd
	,attribute44 VARCHAR(720)   ENCODE zstd
	,attribute45 VARCHAR(720)   ENCODE zstd
	,attribute46 VARCHAR(720)   ENCODE zstd
	,attribute47 VARCHAR(720)   ENCODE zstd
	,attribute48 VARCHAR(720)   ENCODE zstd
	,attribute49 VARCHAR(720)   ENCODE zstd
	,attribute50 VARCHAR(720)   ENCODE zstd
	,summary_flag VARCHAR(90)   ENCODE zstd
	,flex_value_attribute1 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute2 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute3 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute4 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute5 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute6 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute7 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute8 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute9 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute10 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute11 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute12 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute13 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute14 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute15 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute16 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute17 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute18 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute19 VARCHAR(90)   ENCODE zstd
	,flex_value_attribute20 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute1 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute2 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute3 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute4 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute5 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute6 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute7 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute8 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute9 VARCHAR(90)   ENCODE zstd
	,custom_value_attribute10 VARCHAR(90)   ENCODE zstd
	,creation_date TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,created_by VARCHAR(192) NOT NULL  ENCODE zstd
	,last_update_date TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,last_updated_by VARCHAR(192) NOT NULL  ENCODE zstd
	,last_update_login VARCHAR(96)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (value_id)
;

GRANT ALL on fusion.fnd_vs_values_b to group dw_dev_users;
GRANT ALL on fusion.fnd_vs_values_b to group devgroup;
GRANT ALL on fusion.fnd_vs_values_b to group dev_redshiftcoredevgroup;
GRANT ALL on fusion.fnd_vs_values_b to group dev_redshiftcoreadmingroup;
GRANT SELECT on fusion.fnd_vs_values_b to group dev_redshiftcorereadngroup;
GRANT SELECT on fusion.fnd_vs_values_b to group dev_redshiftcorereadgroup;


