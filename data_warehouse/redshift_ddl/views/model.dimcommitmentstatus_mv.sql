CREATE MATERIALIZED VIEW model.dimcommitmentstatus
AS
WITH statuscode
AS
(SELECT DISTINCT statuscode AS commitmentstatusnk,
       status AS commitmentstatusdescription
FROM dms.REVENUESCHEDULE) 
     SELECT x.commitmentstatussk AS commitmentstatussk,st.commitmentstatusnk AS commitmentstatusnk,st.commitmentstatusdescription AS commitmentstatusdescription 
     FROM statuscode st
  LEFT OUTER JOIN xref.dimcommitmentstatus x ON x.commitmentstatusnk = st.commitmentstatusnk;

