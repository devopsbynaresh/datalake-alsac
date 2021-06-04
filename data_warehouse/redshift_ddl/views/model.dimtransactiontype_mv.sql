CREATE MATERIALIZED VIEW model.dimtransactiontype diststyle all
AS
WITH distinctcodes
AS (SELECT DISTINCT
    rse.applicationcode,
    ft.typecode,
    ft.type,
    rse.application
    /* Behaving differently based on the plans, we have to scan the whole table everytime anyways so a hash table should be fine, maybe indexes are better, I'd really like a lookup table */
    FROM dms.financialtransaction AS ft
    INNER JOIN dms.financialtransactionlineitem AS ftli
        ON ft.id = ftli.financialtransactionid
    INNER JOIN dms.revenuesplit_ext AS rse
        ON ftli.id = rse.id
    GROUP BY rse.applicationcode, ft.typecode, ft.type, rse.application)
SELECT
    x.transactiontypesk AS transactiontypesk,
    dc.typecode AS typecodenk,
    dc.type AS typecodedescription,
    dc.applicationcode AS applicationcodenk,
    dc.application AS applicationdescription,
    CASE
        WHEN dc.typecode = 0 THEN 1
        ELSE 0
    END AS paymentindicator,
    CASE
        WHEN dc.typecode = 1 THEN 1
        ELSE 0
    END AS pledgeindicator,
    CASE
        WHEN dc.typecode = 2 THEN 1
        ELSE 0
    END AS recurringgiftindicator,
    CASE
        WHEN dc.typecode = 3 THEN 1
        ELSE 0
    END AS matchinggiftindicator,
    /* GF - DonationIndicator */
    /* OP -  OneTimePaymentIndicator */
    /* PP  - InstallmentPaymentIndicator */
    /* SP - SustainingPaymentIndicator */
    CASE
        WHEN dc.typecode = 0 AND dc.applicationcode IN (0, 1, 4) THEN 1
        ELSE 0
    END AS donationindicator,
    CASE
        WHEN dc.typecode = 0 AND dc.applicationcode NOT IN (3) THEN 1
        ELSE 0
    END AS onetimepaymentindicator,
    CASE
        WHEN dc.typecode = 0 AND dc.applicationcode NOT IN (0, 1, 4) THEN 1
        ELSE 0
    END AS installmentpaymentindicator,
    CASE
        WHEN dc.typecode = 0 AND dc.applicationcode IN (3) THEN 1
        ELSE 0
    END AS sustainingpaymentindicator
    FROM distinctcodes AS dc
    LEFT OUTER JOIN xref.dimtransactiontype AS x
        ON x.applicationcodenk = dc.applicationcode AND 
        x.typecodenk = dc.typecode
    WHERE dc.type is not null;

GRANT SELECT ON model.dimtransactiontype TO dev_redshiftcorereadgroup;
GRANT REFERENCES, SELECT, DELETE, UPDATE, TRIGGER, RULE, INSERT ON model.dimtransactiontype TO dev-datawarehouse-core-master-user;
GRANT SELECT ON model.dimtransactiontype TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimtransactiontype TO dev_redshiftcoredevgroup;


