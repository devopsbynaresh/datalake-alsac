CREATE TABLE IF NOT EXISTS eventmaster.eventmasters
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,eventmasterid VARCHAR(36) NOT NULL  ENCODE zstd
	,eventtypeid VARCHAR(36)   ENCODE zstd
	,eventmastername VARCHAR(300)   ENCODE zstd
	,eventmasterdescription VARCHAR(765)   ENCODE zstd
	,eventmastermonth INTEGER   ENCODE zstd
	,regionid VARCHAR(36)   ENCODE zstd
	,address VARCHAR(750)   ENCODE zstd
	,city VARCHAR(150)   ENCODE zstd
	,stateid VARCHAR(36)   ENCODE zstd
	,zipcode VARCHAR(30)   ENCODE zstd
	,countryid VARCHAR(36)   ENCODE zstd
	,eventmastertimezoneid VARCHAR(36)   ENCODE zstd
	,eventmastercode VARCHAR(60)   ENCODE zstd
	,staffuserid VARCHAR(300)   ENCODE zstd
	,statusid VARCHAR(36) NOT NULL  ENCODE zstd
	,costcenterid VARCHAR(36)   ENCODE zstd
	,dateinserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,dateupdated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on eventmaster.eventmasters to group devgroup;
GRANT ALL on eventmaster.eventmasters to group dw_dev_users;
GRANT ALL on eventmaster.eventmasters to group dev_redshiftcoredevgroup;
GRANT ALL on eventmaster.eventmasters to group dev_redshiftcoreadmingroup;
GRANT SELECT on eventmaster.eventmasters to group dev_redshiftcorereadngroup;
GRANT SELECT on eventmaster.eventmasters to group dev_redshiftcorereadgroup;


