CREATE TABLE IF NOT EXISTS dms.financialtransaction
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,constituentid VARCHAR(36)   ENCODE zstd
	,userdefinedid VARCHAR(300) NOT NULL  ENCODE zstd
	,typecode SMALLINT NOT NULL  ENCODE zstd
	,transactionamount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,date TIMESTAMP WITH TIME ZONE NOT NULL  ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,description VARCHAR(2100) NOT NULL  ENCODE zstd
	,parentid VARCHAR(36)   ENCODE zstd
	,postdate DATE   ENCODE zstd
	,poststatuscode SMALLINT NOT NULL  ENCODE zstd
	,poststatus VARCHAR(11)   ENCODE zstd
	,deletedon TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,transactioncurrencyid VARCHAR(36) NOT NULL  ENCODE zstd
	,baseexchangerateid VARCHAR(36)   ENCODE zstd
	,orgexchangerateid VARCHAR(36)   ENCODE zstd
	,pdaccountsystemid VARCHAR(36)   ENCODE zstd
	,baseamount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,orgamount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,appuserid VARCHAR(36)   ENCODE zstd
	,"type" VARCHAR(36)   ENCODE zstd
	,sequencegeneratorid INTEGER   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,calculateduserdefinedid VARCHAR(100)   ENCODE zstd
	,PRIMARY KEY (id)
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.financialtransaction to group dw_dev_users;
GRANT ALL on dms.financialtransaction to group devgroup;
GRANT ALL on dms.financialtransaction to group dev_redshiftcoredevgroup;
GRANT ALL on dms.financialtransaction to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.financialtransaction to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.financialtransaction to group dev_redshiftcorereadgroup;


