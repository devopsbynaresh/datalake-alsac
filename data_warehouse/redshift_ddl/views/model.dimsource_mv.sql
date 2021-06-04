CREATE MATERIALIZED VIEW model.dimsource diststyle ALL
AS
SELECT sx.sourcesk AS sourcesk,
       s.source AS attributionsourcenk,
       s.description AS sourcedescription,
       s.activity AS sourceactivity,
       s.campaign AS sourcecampaign,
       s.initiative AS sourceinitiative,
       s.effort AS sourceeffort,
       s.fund_type AS sourcefundtype,
       s.activity_type AS sourceactivitytype,
       s.group_type AS sourcegrouptype,
       s.station_support AS sourcestationsupport,
       s.fund AS sourcefund,
       s.debit_account AS sourcedebitaccount,
       s.credit_account AS sourcecreditaccount,
       s.office AS sourceoffice,
       s.staff AS sourcestaff,
       s.solicitor AS sourcesolicitor,
       s.technique AS sourcetechnique,
       s.mail_date AS sourcemaildate,
       s.package AS sourcepackage,
       s.list AS sourcelist,
       s.test_code AS sourcetestcode,
       s.test_cell AS sourcetestcell,
       s.ack_code AS sourceackcode,
       s.project AS sourceproject,
       s.purpose AS sourcepurpose,
       s."event" AS sourceevent,
       s.interest_1 AS sourceinterest1,
       s.interest_2 AS sourceinterest2,
       s.interest_3 AS sourceinterest3,
       s.gift_type AS sourcegifttype,
       s.target_payment_amount AS sourcetargetpaymentamount,
       s.target_payment_number AS sourcetargetpaymentnumber,
       s.target_pledge_amount AS sourcetargetpledgeamount,
       s.target_pledge_number AS sourcetargetpledgenumber,
       s.actual_payment_amount AS sourceactualpaymentamount,
       s.actual_payment_number AS sourceactualpaymentnumber,
       s.actual_pledge_amount AS sourceactualpledgeamount,
       s.actual_pledge_number AS sourceactualpledgenumber,
       s.response_start_date AS sourceresponsestartdate,
       s.response_end_date AS sourceresponseenddate,
       s.number_solicitations AS sourcenumberofsolicitations,
       s.cost_per_solicitation AS sourcecostpersolicitation,
       s.number_contacts AS sourcenumberofcontacts,
       s.cost_per_contact AS sourcecostpercontact,
       s.total_cost AS sourcetotalcost,
       s.break_type AS sourcebreaktype,
       s.break_start_date AS sourcebreakstartdate,
       s.break_start_time AS sourcebreakstarttime,
       s.break_end_date AS sourcebreakenddate,
       s.break_end_time AS sourcebreakendtime,
       s.break_duration_planned AS sourcebreakdurationplanned,
       s.break_location AS sourcebreaklocation,
       s.break_duration_actual AS sourcebreakdurationactual,
       s.estimated_pledge_amount AS sourceestimatedpledgeamount,
       s.estimated_pledge_number AS sourceestimatedpledgenumber,
       s.talent AS sourcetalent,
       s.program AS sourceprogram,
       s.program_showing AS sourceprogramshowing,
       s.program_source AS sourceprogramsource,
       s.volunteer_group AS sourcevolunteergroup,
       s."location" AS sourcelocation,
       s.segment_type AS sourcesegmenttype,
       s.create_interactions AS sourcecreateinteractions,
       s.source_analysis_rule AS sourceanalysisrule,
       s.auto_popup_flag AS sourceautopopupflag,
       s.goto_field AS sourcegotofield,
       s.sts AS sourcestatusdescription,
       s.date_inserted AS sourcedateinserted,
       s.user_inserting AS sourceuserinserting,
       s.date_updated AS sourcedateupdated,
       s.user_updating AS sourceuserupdating,
       s.payment_start_date AS sourcepaymentstartdate,
       s.payment_end_date AS sourcepaymentenddate,
       s.pledge_start_date AS sourcepledgestartdate,
       s.pledge_end_date AS sourcepledgeenddate,
       s.ask_amount_rules AS sourceaskamountrules,
       s.joint_source AS sourcejointsource,
       s.seed_groups AS sourceseedgroups,
       s.default_filename AS sourcedefaultfilename,
       s.program_end_date_time AS sourceprogramenddatetime,
       s.offer_amount AS sourceofferamount,
       s.data_processing_cost AS sourcedataprocessingcost,
       s.list_cost AS sourcelistcost,
       s.package_cost AS sourcepackagecost,
       s.postage_cost_per_piece AS sourcepostagecostperpiece,
       s.retest_cost AS sourceretestcost,
       s.rollout_cost AS sourcerolloutcost,
       s.rollout_postage_cost_per_piece AS sourcerolloutpostagecostperpiece,
       s.rollout_product_cost_per_piece AS sourcerolloutproductcostperpiece,
       CASE
         WHEN LEFT (s.source,1) = 'G' THEN 1
         ELSE 0
       END AS giftplanningindicator,
       CASE
         WHEN LEFT (s.source,2) IN ('NN','ND') THEN 1
         ELSE 0
       END AS nnorndindicator,
       CASE
         WHEN LEFT (s.source,3) IN ('THT','THH') THEN 1
         ELSE 0
       END AS thtorthhindicator,
       CASE
         WHEN LEFT (s.source,3) = 'NNV' THEN 1
         ELSE 0
       END AS nnvindicator,
       CASE
         WHEN LEFT (s.source,3) = 'NNF' THEN 1
         ELSE 0
       END AS nnfindicator,
       CASE
         WHEN LEFT (s.source,7) = 'FEPH001' THEN 1
         ELSE 0
       END AS lafashionindicator,
       CASE
         WHEN sjpii.parametervalue IS NULL THEN 0
         ELSE 1
       END AS sjpiiacquisitionindicator,
       CASE
         WHEN genome.parametervalue IS NULL THEN 0
         ELSE 1
       END AS genomeresponderindicator,
       CASE
         WHEN LEFT (s.source,1) = 'F' AND SUBSTRING(s.source,2,1) IN ('E','C') AND SUBSTRING(s.source,3,1) = 'U' THEN 1
         ELSE 0
       END AS uptilldawnindicator,
       /* rename --c.utd_gift -- removed regex -- Find source codes that start with 'F', have 'E' or 'C' for the second character, and a */ CASE
         WHEN s.source SIMILAR TO 'V[A|B|H|J|K|L|M|N|O|P|T|Y]%' OR s.source LIKE 'FK%' THEN 1
         ELSE 0
       END AS vsceventindicator,
       0 AS brickgiftindicator,--Hard coding this for POC. On Prem it is a call to UDF which calls a CRL Function
       CASE
         WHEN SUBSTRING(s.source,1,3) IN ('ORQ','OUQ','OOQ') THEN 1
         ELSE 0
       END AS radioindicator,
       CASE
         WHEN SUBSTRING(s.source,1,3) IN ('OSQ') THEN 1
         ELSE 0
       END AS radiohispanicindicator,
       CASE
         WHEN SUBSTRING(s.source,1,3) IN ('NTT','NTC') THEN 1
         ELSE 0
       END AS dmtvindicator,
       CASE
         WHEN SUBSTRING(s.source,1,3) IN ('NTH') THEN 1
         ELSE 0
       END AS dmtvhispanicindicator,
       uis.id AS dmssourcecodeid
