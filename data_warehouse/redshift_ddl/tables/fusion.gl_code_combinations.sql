CREATE TABLE IF NOT EXISTS fusion.gl_code_combinations
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,code_combination_id BIGINT NOT NULL  ENCODE az64
	,last_update_date TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,last_updated_by VARCHAR(192) NOT NULL  ENCODE zstd
	,chart_of_accounts_id BIGINT NOT NULL  ENCODE zstd
	,detail_posting_allowed_flag VARCHAR(3) NOT NULL  ENCODE zstd
	,detail_budgeting_allowed_flag VARCHAR(3) NOT NULL  ENCODE zstd
	,account_type VARCHAR(3) NOT NULL  ENCODE zstd
	,enabled_flag VARCHAR(3) NOT NULL  ENCODE zstd
	,summary_flag VARCHAR(3) NOT NULL  ENCODE zstd
	,segment1 VARCHAR(75)   ENCODE zstd
	,segment2 VARCHAR(75)   ENCODE zstd
	,segment3 VARCHAR(75)   ENCODE zstd
	,segment4 VARCHAR(75)   ENCODE zstd
	,segment5 VARCHAR(75)   ENCODE zstd
	,segment6 VARCHAR(75)   ENCODE zstd
	,segment7 VARCHAR(75)   ENCODE zstd
	,segment8 VARCHAR(75)   ENCODE zstd
	,segment9 VARCHAR(75)   ENCODE zstd
	,segment10 VARCHAR(75)   ENCODE zstd
	,segment11 VARCHAR(75)   ENCODE zstd
	,segment12 VARCHAR(75)   ENCODE zstd
	,segment13 VARCHAR(75)   ENCODE zstd
	,segment14 VARCHAR(75)   ENCODE zstd
	,segment15 VARCHAR(75)   ENCODE zstd
	,segment16 VARCHAR(75)   ENCODE zstd
	,segment17 VARCHAR(75)   ENCODE zstd
	,segment18 VARCHAR(75)   ENCODE zstd
	,segment19 VARCHAR(75)   ENCODE zstd
	,segment20 VARCHAR(75)   ENCODE zstd
	,segment21 VARCHAR(75)   ENCODE zstd
	,segment22 VARCHAR(75)   ENCODE zstd
	,segment23 VARCHAR(75)   ENCODE zstd
	,segment24 VARCHAR(75)   ENCODE zstd
	,segment25 VARCHAR(75)   ENCODE zstd
	,segment26 VARCHAR(75)   ENCODE zstd
	,segment27 VARCHAR(75)   ENCODE zstd
	,segment28 VARCHAR(75)   ENCODE zstd
	,segment29 VARCHAR(75)   ENCODE zstd
	,segment30 VARCHAR(75)   ENCODE zstd
	,description VARCHAR(720)   ENCODE zstd
	,template_id BIGINT   ENCODE zstd
	,allocation_create_flag VARCHAR(3)   ENCODE zstd
	,start_date_active TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,end_date_active TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,attribute1 VARCHAR(450)   ENCODE zstd
	,attribute2 VARCHAR(450)   ENCODE zstd
	,attribute3 VARCHAR(450)   ENCODE zstd
	,attribute4 VARCHAR(450)   ENCODE zstd
	,attribute5 VARCHAR(450)   ENCODE zstd
	,attribute6 VARCHAR(450)   ENCODE zstd
	,attribute7 VARCHAR(450)   ENCODE zstd
	,attribute8 VARCHAR(450)   ENCODE zstd
	,attribute9 VARCHAR(450)   ENCODE zstd
	,attribute10 VARCHAR(450)   ENCODE zstd
	,attribute_category VARCHAR(450)   ENCODE zstd
	,segment_attribute1 VARCHAR(180)   ENCODE zstd
	,segment_attribute2 VARCHAR(180)   ENCODE zstd
	,segment_attribute3 VARCHAR(180)   ENCODE zstd
	,segment_attribute4 VARCHAR(180)   ENCODE zstd
	,segment_attribute5 VARCHAR(180)   ENCODE zstd
	,segment_attribute6 VARCHAR(180)   ENCODE zstd
	,segment_attribute7 VARCHAR(180)   ENCODE zstd
	,segment_attribute8 VARCHAR(180)   ENCODE zstd
	,segment_attribute9 VARCHAR(180)   ENCODE zstd
	,segment_attribute10 VARCHAR(180)   ENCODE zstd
	,segment_attribute11 VARCHAR(180)   ENCODE zstd
	,segment_attribute12 VARCHAR(180)   ENCODE zstd
	,segment_attribute13 VARCHAR(180)   ENCODE zstd
	,segment_attribute14 VARCHAR(180)   ENCODE zstd
	,segment_attribute15 VARCHAR(180)   ENCODE zstd
	,segment_attribute16 VARCHAR(180)   ENCODE zstd
	,segment_attribute17 VARCHAR(180)   ENCODE zstd
	,segment_attribute18 VARCHAR(180)   ENCODE zstd
	,segment_attribute19 VARCHAR(180)   ENCODE zstd
	,segment_attribute20 VARCHAR(180)   ENCODE zstd
	,segment_attribute21 VARCHAR(180)   ENCODE zstd
	,segment_attribute22 VARCHAR(180)   ENCODE zstd
	,segment_attribute23 VARCHAR(180)   ENCODE zstd
	,segment_attribute24 VARCHAR(180)   ENCODE zstd
	,segment_attribute25 VARCHAR(180)   ENCODE zstd
	,segment_attribute26 VARCHAR(180)   ENCODE zstd
	,segment_attribute27 VARCHAR(180)   ENCODE zstd
	,segment_attribute28 VARCHAR(180)   ENCODE zstd
	,segment_attribute29 VARCHAR(180)   ENCODE zstd
	,segment_attribute30 VARCHAR(180)   ENCODE zstd
	,segment_attribute31 VARCHAR(180)   ENCODE zstd
	,segment_attribute32 VARCHAR(180)   ENCODE zstd
	,segment_attribute33 VARCHAR(180)   ENCODE zstd
	,segment_attribute34 VARCHAR(180)   ENCODE zstd
	,segment_attribute35 VARCHAR(180)   ENCODE zstd
	,segment_attribute36 VARCHAR(180)   ENCODE zstd
	,segment_attribute37 VARCHAR(180)   ENCODE zstd
	,segment_attribute38 VARCHAR(180)   ENCODE zstd
	,segment_attribute39 VARCHAR(180)   ENCODE zstd
	,segment_attribute40 VARCHAR(180)   ENCODE zstd
	,segment_attribute41 VARCHAR(180)   ENCODE zstd
	,segment_attribute42 VARCHAR(180)   ENCODE zstd
	,jgzz_recon_flag VARCHAR(3)   ENCODE zstd
	,jgzz_recon_context VARCHAR(90)   ENCODE zstd
	,reference1 VARCHAR(3)   ENCODE zstd
	,reference2 VARCHAR(3)   ENCODE zstd
	,reference3 VARCHAR(75)   ENCODE zstd
	,reference4 VARCHAR(3)   ENCODE zstd
	,reference5 VARCHAR(3)   ENCODE zstd
	,preserve_flag VARCHAR(3)   ENCODE zstd
	,refresh_flag VARCHAR(3)   ENCODE zstd
	,igi_balanced_budget_flag VARCHAR(3)   ENCODE zstd
	,company_cost_center_org_id BIGINT   ENCODE zstd
	,revaluation_id BIGINT   ENCODE zstd
	,ledger_segment VARCHAR(60)   ENCODE zstd
	,ledger_type_code VARCHAR(3)   ENCODE zstd
	,alternate_code_combination_id BIGINT   ENCODE zstd
	,financial_category VARCHAR(90)   ENCODE zstd
	,object_version_number BIGINT NOT NULL  ENCODE zstd
	,creation_date TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,created_by VARCHAR(192) NOT NULL  ENCODE zstd
	,last_update_login VARCHAR(96)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (code_combination_id)
;

GRANT ALL on fusion.gl_code_combinations to group dw_dev_users;
GRANT ALL on fusion.gl_code_combinations to group devgroup;
GRANT ALL on fusion.gl_code_combinations to group dev_redshiftcoredevgroup;
GRANT ALL on fusion.gl_code_combinations to group dev_redshiftcoreadmingroup;
GRANT SELECT on fusion.gl_code_combinations to group dev_redshiftcorereadngroup;
GRANT SELECT on fusion.gl_code_combinations to group dev_redshiftcorereadgroup;


