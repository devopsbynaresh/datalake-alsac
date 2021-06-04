CREATE TABLE IF NOT EXISTS attribution.efforts
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,activity VARCHAR(12) NOT NULL  ENCODE lzo
	,campaign VARCHAR(6) NOT NULL  ENCODE zstd
	,initiative VARCHAR(12) NOT NULL  ENCODE zstd
	,effort VARCHAR(6) NOT NULL  ENCODE zstd
	,description VARCHAR(120)   ENCODE zstd
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
	,project VARCHAR(60)   ENCODE zstd
	,purpose VARCHAR(24)   ENCODE zstd
	,event VARCHAR(60)   ENCODE zstd
	,interest_1 VARCHAR(24)   ENCODE zstd
	,interest_2 VARCHAR(24)   ENCODE zstd
	,interest_3 VARCHAR(24)   ENCODE zstd
	,first_segment VARCHAR(9)   ENCODE zstd
	,number_of_codes INTEGER   ENCODE zstd
	,query_name VARCHAR(60)   ENCODE zstd
	,code_format VARCHAR(6)   ENCODE zstd
	,cost_per_contact NUMERIC(8,2)   ENCODE zstd
	,number_solicitations INTEGER   ENCODE zstd
	,gift_type VARCHAR(6)   ENCODE zstd
	,source_analysis_rule VARCHAR(120)   ENCODE zstd
	,sts VARCHAR(6)   ENCODE zstd
	,date_inserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_inserting VARCHAR(600)   ENCODE zstd
	,date_updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,user_updating VARCHAR(600)   ENCODE zstd
	,actual_mail_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,actual_number_solicitations INTEGER   ENCODE zstd
	,goal_number INTEGER   ENCODE zstd
	,actual_pledge_number INTEGER   ENCODE zstd
	,actual_payment_number INTEGER   ENCODE zstd
	,goal_amount NUMERIC(8,2)   ENCODE zstd
	,actual_pledge_amount NUMERIC(8,2)   ENCODE zstd
	,actual_payment_amount NUMERIC(8,2)   ENCODE zstd
	,goal_base_amount NUMERIC(8,2)   ENCODE zstd
	,actual_base_pledge_amount NUMERIC(8,2)   ENCODE zstd
	,actual_base_payment_amount NUMERIC(8,2)   ENCODE zstd
	,goal_total_cost NUMERIC(8,2)   ENCODE zstd
	,actual_total_cost NUMERIC(8,2)   ENCODE zstd
	,goal_base_total_cost NUMERIC(8,2)   ENCODE zstd
	,actual_base_total_cost INTEGER   ENCODE zstd
	,goal_cost_per_sol NUMERIC(8,2)   ENCODE zstd
	,actual_cost_per_sol NUMERIC(8,2)   ENCODE zstd
	,goal_base_cost_per_sol NUMERIC(8,2)   ENCODE zstd
	,actual_base_cost_per_sol NUMERIC(8,2)   ENCODE zstd
	,goal_net_amount NUMERIC(8,2)   ENCODE zstd
	,goal_base_net_amount NUMERIC(8,2)   ENCODE zstd
	,goal_response_rate NUMERIC(8,2)   ENCODE zstd
	,goal_average_gift NUMERIC(8,2)   ENCODE zstd
	,goal_base_average_gift NUMERIC(8,2)   ENCODE zstd
	,fiscal_year INTEGER   ENCODE zstd
	,effort_seq INTEGER   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,PRIMARY KEY (activity, campaign, initiative, effort)
)
DISTSTYLE KEY
DISTKEY (activity)
;

GRANT ALL on attribution.efforts to group dw_dev_users;
GRANT ALL on attribution.efforts to group devgroup;
GRANT ALL on attribution.efforts to group dev_redshiftcoredevgroup;
GRANT ALL on attribution.efforts to group dev_redshiftcoreadmingroup;
GRANT SELECT on attribution.efforts to group dev_redshiftcorereadngroup;
GRANT SELECT on attribution.efforts to group dev_redshiftcorereadgroup;