CREATE  MATERIALIZED VIEW model.dimcostcenter diststyle all
AS
SELECT cx.costcentersk AS costcentersk,
       cs.cost_center AS c360costcenternk,
       cs.description AS costcenterdescription,
       cs.region AS costcenterregion,
       cs.region_code AS costcenterregioncode,
       cs.market_identifier AS costcentermarketidentifier
FROM mdm.alsac_cost_centers cs
  LEFT OUTER JOIN xref.dimcostcenter cx ON cx.c360costcenternk = cs.cost_center
UNION
SELECT -1 AS costcentersk,
       '-1' AS c360costcenternk,
       'unknown' AS costcenterdescription,
       NULL AS costcenterregion,
       NULL AS costcenterregioncode,
       NULL AS costcentermarketidentifier;

GRANT SELECT ON model.dimcostcenter TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimcostcenter TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimcostcenter TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimcostcenter TO dev_redshiftcoredevgroup;


