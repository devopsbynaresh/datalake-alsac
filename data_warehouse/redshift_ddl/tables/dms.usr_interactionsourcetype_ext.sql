CREATE TABLE IF NOT EXISTS dms.usr_interactionsourcetype_ext
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE lzo
	,sourcetypecodeid VARCHAR(36) NOT NULL  
	,activity VARCHAR(12) NOT NULL  ENCODE zstd
	,campaign VARCHAR(6) NOT NULL  ENCODE zstd
	,initiative VARCHAR(12) NOT NULL  ENCODE zstd
	,effort VARCHAR(6) NOT NULL  ENCODE zstd
	,fund_type VARCHAR(3) NOT NULL  ENCODE zstd
	,station_support VARCHAR(24) NOT NULL  ENCODE zstd
	,fund VARCHAR(48) NOT NULL  ENCODE zstd
	,debit_account VARCHAR(60) NOT NULL  ENCODE zstd
	,credit_account VARCHAR(60) NOT NULL  ENCODE zstd
	,technique VARCHAR(6) NOT NULL  ENCODE zstd
	,package VARCHAR(24) NOT NULL  ENCODE zstd
	,project VARCHAR(60) NOT NULL  ENCODE zstd
	,event VARCHAR(60) NOT NULL  ENCODE zstd
	,program VARCHAR(30) NOT NULL  ENCODE zstd
	,program_date_time TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,program_source VARCHAR(24) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (sourcetypecodeid)
SORTKEY (sourcetypecodeid)
;

GRANT ALL on dms.usr_interactionsourcetype_ext to group devgroup;
GRANT ALL on dms.usr_interactionsourcetype_ext to group dw_dev_users;
GRANT ALL on dms.usr_interactionsourcetype_ext to group dev_redshiftcoredevgroup;
GRANT ALL on dms.usr_interactionsourcetype_ext to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.usr_interactionsourcetype_ext to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.usr_interactionsourcetype_ext to group dev_redshiftcorereadgroup;


