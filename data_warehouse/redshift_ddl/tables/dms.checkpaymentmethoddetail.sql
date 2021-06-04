CREATE TABLE IF NOT EXISTS dms.checkpaymentmethoddetail
(
	op VARCHAR(36)   ENCODE lzo
	,"timestamp" VARCHAR(36)   ENCODE lzo
	,id VARCHAR(36) NOT NULL  ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,birowversion VARCHAR(10000) NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300)   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT SELECT on dms.checkpaymentmethoddetail to group dev_redshiftcorereadgroup;


