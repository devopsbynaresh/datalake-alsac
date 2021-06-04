create  MATERIALIZED VIEW model.dimproject diststyle all
AS
SELECT x.projectsk AS projectsk,
       p.id AS dmsprojectnk,
       p.project AS projectcode,
       p.description AS projectdescription,
       p.active AS activeindicator
FROM dms.usr_project p
  LEFT OUTER JOIN xref.dimproject x ON x.dmsprojectnk = p.id;

GRANT SELECT ON model.dimproject TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimproject TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimproject TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimproject TO dev_redshiftcoredevgroup;


