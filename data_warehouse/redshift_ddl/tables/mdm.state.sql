CREATE TABLE IF NOT EXISTS mdm.state
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,state_id VARCHAR(36) NOT NULL  ENCODE zstd
	,state VARCHAR(9)   ENCODE zstd
	,description VARCHAR(240)   ENCODE zstd
	,country VARCHAR(12) NOT NULL  ENCODE zstd
	,status_id VARCHAR(36)   ENCODE zstd
	,created TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,created_by VARCHAR(768)   ENCODE zstd
	,updated TIMESTAMP WITHOUT TIME ZONE   ENCODE zstd
	,updated_by VARCHAR(768)   ENCODE zstd
	,replaced_by VARCHAR(21)   ENCODE zstd
	,iso_exception VARCHAR(3)   ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on mdm.state to group dw_dev_users;
GRANT ALL on mdm.state to group devgroup;
GRANT ALL on mdm.state to group dev_redshiftcoredevgroup;
GRANT ALL on mdm.state to group dev_redshiftcoreadmingroup;
GRANT SELECT on mdm.state to group dev_redshiftcorereadngroup;
GRANT SELECT on mdm.state to group dev_redshiftcorereadgroup;


