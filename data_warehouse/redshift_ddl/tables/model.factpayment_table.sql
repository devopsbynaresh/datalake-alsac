CREATE TABLE IF NOT EXISTS "model".factpayment
(
	transactionsk BIGINT   
	,attributionsk BIGINT   ENCODE az64
	,constituentsk BIGINT   ENCODE az64
	,costcentersk BIGINT   ENCODE az64
	,creditaccountsk BIGINT   ENCODE az64
	,eventsk BIGINT   ENCODE az64
	,fairmarketvalue NUMERIC(19,4)   ENCODE az64
	,paymentpostdate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,originalpaymentamount NUMERIC(19,4)   ENCODE az64
	,paymentamount NUMERIC(19,4)   ENCODE az64
	,fundsk BIGINT   ENCODE az64
	,paymentdate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,transactiontypesk BIGINT   ENCODE az64
	,paymentmethodsk BIGINT   ENCODE az64
	,paymentprocessdate TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,projectsk BIGINT   ENCODE az64
	,sourcesk BIGINT   ENCODE az64
	,techniquesk BIGINT   ENCODE az64
	,tributesk BIGINT   ENCODE az64
	,debitaccountsk BIGINT   ENCODE az64
)
DISTSTYLE KEY
DISTKEY (transactionsk)
SORTKEY (transactionsk)
;

GRANT SELECT on "model".factpayment to group dev_redshiftcorereadgroup;
GRANT SELECT on "model".factpayment to group dev_redshiftcoreadmingroup;
GRANT SELECT on "model".factpayment to group dev_redshiftcoredevgroup;


