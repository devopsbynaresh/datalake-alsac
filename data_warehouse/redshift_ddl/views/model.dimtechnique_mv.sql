CREATE  MATERIALIZED VIEW model.dimtechnique diststyle all
AS
SELECT x.techniquesk AS techniquesk,
       t.id AS dmstechniquenk,
       t.description AS techniquedescription,
       CAST(CASE WHEN t.description LIKE '%:%' THEN LTRIM(RTRIM(SUBSTRING((t.description),0,CHARINDEX (':',(t.description))))) ELSE '' END AS VARCHAR(12)) AS techniquecode,
       CASE LEFT (t.description,3)
         WHEN 'CT:' THEN 1
         ELSE 0
       END AS calltoaccountindicator,
       CASE LEFT (t.description,3)
         WHEN 'EF:' THEN 1
         ELSE 0
       END AS emailindicator,
       CASE LEFT (t.description,3)
         WHEN 'MF:' THEN 1
         ELSE 0
       END AS mailindicator,
       CASE LEFT (t.description,3)
         WHEN 'OL:' THEN 1
         ELSE 0
       END AS onlinedonationindicator,
       CASE LEFT (t.description,3)
         WHEN 'RP:' THEN 1
         ELSE 0
       END AS reportindicator,
       CASE LEFT (t.description,3)
         WHEN 'TM:' THEN 1
         ELSE 0
       END AS telemarketingindicator,
       CASE LEFT (t.description,3)
         WHEN 'CF:' THEN 1
         ELSE 0
       END AS telephonecallindicator
FROM dms.interactiontypecode AS t
  LEFT OUTER JOIN xref.dimtechnique AS x ON x.dmstechniquenk = t.id
UNION
SELECT- 1 AS xreftechniquesk,
       CAST(CAST(0 AS VARCHAR(8)) AS VARCHAR(36)) AS dmstechniquenk,
       'UNKNOWN' AS techniquedescription,
       NULL AS techniquecode,
       NULL AS calltoaccountindicator,
       NULL AS emailindicator,
       NULL AS mailindicator,
       NULL AS onlinedonationindicator,
       NULL AS reportindicator,
       NULL AS telemarketingindicator,
       NULL AS telephonecallindicator;

GRANT SELECT ON model.dimtechnique TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimtechnique TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimtechnique TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimtechnique TO dev_redshiftcoredevgroup;


