CREATE TABLE IF NOT EXISTS evm_xref.eventtypes
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,xrefid VARCHAR(36) NOT NULL  ENCODE zstd
	,eventtypeid VARCHAR(36) NOT NULL  ENCODE zstd
	,referencesystemid VARCHAR(36) NOT NULL  ENCODE zstd
	,referencetablename VARCHAR(150) NOT NULL  ENCODE zstd
	,referencecolumnname VARCHAR(150) NOT NULL  ENCODE zstd
	,referencevalue VARCHAR(2250) NOT NULL  ENCODE zstd
	,birowversion VARCHAR(18) NOT NULL  ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on evm_xref.eventtypes to group dw_dev_users;
GRANT ALL on evm_xref.eventtypes to group devgroup;
GRANT ALL on evm_xref.eventtypes to group dev_redshiftcoredevgroup;
GRANT ALL on evm_xref.eventtypes to group dev_redshiftcoreadmingroup;
GRANT SELECT on evm_xref.eventtypes to group dev_redshiftcorereadngroup;
GRANT SELECT on evm_xref.eventtypes to group dev_redshiftcorereadgroup;


