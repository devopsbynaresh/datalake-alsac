CREATE TABLE IF NOT EXISTS dms.registrant
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,id VARCHAR(36) NOT NULL  
	,eventid VARCHAR(36) NOT NULL  ENCODE zstd
	,constituentid VARCHAR(36)   ENCODE zstd
	,attended BOOLEAN NOT NULL  ENCODE zstd
	,willnotattend BOOLEAN NOT NULL  ENCODE zstd
	,guestofregistrantid VARCHAR(36)   ENCODE zstd
	,eventseatingnote VARCHAR(750) NOT NULL  ENCODE zstd
	,benefitswaived BOOLEAN NOT NULL  ENCODE zstd
	,onlineregistrant BOOLEAN NOT NULL  ENCODE zstd
	,addedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,changedbyid VARCHAR(36) NOT NULL  ENCODE zstd
	,dateadded TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,datechanged TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,"ts" VARCHAR(1300) NOT NULL  ENCODE zstd
	,iscancelled BOOLEAN NOT NULL  ENCODE zstd
	,customidentifier VARCHAR(300) NOT NULL  ENCODE zstd
	,notes VARCHAR(765) NOT NULL  ENCODE zstd
	,iswalkin BOOLEAN NOT NULL  ENCODE zstd
	,usermarkedattendance BOOLEAN NOT NULL  ENCODE zstd
	,sequenceid INTEGER   ENCODE zstd
	,lookupid VARCHAR(300)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (id)
SORTKEY (id)
;

GRANT ALL on dms.registrant to group devgroup;
GRANT ALL on dms.registrant to group dw_dev_users;
GRANT ALL on dms.registrant to group dev_redshiftcoredevgroup;
GRANT ALL on dms.registrant to group dev_redshiftcoreadmingroup;
GRANT SELECT on dms.registrant to group dev_redshiftcorereadngroup;
GRANT SELECT on dms.registrant to group dev_redshiftcorereadgroup;


