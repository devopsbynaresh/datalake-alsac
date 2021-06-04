CREATE MATERIALIZED VIEW model.dimtribute diststyle ALL
AS
WITH tribute
AS
(SELECT *
FROM (SELECT ROW_NUMBER() OVER (PARTITION BY tributeid ORDER BY pfporder.createddate NULLS FIRST,pfporder.pfporderid DESC NULLS FIRST) AS rn,
             tributeid,
             pfporder.pfporderid,
             productdedication.productdedicationid AS productdedicationid,
             pfporder.dedicationtypeid,
             productdedication.description,
             productdedication.productdedicationcode,
             pfporder.comment,
             pfporder.createddate,
             pfporder.createdby,
             pfporder.updatedby,
             pfporder.updateddate
      FROM pfp.pfporder AS pfporder
        LEFT OUTER JOIN pfp.productdedication AS productdedication ON pfporder.dedicationtypeid = productdedication.productdedicationid
      WHERE tributeid IS NOT NULL) AS a
WHERE a.rn = 1) SELECT x.tributesk AS tributesk,t.tributeid AS pfptributeidnk,t.pfporderid AS pfporderid,t.dedicationtypeid AS dedicationtypeid,t.description AS dedicationtype,t.productdedicationcode AS dedicationtypecode,t.comment AS tributecomments,t.createddate AS tributeestablishdate,t.createdby AS createdby,t.updatedby AS updatedby,t.updateddate AS updateddate FROM tribute AS t LEFT OUTER JOIN xref.dimtribute AS x ON t.tributeid = x.pfptributeidnk;

GRANT SELECT ON model.dimtribute TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimtribute TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimtribute TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimtribute TO dev_redshiftcoredevgroup;


