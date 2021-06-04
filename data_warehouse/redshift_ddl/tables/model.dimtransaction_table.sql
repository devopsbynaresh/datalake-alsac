CREATE TABLE IF NOT EXISTS "model".dimtransaction
(
	transactionsk BIGINT   
	,dmsfinancialtransactionlineitemnk VARCHAR(36)   ENCODE lzo
	,acquiredbatchnumber VARCHAR(60)   ENCODE lzo
	,alternatetransactionid VARCHAR(180)   ENCODE lzo
	,dmsbatchnumber VARCHAR(300)   ENCODE lzo
	,donotacknowledgeindicator BOOLEAN   
	,transactioncomment VARCHAR(765)   ENCODE lzo
	,transactiondatechanged TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,transactiondateadded TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,transactionuserinserting VARCHAR(36)   ENCODE lzo
	,transactionuserupdating VARCHAR(36)   ENCODE lzo
	,pledgenumber BIGINT   ENCODE az64
	,legacyacknowledgementcode VARCHAR(60)   ENCODE lzo
	,dmsuserdefinedid VARCHAR(300)   ENCODE lzo
	,dmsfinancialtransactionid VARCHAR(36)   ENCODE lzo
	,transactionaddedbyid VARCHAR(36)   ENCODE lzo
	,reconciliationid VARCHAR(180)   ENCODE lzo
	,requestid VARCHAR(84)   ENCODE lzo
	,depositreferencenumber VARCHAR(120)   ENCODE lzo
	,merchantid VARCHAR(300)   ENCODE lzo
	,merchantkey VARCHAR(300)   ENCODE lzo
	,merchantname VARCHAR(300)   ENCODE lzo
	,bankapprovalcode VARCHAR(30)   ENCODE lzo
	,paymentmethodcategory SMALLINT   ENCODE az64
	,benefitswaivedindicator BOOLEAN   
)
DISTSTYLE KEY
DISTKEY (transactionsk)
SORTKEY (transactionsk)
;

GRANT SELECT on "model".dimtransaction to group dev_redshiftcorereadgroup;
GRANT SELECT on "model".dimtransaction to group dev_redshiftcoreadmingroup;
GRANT SELECT on "model".dimtransaction to group dev_redshiftcoredevgroup;


