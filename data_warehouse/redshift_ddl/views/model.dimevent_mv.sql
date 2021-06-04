CREATE MATERIALIZED VIEW model.dimevent diststyle ALL
AS
SELECT x.eventsk AS eventsk,
       e.eventid AS evmeventnk,
       e.city AS city,
       cc.costcenter AS costcenter,
       cc.costcenterdescription AS costcenterdescription,
       et.iseccrecruited AS eccrecruitedindicator,
       r.region AS eventregion,
       CAST(e.eventcode AS VARCHAR(60)) AS eventcode,
       e.eventname AS eventname,
       e.eventdescription AS eventdescription,
       et.eventtypename AS eventtypename,
       ep.eventprogram AS eventprogram,
       evm.eventmasterid AS eventmasterid,
       evm.eventmastername AS eventmastername,
       evm.eventmastercode AS eventmastercode,
       e.startdate AS eventstartdate,
       e.enddate AS eventenddate,
       e.fiscalyear AS eventfiscalyear,
       et.recruitedevent AS recruitedindicator,
       es.status AS statuscode,
       s.statecode AS state,
       x_et.referencevalue AS taeventtypecode,
       e.zipcode AS zipcode,
       e.eventid AS changeeventmastereventseventid,
       cc.costcenterid AS changeeventmastercostcentercostcenterid,
       et.eventtypeid AS changeeventmastereventtypeseventtypeid,
       es.statusid AS changeeventmasterstatusesstatusid,
       s.stateid AS changeeventmasterstatesstateid,
       r.regionid AS changeeventmasterregionregionid,
       ep.eventprogramid AS changeeventmastereventprogramseventprogramid,
       x_et.eventtypeid AS changeeventmasterevm_xrefeventtypeseventtypeid,
       evm.eventmasterid AS changeeventmastereventmasterseventmasterid
FROM eventmaster.events AS e
  LEFT OUTER JOIN eventmaster.costcenter AS cc ON cc.costcenterid = e.costcenterid
  LEFT OUTER JOIN eventmaster.eventtypes AS et ON et.eventtypeid = e.eventtypeid
  LEFT OUTER JOIN eventmaster.statuses AS es ON es.statusid = e.statusid
  LEFT OUTER JOIN eventmaster.states AS s ON s.stateid = e.stateid
  LEFT OUTER JOIN eventmaster.region AS r ON r.regionid = cc.regionid
  LEFT OUTER JOIN eventmaster.eventprograms AS ep ON ep.eventprogramid = et.eventprogramid
  LEFT OUTER JOIN evm_xref.eventtypes AS x_et
               ON x_et.eventtypeid = et.eventtypeid
              AND x_et.referencetablename = 'pbds.event_type'
              AND /* pull for ta */  NULLIF (x_et.referencevalue,'') IS NOT NULL
  LEFT OUTER JOIN eventmaster.eventmasters AS evm ON evm.eventmasterid = e.eventmasterid
  LEFT OUTER JOIN xref.dimevent AS x ON x.evmeventnk = e.eventid
UNION
SELECT- 1 AS eventsk,
       CAST(CAST(0 AS VARCHAR(8)) AS VARCHAR(36)) AS evmeventnk,
       NULL AS city,
       NULL AS costcenter,
       'unknown' AS costcenterdescription,
       NULL AS eccrecruitedindicator,
       NULL AS eventregion,
       NULL AS eventcode,
       NULL AS eventname,
       'unknown' AS eventdescription,
       NULL AS eventtypename,
       NULL AS eventprogram,
       CAST(CAST(0 AS VARCHAR(8)) AS VARCHAR(36)) AS eventmasterid,
       NULL AS eventmastername,
       NULL AS eventmastercode,
       NULL AS eventstartdate,
       NULL AS eventenddate,
       NULL AS eventfiscalyear,
       NULL AS recruitedindicator,
       NULL AS statuscode,
       NULL AS "state",
       NULL AS taeventtypecode,
       NULL AS zipcode,
       NULL AS changeeventmastereventseventid,
       NULL AS changeeventmastercostcentercostcenterid,
       NULL AS changeeventmastereventtypeseventtypeid,
       NULL AS changeeventmasterstatusesstatusid,
       NULL AS changeeventmasterstatesstateid,
       NULL AS changeeventmasterregionregionid,
       NULL AS changeeventmastereventprogramseventprogramid,
       NULL AS changeeventmasterevm_xrefeventtypeseventtypeid,
       NULL AS changeeventmastereventmasterseventmasterid;

GRANT SELECT ON model.dimevent TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimevent TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimevent TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimevent TO dev_redshiftcoredevgroup;


