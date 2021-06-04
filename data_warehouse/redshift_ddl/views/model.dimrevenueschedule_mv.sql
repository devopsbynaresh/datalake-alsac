CREATE MATERIALIZED VIEW model.dimrevenueschedule
AS
SELECT x.revenueschedulesk AS revenueschedulesk,
       rs.id AS dmsrevenueschedulenk,
       rs.frequencycode AS frequencycode,
       rs.frequency AS frequency,
       rs.startdate AS startdate,
       rs.enddate AS enddate,
       rs.numberofinstallments AS numberofinstallments,
       rs.nexttransactiondate AS nextinstallmentdate,
       rs.statuscode AS statuscode,
       rs.status AS status,
       rs.id AS changedmsrevenuescheduleid
FROM dms.revenueschedule AS rs
  LEFT OUTER JOIN xref.dimrevenueschedule AS x ON x.dmsrevenueschedulenk = rs.id
UNION
SELECT- 1 AS revenueschedulesk,
       CAST(CAST(0 AS VARCHAR(8)) AS VARCHAR(36)) AS dmsrevenueschedulenk,
       NULL AS frequencycode,
       'UNKNOWN' AS frequency,
       NULL AS startdate,
       NULL AS enddate,
       NULL AS numberofinstallments,
       NULL AS nextinstallmentdate,
       NULL AS statuscode,
       'UNKNOWN' AS status,
       NULL AS changedmsrevenuescheduleid;

