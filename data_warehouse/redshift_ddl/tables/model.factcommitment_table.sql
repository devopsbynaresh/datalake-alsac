CREATE TABLE IF NOT EXISTS "model".factcommitment
(
	transactionsk BIGINT   ENCODE az64
	,revenueschedulesk BIGINT   ENCODE az64
	,attributionsk BIGINT   ENCODE az64
	,constituentsk BIGINT   ENCODE az64
	,costcentersk BIGINT   ENCODE az64
	,creditaccountsk BIGINT   ENCODE az64
	,debitaccountsk BIGINT   ENCODE az64
	,eventsk BIGINT   ENCODE az64
	,fundsk BIGINT   ENCODE az64
	,paymentmethodsk BIGINT   ENCODE az64
	,commitmentstatussk BIGINT   ENCODE az64
	,projectsk BIGINT   ENCODE az64
	,tributesk BIGINT   ENCODE az64
	,commitmentdate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,commitmentamount NUMERIC(19,4)   ENCODE az64
	,commitmentorganizationamount NUMERIC(19,4)   ENCODE az64
	,commitmentoriginalcalculatedamount NUMERIC(30,4)   ENCODE az64
	,commitmentoriginalamount NUMERIC(19,4)   ENCODE az64
	,commitmentcalculatedamount NUMERIC(30,4)   ENCODE az64
	,commitmentdepositdate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,commitmentpostdate DATE   ENCODE az64
	,commitmentprocessdate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,transactiontypesk BIGINT   ENCODE az64
)
DISTSTYLE EVEN
;

GRANT ALL on "model".factcommitment to group dev_redshiftcoreadmingroup;
GRANT SELECT on "model".factcommitment to group dev_redshiftcorereadgroup;
GRANT SELECT on "model".factcommitment to group dev_redshiftcoredevgroup;


