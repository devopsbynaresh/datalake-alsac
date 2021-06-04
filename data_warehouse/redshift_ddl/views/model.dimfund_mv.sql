CREATE  MATERIALIZED VIEW  model.dimfund diststyle all AS
SELECT
    x.fundsk AS fundsk,/* m.fundsk AS fundsk,*/ f.fund AS attributionfundnk, f.description AS funddescription, f.fund_group AS fundgroup, f.fund_type AS fundtype, ft."description" AS fundtypedescription, f.sts AS fundstatus, ft.sts AS fundtypestatus, f.fund_type AS changeattributionfundfund_type, ft.fund_type AS changeattributionfund_typefund_type
    FROM attribution.fund AS f
    LEFT OUTER JOIN attribution.fund_type AS ft
        ON ft.fund_type = f.fund_type
    LEFT OUTER JOIN xref.dimfund AS x
        ON x.attributionfundnk = f.fund
--    LEFT OUTER JOIN model.dimfund AS m
--        ON m.attributionfundnk = f.fund
UNION
SELECT
    - 1 AS xreffundsk, /*- 1 AS fundsk,*/ '-1' AS attributionfundnk, 'Unknown' AS funddescription, NULL AS fundgroup, NULL AS fundtype, NULL AS fundtypedescription, NULL AS fundstatus, NULL AS fundtypestatus, 'UNKNOWN' AS changeattributionfundfund_type, 'UNKNOWN' AS changeattributionfund_typefund_type;

GRANT SELECT ON model.dimfund TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimfund TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimfund TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimfund TO dev_redshiftcoredevgroup;


