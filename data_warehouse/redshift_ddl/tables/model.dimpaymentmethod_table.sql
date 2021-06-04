CREATE TABLE IF NOT EXISTS "model".dimpaymentmethod
(
	paymentmethodsk BIGINT NOT NULL  ENCODE az64
	,dmspaymentmethodcategorycodenk INTEGER   ENCODE zstd
	,dmspaymentmethodidnk VARCHAR(108)   ENCODE zstd
	,dmspaymentmethodsubcategoryidnk VARCHAR(36)   ENCODE zstd
	,paymentmethodcategorydescription VARCHAR(42)   ENCODE zstd
	,paymentmethoddescription VARCHAR(300)   ENCODE zstd
	,paymentmethodsubcategorydescription VARCHAR(300)   ENCODE zstd
	,maxrowversion VARCHAR(1300) NOT NULL  ENCODE zstd
	,etlauditkey BIGINT NOT NULL  ENCODE zstd
	,roweffectivedatetime TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT ('now'::text)::timestamp without time zone ENCODE zstd
	,rowexpirationdatetime TIMESTAMP WITHOUT TIME ZONE NOT NULL  ENCODE zstd
	,creditcardindicator SMALLINT   ENCODE zstd
	,checkindicator SMALLINT   ENCODE zstd
	,electronicfundstransferindicator SMALLINT   ENCODE zstd
	,campaignscreditcardindicator SMALLINT   ENCODE zstd
	,campaignscheckindicator SMALLINT   ENCODE zstd
)
DISTSTYLE ALL
;

GRANT SELECT on "model".dimpaymentmethod to group dev_redshiftcorereadgroup;
GRANT ALL on "model".dimpaymentmethod to group dev_redshiftcoreadmingroup;
GRANT ALL on "model".dimpaymentmethod to group dev_redshiftcoredevgroup;


