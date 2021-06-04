CREATE  MATERIALIZED VIEW model.dimledgeraccount diststyle all
AS
SELECT DISTINCT gx.ledgeraccountsk AS ledgeraccountsk,
       gl.segment2 AS ledgeraccountnk,
       gl.account_type AS accounttype,
       tl.description AS ledgeraccountdescription
FROM fusion.gl_code_combinations AS gl
  INNER JOIN fusion.fnd_vs_values_b AS b ON b.value = gl.segment2
  INNER JOIN fusion.fnd_vs_values_tl AS tl ON tl.value_id = b.value_id
  LEFT OUTER JOIN xref.dimledgeraccount AS gx ON gx.ledgeraccountnk = gl.segment2
WHERE b.attribute_category = 'COA_ACCOUNT'
UNION
SELECT- 1 AS ledgeraccountsk,
       '-1' AS ledgeraccountnk,
       '-1' AS accounttype,
       'UNKNOWN' AS ledgeraccountdescription;

GRANT SELECT ON model.dimledgeraccount TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimledgeraccount TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimledgeraccount TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimledgeraccount TO dev_redshiftcoredevgroup;


