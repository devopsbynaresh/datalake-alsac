CREATE TABLE IF NOT EXISTS attribution.sources
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,source VARCHAR(42) NOT NULL  ENCODE lzo
	,description VARCHAR(120)   ENCODE zstd
	,activity VARCHAR(12)   ENCODE zstd
	,campaign VARCHAR(6)   ENCODE zstd
	,initiative VARCHAR(12)   ENCODE zstd
	,effort VARCHAR(6)   ENCODE zstd
	,fund_type VARCHAR(3)   ENCODE zstd
	,activity_type VARCHAR(9)   ENCODE zstd
	,group_type VARCHAR(3)   ENCODE zstd
	,station_support VARCHAR(24)   ENCODE zstd
	,fund VARCHAR(48)   ENCODE zstd
	,debit_account VARCHAR(60)   ENCODE zstd
	,credit_account VARCHAR(60)   ENCODE zstd
	,office VARCHAR(6)   ENCODE zstd
	,staff VARCHAR(36)   ENCODE zstd
	,solicitor VARCHAR(36)   ENCODE zstd
	,technique VARCHAR(6)   ENCODE zstd
	,mail_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,package VARCHAR(24)   ENCODE zstd
	,list VARCHAR(12)   ENCODE zstd
	,test_code VARCHAR(24)   ENCODE zstd
	,test_cell VARCHAR(24)   ENCODE zstd
	,ack_code VARCHAR(60)   ENCODE zstd
	,project VARCHAR(60)   ENCODE zstd
	,purpose VARCHAR(24)   ENCODE zstd
	,event VARCHAR(60)   ENCODE zstd
	,interest_1 VARCHAR(24)   ENCODE zstd
	,interest_2 VARCHAR(24)   ENCODE zstd
	,interest_3 VARCHAR(24)   ENCODE zstd
	,gift_type VARCHAR(6)   ENCODE zstd
	,target_payment_amount NUMERIC(11,2)   ENCODE zstd
	,target_payment_number INTEGER   ENCODE zstd
	,target_pledge_amount NUMERIC(11,2)   ENCODE zstd
	,target_pledge_number INTEGER   ENCODE zstd
	,actual_payment_amount NUMERIC(13,2)   ENCODE zstd
	,actual_payment_number INTEGER   ENCODE zstd
	,actual_pledge_amount NUMERIC(13,2)   ENCODE zstd
	,actual_pledge_number INTEGER   ENCODE zstd
	,response_start_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,response_end_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,number_solicitations INTEGER   ENCODE zstd
	,cost_per_solicitation NUMERIC(13,4)   ENCODE zstd
	,number_contacts INTEGER   ENCODE zstd
	,cost_per_contact NUMERIC(13,4)   ENCODE zstd
	,total_cost NUMERIC(11,2)   ENCODE zstd
	,break_type VARCHAR(12)   ENCODE zstd
	,break_start_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,break_start_time VARCHAR(24)   ENCODE zstd
	,break_end_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,break_end_time VARCHAR(24)   ENCODE zstd
	,break_duration_planned VARCHAR(24)   ENCODE zstd
	,break_location VARCHAR(6)   ENCODE zstd
	,break_duration_actual VARCHAR(24)   ENCODE zstd
	,estimated_pledge_amount NUMERIC(11,2)   ENCODE zstd
	,estimated_pledge_number INTEGER   ENCODE zstd
	,talent VARCHAR(180)   ENCODE zstd
	,program VARCHAR(30)   ENCODE zstd
	,program_date_time TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,program_day_part VARCHAR(24)   ENCODE zstd
	,program_showing VARCHAR(6)   ENCODE zstd
	,program_source VARCHAR(24)   ENCODE zstd
	,script VARCHAR(24)   ENCODE zstd
	,volunteer_group VARCHAR(36)   ENCODE zstd
	,"location" VARCHAR(24)   ENCODE zstd
	,segment_type VARCHAR(12)   ENCODE zstd
	,query_name VARCHAR(60)   ENCODE zstd
	,create_interactions VARCHAR(6)   ENCODE zstd
	,source_analysis_rule VARCHAR(120)   ENCODE zstd
	,auto_popup_flag VARCHAR(6)   ENCODE zstd
	,goto_field VARCHAR(90)   ENCODE zstd
	,sts VARCHAR(6)   ENCODE zstd
	,interest_10 VARCHAR(24)   ENCODE zstd
	,interest_4 VARCHAR(24)   ENCODE zstd
	,interest_5 VARCHAR(24)   ENCODE zstd
	,interest_6 VARCHAR(24)   ENCODE zstd
	,interest_7 VARCHAR(24)   ENCODE zstd
	,interest_8 VARCHAR(24)   ENCODE zstd
	,interest_9 VARCHAR(24)   ENCODE zstd
	,date_inserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_inserting VARCHAR(600)   ENCODE zstd
	,date_updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_updating VARCHAR(600)   ENCODE zstd
	,payment_start_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,payment_end_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,pledge_start_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,pledge_end_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,ask_amount_rules VARCHAR(24)   ENCODE zstd
	,joint_source VARCHAR(42)   ENCODE zstd
	,seed_groups VARCHAR(12000)   ENCODE zstd
	,default_filename VARCHAR(180)   ENCODE zstd
	,program_end_date_time TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,offer_amount NUMERIC(11,2)   ENCODE zstd
	,data_processing_cost NUMERIC(13,4)   ENCODE zstd
	,list_cost NUMERIC(13,4)   ENCODE zstd
	,package_cost NUMERIC(13,4)   ENCODE zstd
	,postage_cost_per_piece NUMERIC(13,4)   ENCODE zstd
	,retest_cost NUMERIC(13,4)   ENCODE zstd
	,rollout_cost NUMERIC(11,2)   ENCODE zstd
	,rollout_postage_cost_per_piece NUMERIC(13,4)   ENCODE zstd
	,rollout_product_cost_per_piece NUMERIC(13,4)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (source)
;

GRANT ALL on attribution.sources to group dw_dev_users;
GRANT ALL on attribution.sources to group devgroup;
GRANT ALL on attribution.sources to group dev_redshiftcoredevgroup;
GRANT ALL on attribution.sources to group dev_redshiftcoreadmingroup;
GRANT SELECT on attribution.sources to group dev_redshiftcorereadngroup;
GRANT SELECT on attribution.sources to group dev_redshiftcorereadgroup;


