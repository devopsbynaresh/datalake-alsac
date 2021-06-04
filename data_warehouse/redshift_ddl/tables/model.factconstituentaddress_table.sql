CREATE TABLE IF NOT EXISTS "model".factconstituentaddress
(
	addresssk BIGINT   ENCODE az64
	,constituentsk BIGINT   ENCODE az64
	,constituentaddressdateupdated TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,constituentaddresspreferredindicator BOOLEAN   
	,constituentaddressseasonalfromdate VARCHAR(30)   ENCODE lzo
	,constituentaddressseasonalthroughdate VARCHAR(30)   ENCODE lzo
)
DISTSTYLE EVEN
;

GRANT SELECT on "model".factconstituentaddress to group dev_redshiftcorereadgroup;
GRANT SELECT on "model".factconstituentaddress to group dev_redshiftcoreadmingroup;
GRANT SELECT on "model".factconstituentaddress to group dev_redshiftcoredevgroup;


