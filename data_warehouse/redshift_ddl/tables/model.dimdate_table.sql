CREATE TABLE IF NOT EXISTS "model".dimdate
(
	thedate TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE az64
	,calendarmonthname VARCHAR(27)   ENCODE zstd
	,calendarmonthshortname VARCHAR(9)   ENCODE zstd
	,calendaryear INTEGER   ENCODE zstd
	,calendaryearmonth INTEGER   ENCODE zstd
	,calendarmonth SMALLINT   ENCODE zstd
	,calendarday SMALLINT   ENCODE zstd
	,calendardayofweeknumber SMALLINT   ENCODE zstd
	,calendardayofweekname VARCHAR(27)   ENCODE zstd
	,calendardayofweekshortname VARCHAR(9)   ENCODE zstd
	,calendardayofyear INTEGER   ENCODE zstd
	,calendarquarternumber SMALLINT   ENCODE zstd
	,calendarweekofyearnumber INTEGER   ENCODE zstd
	,fiscalyear INTEGER   ENCODE zstd
	,fiscalyearmonth INTEGER   ENCODE zstd
	,fiscalmonth SMALLINT   ENCODE zstd
	,fiscalquarternumber SMALLINT   ENCODE zstd
	,fiscalweekofyearnumber INTEGER   ENCODE zstd
	,broadcastyear INTEGER   ENCODE zstd
	,broadcastyearmonth INTEGER   ENCODE zstd
	,broadcastmonth SMALLINT   ENCODE zstd
	,broadcastmonthname VARCHAR(27)   ENCODE zstd
	,broadcastmonthshortname VARCHAR(9)   ENCODE zstd
	,broadcastdayofweeknumber SMALLINT   ENCODE zstd
	,broadcastweekofyearnumber INTEGER   ENCODE zstd
	,broadcastquarternumber SMALLINT   ENCODE zstd
	,nonconventionaldateindicator BOOLEAN   ENCODE zstd
	,isoyear INTEGER   ENCODE zstd
	,isoweek INTEGER   ENCODE zstd
	,isoyearweek INTEGER   ENCODE zstd
	,maxrowversion VARCHAR(1300) NOT NULL  ENCODE zstd
	,etlauditkey BIGINT NOT NULL  ENCODE zstd
	,roweffectivedatetime TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT ('now'::text)::timestamp without time zone ENCODE zstd
	,rowexpirationdatetime TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,martloaddateindicator INTEGER   ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (thedate)
;

GRANT SELECT on "model".dimdate to group dev_redshiftcorereadgroup;
GRANT ALL on "model".dimdate to group dev_redshiftcoreadmingroup;
GRANT ALL on "model".dimdate to group dev_redshiftcoredevgroup;


