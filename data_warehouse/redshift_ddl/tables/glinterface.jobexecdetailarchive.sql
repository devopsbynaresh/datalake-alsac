CREATE TABLE IF NOT EXISTS glinterface.jobexecdetailarchive
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,detailid INTEGER NOT NULL  ENCODE zstd
	,jobexecid INTEGER NOT NULL  
	,constituentid VARCHAR(36) NOT NULL  ENCODE zstd
	,revenueid VARCHAR(36) NOT NULL  ENCODE zstd
	,adjustmentid VARCHAR(36)   ENCODE zstd
	,date TIMESTAMP WITH TIME ZONE   ENCODE zstd
	,gift_seq INTEGER   ENCODE zstd
	,adjustment_seq INTEGER   ENCODE zstd
	,fiscal_year INTEGER   ENCODE zstd
	,fiscal_month INTEGER   ENCODE zstd
	,transaction_type VARCHAR(6)   ENCODE zstd
	,activity VARCHAR(12)   ENCODE zstd
	,campaign VARCHAR(6)   ENCODE zstd
	,initiative VARCHAR(12)   ENCODE zstd
	,effort VARCHAR(6)   ENCODE zstd
	,sourcecode VARCHAR(150)   ENCODE zstd
	,fund VARCHAR(12)   ENCODE zstd
	,debit_account VARCHAR(12)   ENCODE zstd
	,credit_account VARCHAR(12)   ENCODE zstd
	,station_support VARCHAR(12)   
	,event VARCHAR(60)   ENCODE zstd
	,transactionamount NUMERIC(19,4)   ENCODE zstd
	,processed_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,state VARCHAR(12)   ENCODE zstd
	,alternate_state VARCHAR(12)   ENCODE zstd
	,gl_date TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,sourcetypecodeid VARCHAR(36)   ENCODE zstd
	,postcode VARCHAR(15)   ENCODE zstd
	,updated SMALLINT NOT NULL  
	,poststatuscode SMALLINT NOT NULL  ENCODE zstd
	,event_name VARCHAR(300)   ENCODE zstd
	,event_desc VARCHAR(1300)   ENCODE zstd
	,paymentmethod VARCHAR(150)   ENCODE zstd
	,merchant_id VARCHAR(300)   ENCODE zstd
	,rundate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (jobexecid)
SORTKEY (updated, jobexecid, station_support)
;

GRANT ALL on glinterface.jobexecdetailarchive to group dw_dev_users;
GRANT ALL on glinterface.jobexecdetailarchive to group devgroup;
GRANT ALL on glinterface.jobexecdetailarchive to group dev_redshiftcoredevgroup;
GRANT ALL on glinterface.jobexecdetailarchive to group dev_redshiftcoreadmingroup;
GRANT SELECT on glinterface.jobexecdetailarchive to group dev_redshiftcorereadngroup;
GRANT SELECT on glinterface.jobexecdetailarchive to group dev_redshiftcorereadgroup;


