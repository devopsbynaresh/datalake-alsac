CREATE TABLE IF NOT EXISTS eventmaster.events
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,eventid VARCHAR(36) NOT NULL  ENCODE lzo
	,eventtypeid VARCHAR(36) NOT NULL  ENCODE zstd
	,eventname VARCHAR(600)   ENCODE zstd
	,eventdescription VARCHAR(765)   ENCODE zstd
	,startdate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,enddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,regionid VARCHAR(36)   ENCODE zstd
	,fiscalyear INTEGER   ENCODE zstd
	,address VARCHAR(750)   ENCODE zstd
	,city VARCHAR(150)   ENCODE zstd
	,stateid VARCHAR(36)   ENCODE zstd
	,zipcode VARCHAR(30)   ENCODE zstd
	,eventtimezoneid VARCHAR(36)   ENCODE zstd
	,eventcode VARCHAR(60)   ENCODE zstd
	,eventprogramid VARCHAR(36)   ENCODE zstd
	,statusid VARCHAR(36) NOT NULL  
	,countryid VARCHAR(36)   ENCODE zstd
	,costcenterid VARCHAR(36)   ENCODE zstd
	,dateinserted TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,dateupdated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,eventmasterid VARCHAR(36)   ENCODE zstd
	,shiptocity VARCHAR(150)   ENCODE zstd
	,shiptostateid VARCHAR(36)   ENCODE zstd
	,shiptozipcode VARCHAR(30)   ENCODE zstd
	,contactcity VARCHAR(150)   ENCODE zstd
	,contactstateid VARCHAR(36)   ENCODE zstd
	,contactzipcode VARCHAR(30)   ENCODE zstd
	,expectedparticipants INTEGER   ENCODE zstd
	,preferredcontacttypeid VARCHAR(36)   ENCODE zstd
	,actualparticipants INTEGER   ENCODE zstd
	,eventstartmonth VARCHAR(6)   ENCODE zstd
	,eventstartyear VARCHAR(12)   ENCODE zstd
	,address2 VARCHAR(750)   ENCODE zstd
	,sendkit BOOLEAN   ENCODE zstd
	,sendincentives BOOLEAN   ENCODE zstd
	,reasonid VARCHAR(36)   ENCODE zstd
	,eventwebsite VARCHAR(765)   ENCODE zstd
	,createdby VARCHAR(150)   ENCODE zstd
	,modifiedby VARCHAR(150)   ENCODE zstd
	,cancelledagent VARCHAR(300)   ENCODE zstd
	,cancelleddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,systemoforigin VARCHAR(765)   ENCODE zstd
	,eventformatid VARCHAR(36)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (statusid)
SORTKEY (statusid)
;

GRANT ALL on eventmaster.events to group devgroup;
GRANT ALL on eventmaster.events to group dw_dev_users;
GRANT ALL on eventmaster.events to group dev_redshiftcoredevgroup;
GRANT ALL on eventmaster.events to group dev_redshiftcoreadmingroup;
GRANT SELECT on eventmaster.events to group dev_redshiftcorereadngroup;
GRANT SELECT on eventmaster.events to group dev_redshiftcorereadgroup;


