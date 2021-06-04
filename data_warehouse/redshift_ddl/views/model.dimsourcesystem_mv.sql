CREATE  MATERIALIZED VIEW model.dimsourcesystem diststyle ALL sortkey (sourcesystemnk)
AS
WITH alsacsystems
AS
(SELECT 'noble' AS sourcesystemnk,
       'noble' AS sourcesystemdescription,
       NULL AS vendortype,
       1 AS statusindicator UNION ALL SELECT 'incontact' AS sourcesystemnk,
       'incontact' AS sourcesystemdescription,
       NULL AS vendortype,
       1 AS statusindicator UNION ALL SELECT 'sal' AS sourcesystemnk,
       'save-a-life' AS sourcesystemdescription,
       NULL AS vendortype,
       1 AS statusindicator UNION ALL SELECT 'dms' AS sourcesystemnk,
       'donor management system' AS sourcesystemdescription,
       NULL AS vendortype,
       1 AS statusindicator UNION ALL SELECT 'ta' AS sourcesystemnk,
       'team approach' AS sourcesystemdescription,
       NULL AS vendortype,
       1 AS statusindicator UNION ALL SELECT 'payment archive' AS sourcesystemnk,
       'records from rank21/donors not in i360/dms' AS sourcesystemdescription,
       NULL AS vendortype,
       1 AS statusindicator UNION ALL SELECT LTRIM(RTRIM(vendor_code)) AS sourcesystemnk,
       LTRIM(RTRIM(vendor_description)) AS sourcesystemdescription,
       LTRIM(RTRIM(vendor_type)) AS vendortype,
       CASE
         WHEN sts = 'a' THEN 1
         ELSE 0
       END AS statusindicator
FROM callctr.vendor_codes) 
     SELECT xref.sourcesystemsk AS sourcesystemsk,stg.sourcesystemnk,stg.sourcesystemdescription,stg.vendortype,stg.statusindicator 
     FROM alsacsystems stg
  LEFT JOIN xref.dimsourcesystem xref ON xref.sourcesystemnk = stg.sourcesystemnk
UNION ALL
SELECT -1 AS sourcesystemsk,
       'unk' AS sourcesystemnk,
       'unknown' AS sourcesystemdescription,
       'unk' AS vendortype,
       1 AS statusindicator;

GRANT SELECT ON model.dimsourcesystem TO dev_redshiftcorereadgroup;
GRANT REFERENCES, SELECT, DELETE, UPDATE, TRIGGER, RULE, INSERT ON model.dimsourcesystem TO dev-datawarehouse-core-master-user;
GRANT SELECT ON model.dimsourcesystem TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimsourcesystem TO dev_redshiftcoredevgroup;


