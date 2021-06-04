CREATE  MATERIALIZED VIEW model.dimattribution diststyle ALL sortkey (attributionsk)
AS
SELECT DISTINCT 
       xrefdimeffort.attributionsk AS attributionsk,
       a.activity AS attributionactivitynk,
       nvl(c.campaign,'') AS attributioncampaignnk,
       nvl(i.initiative,'') AS attributioninitiativenk,
       nvl(e.effort,'') AS attributioneffortnk,
       a.credit_account AS attributionactivitycreditaccount,
       a.activity AS attributionactivitytype,
       a."description" AS attributionactivitydescription,
       c."description" AS attributioncampaigndescription,
       i."description" AS attributioninitiativedescription,
       e."description" AS attributioneffortdescription,
       a.activity || c.campaign AS attributionactivitycampaigncombination,
       CASE
         WHEN a.activity IN ('aa','mh','mm','nc','nd','ng','nh','nn','nq','ns','nt') OR (a.activity = 'ii' AND c.campaign NOT IN ('g','f')) THEN 'ndm'
         WHEN LEFT (a.activity,1) IN ('f','o','v') OR /* this is a catch all for field and ecc/vsc giving. since, in the past, field has not been consistent in communicating when a new activity is created, this will catch any aberrant activities */ (a.activity = 'ii' AND c.campaign = 'f') OR COALESCE(a.activity,'-1') IN ('-1','70','qq','mg') OR a.activity = 'cs' THEN /* this is some hispanic radio that last had an op gift prior to fy16 land has residual pledge revenue. the gl codes tied to these mostly correlate to field */  'field' /* null as prior vsc/ecc events, 70 is a miscode, ok is a new radio event, qq is field white mail (formerly ndm white mail), mg is music gives, and va and vb are some vsc/ecc events */ 
         WHEN LEFT (a.activity,1) = 'g' OR /* this is a catch all for gift planning */ (a.activity = 'ii' AND c.campaign = 'g') THEN 'gift planning'
         WHEN a.activity = 'th' OR a.activity = 'cm' THEN 'strategic partnerships'
         ELSE 'other' /* this is a catch all for activities that do not match the above rules or are gifts from non-development divisions */ 
       END AS department,
       CASE
         WHEN a.activity IN ('aa','nn','mm','mh','nc','nd','nq','ns','nt','ii','ng','nh') THEN 1
         ELSE 0
       END AS dmactivityindicator,
       CASE
         WHEN a.activity = 'ii' THEN 1
         WHEN a.activity IN ('mm','mh') AND c.campaign = 'i' THEN 1
         ELSE 0
       END AS dmonlineindicator,
       1 AS dmindicator,
       1 AS appealactivityindicator,
       1 AS appealactivitycampaignindicator,
       CASE
         WHEN a.activity || c.campaign IN ('nne','nna') THEN 1
         ELSE 0
       END AS actvitycampaignnneornnaindicator,
       CASE
         WHEN a.activity = 'sc' AND c.campaign IN ('h','d') AND i.initiative = 'lcar' THEN 1
         ELSE 0
       END AS ladiesofsaintjudeindicator,
       CASE
         WHEN a.activity IN ('mm','mh') THEN 1
         ELSE 0
       END AS tributeindicator,
       CASE
         WHEN c.campaign IN ('q') AND a.activity IN ('nd','ns','aa','gg') THEN 1
         ELSE 0
       END AS mailacquisitionactivitycampaignindicator,
       CASE
         WHEN a.activity = 'nn' AND c.campaign = 'f' THEN 1
         ELSE 0
       END AS fafindicator,
       CASE
         WHEN a.activity = 'nt' AND c.campaign IN ('c','t') THEN 1
         ELSE 0
       END AS televisionindicator,
       CASE
         WHEN a.activity = 'nt' AND c.campaign IN ('h','e') THEN 1
         ELSE 0
       END AS hispanictelevisionindicator,
       CASE
         WHEN (a.activity != 'nn' OR nvl (c.campaign,'') != 'f') THEN 0
         ELSE 1
       END AS nnfindicator,
       a.activity AS changeattributionactivitiesactivity,
       c.campaign AS changeattributioncampaignscampaign,
       i.initiative AS changesattributioninitiativesinitiative,
       e.effort AS changeattributioneffortseffort
FROM attribution.activities AS a
  LEFT OUTER JOIN (SELECT activity,
                          campaign,
                          description
                   FROM attribution.campaigns
                   UNION
                   SELECT activity,
                          '',
                          NULL
                   FROM attribution.activities) AS c ON c.activity = a.activity
  LEFT OUTER JOIN (SELECT activity,
                          campaign,
                          initiative,
                          description
                   FROM attribution.initiatives
                   UNION
                   SELECT activity,
                          campaign,
                          '',
                          NULL
                   FROM attribution.campaigns) AS i
               ON i.activity = a.activity
              AND nvl (i.campaign,'') = nvl (c.campaign,'')
  LEFT OUTER JOIN (SELECT activity,
                          campaign,
                          initiative,
                          effort,
                          description
                   FROM attribution.efforts
                   UNION
                   SELECT activity,
                          campaign,
                          initiative,
                          '',
                          NULL
                   FROM attribution.initiatives) AS e
               ON e.activity = a.activity
              AND nvl (c.campaign,'') = nvl (e.campaign,'')
              AND nvl (i.initiative,'') = nvl (e.initiative,'')
  LEFT OUTER JOIN xref.dimattribution AS xrefdimeffort
               ON a.activity = xrefdimeffort.attributionactivitynk
              AND nvl (c.campaign,'') = nvl (xrefdimeffort.attributioncampaignnk,'')
              AND nvl (i.initiative,'') = nvl (xrefdimeffort.attributioninitiativenk,'')
              AND nvl (e.effort,'') = nvl (xrefdimeffort.attributioneffortnk,'')
UNION
SELECT- 1 AS attributionsk,
       '-1' AS attributionactivitynk,
       '-1' AS attributioncampaignnk,
       '-1' AS attributioninitiativenk,
       '-1' AS attributioneffortnk,
       'unknown' AS attributionactivitycreditaccount,
       'unk' AS attributionactivitytype,
       'unknown' AS attributionactivitydescription,
       'unknown' AS attributioncampaigndescription,
       'unknown' AS attributioninitiativedescription,
       'unknown' AS attributioneffortdescription,
       NULL AS attributionactivitycampaigncombination,
       'field' AS department,
       NULL AS dmactivityindicator,
       NULL AS dmonlineindicator,
       NULL AS dmindicator,
       NULL AS appealactivityindicator,
       NULL AS appealactivitycampaignindicator,
       NULL AS actvitycampaignnneornnaindicator,
       NULL AS ladiesofsaintjudeindicator,
       - 1 AS tributeindicator,
       NULL AS mailacquisitionactivitycampaignindicator,
       - 1 AS fafindicator,
       NULL AS televisionindicator,
       NULL AS hispanictelevisionindicator,
       NULL AS nnfindicator,
       NULL AS changeattributionactivitiesactivity,
       NULL AS changeattributioncampaignscampaign,
       NULL AS changesattributioninitiativesinitiative,
       NULL AS changeattributioneffortseffort;

GRANT SELECT ON model.dimattribution TO dev_redshiftcorereadgroup;
GRANT REFERENCES, SELECT, DELETE, UPDATE, TRIGGER, RULE, INSERT ON model.dimattribution TO dev-datawarehouse-core-master-user;
GRANT SELECT ON model.dimattribution TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimattribution TO dev_redshiftcoredevgroup;


