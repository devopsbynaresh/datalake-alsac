CREATE TABLE IF NOT EXISTS dms.revenueschedule
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  ENCODE lzo
	,creditcardid VARCHAR(36)   
	,frequencycode SMALLINT NOT NULL  ENCODE zstd
	,frequency VARCHAR(54)   ENCODE zstd
	,startdate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,enddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,statuscode SMALLINT NOT NULL  ENCODE zstd
	,numberofinstallments INTEGER NOT NULL  ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
	,nexttransactiondate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,status VARCHAR(30)   ENCODE zstd
	,pledgesubtypeid VARCHAR(36)   ENCODE zstd
	,sendpledgereminder BOOLEAN   ENCODE zstd
	,ispending BOOLEAN   ENCODE zstd
	,tslong BIGINT   ENCODE zstd
	,scheduleseeddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,eventid VARCHAR(36)   ENCODE zstd
	,localcorpid VARCHAR(36)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (creditcardid)
SORTKEY (creditcardid)
;

GRANT ALL on dms.revenueschedule to group devgroup;
GRANT ALL on dms.revenueschedule to group dw_dev_users;
GRANT ALL on dms.revenueschedule to group dev_redshiftcoredevgroup;
GRANT ALL on dms.revenueschedule to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.revenueschedule to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.revenueschedule to group dev_redshiftcorereadgroup;