FROM attribution.sources AS s
  LEFT OUTER JOIN bietl.martviewparameters AS sjpii
               ON sjpii.parametervalue = s.source
              AND sjpii.parametername = 'GSJPIIACQSOURCES'
  LEFT OUTER JOIN bietl.martviewparameters AS genome
               ON genome.parametervalue = s.source
              AND genome.parametername = 'GGENOMERESPONDERS'
  LEFT OUTER JOIN dms.usr_interactionsourcetypecode AS uis ON (uis.description = (s.source ||COALESCE (': ' || s.description,'')))
  LEFT OUTER JOIN bietl.martviewparameters AS gbrick ON gbrick.parametername = 'GBRICKSOURCES'
  LEFT OUTER JOIN xref.dimsource AS sx ON sx.attributionsourcenk = s.source
UNION
SELECT -1 AS sourcesk,
       '-1' AS attributionsourcenk,
       'UNKNOWN' AS sourcedescription,
       '-1' AS sourceactivity,
       NULL AS sourcecampaign,
       NULL AS sourceinitiative,
       NULL AS sourceeffort,
       NULL AS sourcefundtype,
       NULL AS sourceactivitytype,
       NULL AS sourcegrouptype,
       NULL AS sourcestationsupport,
       NULL AS sourcefund,
       NULL AS sourcedebitaccount,
       NULL AS sourcecreditaccount,
       NULL AS sourceoffice,
       NULL AS sourcestaff,
       NULL AS sourcesolicitor,
       NULL AS sourcetechnique,
       NULL AS sourcemaildate,
       NULL AS sourcepackage,
       NULL AS sourcelist,
       NULL AS sourcetestcode,
       NULL AS sourcetestcell,
       NULL AS sourceackcode,
       NULL AS sourceproject,
       NULL AS sourcepurpose,
       NULL AS sourceevent,
       NULL AS sourceinterest1,
       NULL AS sourceinterest2,
       NULL AS sourceinterest3,
       NULL AS sourcegifttype,
       NULL AS sourcetargetpaymentamount,
       NULL AS sourcetargetpaymentnumber,
       NULL AS sourcetargetpledgeamount,
       NULL AS sourcetargetpledgenumber,
       NULL AS sourceactualpaymentamount,
       NULL AS sourceactualpaymentnumber,
       NULL AS sourceactualpledgeamount,
       NULL AS sourceactualpledgenumber,
       NULL AS sourceresponsestartdate,
       NULL AS sourceresponseenddate,
       NULL AS sourcenumberofsolicitations,
       NULL AS sourcecostpersolicitation,
       NULL AS sourcenumberofcontacts,
       NULL AS sourcecostpercontact,
       NULL AS sourcetotalcost,
       NULL AS sourcebreaktype,
       NULL AS sourcebreaksartdate,
       NULL AS sourcebreakstarttime,
       NULL AS sourcebreakenddate,
       NULL AS sourcebreakendtime,
       NULL AS sourcebreakdurationplanned,
       NULL AS sourcebreaklocation,
       NULL AS sourcebreakdurationactual,
       NULL AS sourceestimatedpledgeamount,
       NULL AS sourceestimatedpledgenumber,
       NULL AS sourcetalent,
       NULL AS sourceprogram,
       NULL AS sourceprogramshowing,
       NULL AS sourceprogramsource,
       NULL AS sourcevolunteergroup,
       NULL AS sourcelocation,
       NULL AS sourcesegmenttype,
       NULL AS sourcecreateinteractions,
       NULL AS sourceanalysisrule,
       NULL AS sourceautopopupflag,
       NULL AS sourcegotofield,
       NULL AS sourcestatusdescription,
       NULL AS sourcedateinserted,
       NULL AS sourceuserinserting,
       NULL AS sourcedateupdated,
       NULL AS sourceuserupdating,
       NULL AS sourcepaymentstartdate,
       NULL AS sourcepaymentenddate,
       NULL AS sourcepledgestartdate,
       NULL AS sourcepledgeenddate,
       NULL AS sourceaskamountrules,
       NULL AS sourcejointsource,
       NULL AS sourceseedgroups,
       NULL AS sourcedefaultfilename,
       NULL AS sourceprogramenddatetime,
       NULL AS sourceofferamount,
       NULL AS sourcedataprocessingcost,
       NULL AS sourcelistcost,
       NULL AS sourcepackagecost,
       NULL AS sourcepostagecostperpiece,
       NULL AS sourceretestcost,
       NULL AS sourcerolloutcost,
       NULL AS sourcerolloutpostagecostperpiece,
       NULL AS sourcerolloutproductcostperpiece,
       NULL AS giftplanningindicator,
       NULL AS nnorndindicator,
       NULL AS thtorthhindicator,
       NULL AS nnvindicator,
       NULL AS nnfindicator,
       NULL AS lafashionindicator,
       NULL AS sjpiiacquisitionindicator,
       NULL AS genomeresponderindicator,
       NULL AS uptilldawnindicator,
       NULL AS vsceventindicator,
       NULL AS brickgiftindicator,
       NULL AS radioindicator,
       NULL AS radiohispanicindicator,
       NULL AS dmtvindicator,
       NULL AS dmtvhispanicindicator,
       NULL AS dmssourcecodeid;

GRANT SELECT ON model.dimsource TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimsource TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimsource TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimsource TO dev_redshiftcoredevgroup;


