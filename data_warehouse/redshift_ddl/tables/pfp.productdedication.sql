CREATE TABLE IF NOT EXISTS pfp.productdedication
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,productdedicationid INTEGER NOT NULL  ENCODE az64
	,productdedicationcode VARCHAR(150)   ENCODE zstd
	,description VARCHAR(3072)   ENCODE zstd
	,isactive BOOLEAN   ENCODE zstd
	,isdeleted BOOLEAN   ENCODE zstd
	,createddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,createdby VARCHAR(765)   ENCODE zstd
	,updateddate TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updatedby VARCHAR(765)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
DISTSTYLE KEY
DISTKEY (productdedicationid)
;

GRANT ALL on pfp.productdedication to group dev_redshiftcoredevgroup;
GRANT ALL on pfp.productdedication to group dev_redshiftcoreadmingroup;
GRANT SELECT on pfp.productdedication to group dev_redshiftcorereadngroup;
GRANT SELECT on pfp.productdedication to group dev_redshiftcorereadgroup;


