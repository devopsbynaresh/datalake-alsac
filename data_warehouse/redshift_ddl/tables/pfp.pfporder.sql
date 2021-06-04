CREATE TABLE IF NOT EXISTS pfp.pfporder
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,pfporderid INTEGER NOT NULL  ENCODE az64
	,productid INTEGER   ENCODE zstd
	,altorderid VARCHAR(150)   ENCODE zstd
	,orderstateid INTEGER   ENCODE zstd
	,orderdate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,dedicationtypeid INTEGER   ENCODE zstd
	,isreorder BOOLEAN   ENCODE zstd
	,reorderseq SMALLINT   ENCODE zstd
	,isbulkorder BOOLEAN   ENCODE zstd
	,tributeid VARCHAR(36)   ENCODE zstd
	,"comment" VARCHAR(3072)   ENCODE zstd
	,inputchannelid INTEGER   ENCODE zstd
	,isdeleted BOOLEAN   ENCODE zstd
	,createddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,createdby VARCHAR(765)   ENCODE zstd
	,updateddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updatedby VARCHAR(765)   ENCODE zstd
	,ordercreateddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,noproduct BOOLEAN   ENCODE zstd
	,shipto VARCHAR(30)   ENCODE zstd
	,errorstateid INTEGER   ENCODE zstd
	,retrycount INTEGER   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (pfporderid)
;

GRANT ALL on pfp.pfporder to group dev_redshiftcoredevgroup;
GRANT ALL on pfp.pfporder to group dev_redshiftcoreadmingroup;
GRANT SELECT on pfp.pfporder to group dev_redshiftcorereadngroup;
GRANT SELECT on pfp.pfporder to group dev_redshiftcorereadgroup;


