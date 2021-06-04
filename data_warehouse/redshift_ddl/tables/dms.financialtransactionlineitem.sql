CREATE TABLE IF NOT EXISTS dms.financialtransactionlineitem
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,financialtransactionid VARCHAR(36) NOT NULL  
	,transactionamount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,typecode SMALLINT NOT NULL  ENCODE zstd
	,postdate DATE   ENCODE zstd
	,orgamount NUMERIC(19,4) NOT NULL  ENCODE zstd
	,deletedon TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
	,unitvalue NUMERIC(19,4)   ENCODE zstd
	,description VARCHAR(2100)   ENCODE zstd
	,PRIMARY KEY (financialtransactionid)
)
DISTSTYLE KEY
DISTKEY (financialtransactionid)
SORTKEY (financialtransactionid)
;

GRANT ALL on dms.financialtransactionlineitem to group devgroup;
GRANT ALL on dms.financialtransactionlineitem to group dw_dev_users;
GRANT ALL on dms.financialtransactionlineitem to group dev_redshiftcoredevgroup;
GRANT ALL on dms.financialtransactionlineitem to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.financialtransactionlineitem to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.financialtransactionlineitem to group dev_redshiftcorereadgroup;


