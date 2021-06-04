CREATE MATERIALIZED VIEW model.dimconstituent diststyle ALL AS
WITH alternatelookupid_ind
AS (SELECT
    xref.constituent_id, xref.xref_key, row_number() OVER (PARTITION BY xref.constituent_id ORDER BY xref.updated NULLS FIRST) AS rn
    FROM mdm.constituent_xref AS xref
    WHERE xref.system_id = 'e0c62670-7c67-4c60-9a46-8ad84e5a0fbe'), ind
AS (SELECT
    NULL AS constituentsk, NULL AS xrefconstituentsk, 'I' AS constituentcategory, i.constituent_id AS c360constituentnk,
    CASE
        WHEN CHARINDEX('|', xrefta.xref_key) > 0 THEN LEFT(xrefta.xref_key, CHARINDEX('|', xrefta.xref_key) - 1)
        ELSE NULL
    END AS accountid, i.preferred AS preferredindicator, 'agerange' AS agerange, i.anonymous_gift_account AS anonymousgiftindicator, 'birth_date' AS birthdate, 'birth_day' AS birthday, 'birth_month' AS birthmonth, 'birth_year' AS birthyear, altid.xref_key AS briefname, ci.channel_type AS channelinsertedby, cu.channel_type AS channelupdatedby, NULL AS deceaseddate, NULL AS deceasedday, 0 AS deceasedindicator, null AS deceasedmonth, null AS deceasedyear, consxref.key_1 AS dmslookupid, 
    'first_name' AS firstname,
    'full_name' AS fullname, 
    NULL AS gender, NULL AS individualcomments, s.description AS individualstatusdescription, i.updated AS individualupdateddate, 'last_name' AS lastname, 'maiden_name' AS maidenname, 'maritalstatus' AS maritalstatusdescription, 'middle_name' AS middlename, 'married_date' AS marriagedate,
    CASE
        WHEN CHARINDEX('|', xrefta.xref_key) > 0 THEN SUBSTRING(xrefta.xref_key, CHARINDEX('|', xrefta.xref_key) + 1, LENGTH(xrefta.xref_key))
        ELSE NULL
    END AS nameid, 0 AS numberofchildren, 0 AS numberofgrandchildren, CASE
        WHEN sltn.description IN ('None', 'Child') THEN 0
        ELSE 1
    END AS salutationindicator, sltn.description AS salutationdescription, i.staff AS staff, cs.description AS suffixdescription, Null AS titledescription, 'InferendaPID' AS inferendapid
    FROM mdm.individual AS i
    JOIN mdm.status AS s
        ON i.status_id = s.status_id
    LEFT OUTER JOIN mdm.household AS h
        ON i.constituent_id = h.constituent_id
    LEFT OUTER JOIN mdm.organization AS o
        ON i.constituent_id = o.constituent_id
    LEFT OUTER JOIN mdm.constituent_xref AS consxref
        ON i.constituent_id = consxref.constituent_id AND consxref.system_id = 'EC2372F7-AE4D-4447-99F6-A55E2E5FF5A6'
    LEFT OUTER JOIN mdm.constituent_type AS constype
        ON consxref.constituent_type_lookup_id = constype.constituent_type_lookup_id
    LEFT OUTER JOIN mdm.constituent_xref AS xrefta
        ON xrefta.constituent_id = i.constituent_id AND xrefta.system_id = '45481716-340B-42E1-8620-36C509557EE1'
    LEFT OUTER JOIN mdm.constituent_title AS ct
        ON i.constituent_title_lookup_id = ct.constituent_title_lookup_id
    LEFT OUTER JOIN mdm.salutation AS sltn
        ON i.salutation_id = sltn.salutation_id
    LEFT OUTER JOIN mdm.constituent_suffix AS cs
        ON cs.constituent_suffix_lookup_id = i.constituent_suffix_lookup_id
    LEFT OUTER JOIN alternatelookupid_ind AS altid
        ON altid.constituent_id = i.constituent_id AND altid.rn = 1
    LEFT OUTER JOIN mdm.channel AS ci
        ON i.channel_inserted_by = ci.channel_id
    LEFT OUTER JOIN mdm.channel AS cu
        ON i.channel_updated_by = cu.channel_id
    WHERE (h.constituent_id IS NULL AND o.constituent_id IS NULL) OR (constype."description" = 'Individual')), alternatelookupid_org
AS (SELECT
    xref.constituent_id, xref.xref_key, row_number() OVER (PARTITION BY xref.constituent_id ORDER BY xref.updated NULLS FIRST) AS rn
    FROM mdm.constituent_xref AS xref
    WHERE xref.system_id = 'e0c62670-7c67-4c60-9a46-8ad84e5a0fbe'), org
AS (SELECT
    NULL AS constituentsk, NULL AS xrefconstituentsk, COALESCE(o.constituent_id, NULL) AS c360constituentnk, 'O' AS constituentcategory, COALESCE(o.anonymous_gift_account, NULL) AS anonymousgiftindicator, altid.xref_key AS briefname, ci."description" AS channelinsertedby, cu."description" AS channelupdatedby, o.parent_org_id AS c360parentorganizationid,
    /* Rename */
    o.default_currency AS defaultcurrency, o.match_ratio AS matchratio, o.max_contribution AS maximumcontribution, o.max_matched AS maximummatched, o.min_contribution AS minimumcontribution, 0 AS numberofemployees, LEFT(o.comments, 256) AS organizationcomments, o.updated AS organizationdateupdated, 'orgname' AS organizationname, LEFT(s.description, 30) AS organizationstatusdescription,
    CASE
        WHEN CHARINDEX('|', xrefta.xref_key) > 0 THEN LEFT(xrefta.xref_key, CHARINDEX('|', xrefta.xref_key) - 1)
        ELSE NULL
    END AS accountid,
    CASE
        WHEN CHARINDEX('|', xrefta.xref_key) > 0 THEN COALESCE(SUBSTRING(xrefta.xref_key, CHARINDEX('|', xrefta.xref_key) + 1, LENGTH(xrefta.xref_key)), NULL)
        ELSE NULL
    END AS nameid, constituentxrefdmslookupid.key_1 AS dmslookupid, o.staff AS staff, NULL AS inferendapid
    FROM mdm.organization AS o
    JOIN mdm.status AS s
        ON o.status_id = s.status_id
    LEFT OUTER JOIN mdm.household AS h
        ON o.constituent_id = h.constituent_id
    LEFT OUTER JOIN mdm.individual AS i
        ON i.constituent_id = o.constituent_id
    LEFT OUTER JOIN mdm.constituent_xref AS xrefta
        ON xrefta.constituent_id = o.constituent_id AND xrefta.system_id = '45481716-340B-42E1-8620-36C509557EE1'
    LEFT OUTER JOIN mdm.channel AS ci
        ON o.channel_inserted_by = ci.channel_id
    LEFT OUTER JOIN mdm.channel AS cu
        ON o.channel_updated_by = cu.channel_id
    LEFT OUTER JOIN mdm.constituent_xref AS constituentxrefdmslookupid
        ON constituentxrefdmslookupid.constituent_id = o.constituent_id AND constituentxrefdmslookupid.system_id = 'EC2372F7-AE4D-4447-99F6-A55E2E5FF5A6'
    LEFT OUTER JOIN mdm.constituent_type AS constype
        ON constype.constituent_type_lookup_id = constituentxrefdmslookupid.constituent_type_lookup_id
    LEFT OUTER JOIN alternatelookupid_org AS altid
        ON altid.constituent_id = o.constituent_id AND altid.rn = 1
    WHERE (h.constituent_id IS NULL AND i.constituent_id IS NULL) OR (constype."description" = 'Organization')), alternatelookupid_hh
AS (SELECT
    xref.constituent_id, xref.xref_key, row_number() OVER (PARTITION BY xref.constituent_id ORDER BY xref.updated NULLS FIRST) AS rn
    FROM mdm.constituent_xref AS xref
    WHERE xref.system_id = 'e0c62670-7c67-4c60-9a46-8ad84e5a0fbe'), hh
AS (SELECT
    NULL AS constituentsk, NULL AS xrefconstituentsk, COALESCE(h.constituent_id, NULL) AS c360constituentnk, 'I' AS constituentcategory, altid.xref_key AS briefname, ci.description AS channelinsertedby, cu.description AS channelupdatedby, h.default_currency AS defaultcurrency, 'household' AS fullname, COALESCE(h.anonymous_gift_account, NULL) AS anonymousgiftindicator, h.comments AS householdcomments, COALESCE(s."description", NULL) AS householdstatusdescription, h.updated AS householdupdateddate, h.match_ratio AS matchratio, h.max_matched AS maximummatched, h.staff AS staff, COALESCE(h.is_vsc, NULL) AS vscindicator,
    CASE
        WHEN CHARINDEX('|', xrefta.xref_key) > 0 THEN LEFT(xrefta.xref_key, CHARINDEX('|', xrefta.xref_key) - 1)
        ELSE NULL
    END AS accountid,
    CASE
        WHEN CHARINDEX('|', xrefta.xref_key) > 0 THEN COALESCE(SUBSTRING(xrefta.xref_key, CHARINDEX('|', xrefta.xref_key) + 1, LENGTH(xrefta.xref_key)), NULL)
        ELSE NULL
    END AS nameid, constituentxrefdmslookupid.key_1 AS dmslookupid, 'InferendaPID' AS inferendapid
    FROM mdm.household AS h
    JOIN mdm.status AS s
        ON h.status_id = s.status_id
    LEFT OUTER JOIN mdm.organization AS o
        ON h.constituent_id = o.constituent_id
    LEFT OUTER JOIN mdm.individual AS i
        ON h.constituent_id = i.constituent_id
    LEFT OUTER JOIN mdm.constituent_xref AS constituentxrefdmslookupid
        ON constituentxrefdmslookupid.constituent_id = h.constituent_id AND constituentxrefdmslookupid.system_id = 'EC2372F7-AE4D-4447-99F6-A55E2E5FF5A6'
    LEFT OUTER JOIN mdm.constituent_type AS constype
        ON constype.constituent_type_lookup_id = constituentxrefdmslookupid.constituent_type_lookup_id
    LEFT OUTER JOIN mdm.constituent_xref AS xrefta
        ON xrefta.constituent_id = h.constituent_id AND xrefta.system_id = '45481716-340B-42E1-8620-36C509557EE1'
    LEFT OUTER JOIN mdm.channel AS ci
        ON h.channel_inserted_by = ci.channel_id
    LEFT OUTER JOIN mdm.channel AS cu
        ON h.channel_updated_by = cu.channel_id
    LEFT OUTER JOIN alternatelookupid_hh AS altid
        ON altid.constituent_id = h.constituent_id AND altid.rn = 1
    WHERE (o.constituent_id IS NULL AND i.constituent_id IS NULL) OR (constype."description" = 'Household')), u
AS (SELECT
    'Individual' AS c360constituenttype, accountid AS accountid, constituentcategory AS constituentcategory, preferredindicator AS preferredindicator, agerange AS agerange, ind.anonymousgiftindicator AS anonymousgiftindicator, birthdate AS birthdate, birthday AS birthday, birthmonth AS birthmonth, birthyear AS birthyear, briefname AS briefname, c360constituentnk AS c360constituentnk, NULL AS c360parentorganizationid, channelinsertedby AS channelinsertedby, channelupdatedby AS channelupdatedby, constituentsk AS constituentsk, deceaseddate AS deceaseddate, deceasedday AS deceasedday, deceasedindicator AS deceasedindicator, deceasedmonth AS deceasedmonth, deceasedyear AS deceasedyear, NULL AS defaultcurrency, dmslookupid AS dmslookupid, firstname AS firstname, fullname AS fullname, gender AS gender, NULL AS householdcomments, NULL AS householdstatusdescription, NULL AS householdupdateddate, individualcomments AS individualcomments, individualstatusdescription AS individualstatusdescription, individualupdateddate AS individualupdateddate, lastname AS lastname, maidenname AS maidenname, maritalstatusdescription AS maritalstatusdescription, marriagedate AS marriagedate, NULL AS matchratio, NULL AS maximumcontribution, NULL AS maximummatched, middlename AS middlename, NULL AS minimumcontribution, nameid AS nameid, numberofchildren AS numberofchildren, NULL AS numberofemployees, numberofgrandchildren AS numberofgrandchildren, NULL AS organizationcomments, NULL AS organizationdateupdated, NULL AS organizationname, NULL AS organizationstatusdescription, salutationindicator AS salutationindicator, salutationdescription AS salutationdescription, ind.staff AS staff, suffixdescription AS suffixdescription, titledescription AS titledescription, NULL AS vscindicator, inferendapid AS inferendapid, xrefconstituentsk AS xrefconstituentsk
    FROM ind
UNION ALL
SELECT
    'Organization' AS c360constituenttype, accountid AS accountid, constituentcategory AS constituentcategory, NULL AS preferredindicator, NULL AS agerange, anonymousgiftindicator AS anonymousgiftindicator, NULL AS birthdate, NULL AS birthday, NULL AS birthmonth, NULL AS birthyear, briefname AS briefname, c360constituentnk AS c360constituentnk, c360parentorganizationid AS c360parentorganizationid, channelinsertedby AS channelinsertedby, channelupdatedby AS channelupdatedby, constituentsk AS constituentsk, NULL AS deceaseddate, NULL AS deceasedday, NULL AS deceasedindicator, NULL AS deceasedmonth, NULL AS deceasedyear, defaultcurrency AS defaultcurrency, dmslookupid AS dmslookupid, NULL AS firstname, NULL AS fullname, NULL AS gender, NULL AS householdcomments, NULL AS householdstatusdescription, NULL AS householdupdateddate, NULL AS individualcomments, NULL AS individualstatusdescription, NULL AS individualupdateddate, NULL AS lastname, NULL AS maidenname, NULL AS maritalstatusdescription, NULL AS marriagedate, matchratio AS matchratio, maximumcontribution AS maximumcontribution, maximummatched AS maximummatched, NULL AS middlename, minimumcontribution AS minimumcontribution, nameid AS nameid, NULL AS numberofchildren, numberofemployees AS numberofemployees, NULL AS numberofgrandchildren, organizationcomments AS organizationcomments, organizationdateupdated AS organizationdateupdated, organizationname AS organizationname, organizationstatusdescription AS organizationstatusdescription, NULL AS salutationindicator, NULL AS salutationdescription, NULL AS staff, NULL AS suffixdescription, NULL AS titledescription, NULL AS vscindicator, inferendapid AS inferendapid, xrefconstituentsk AS xrefconstituentsk
    FROM org
UNION ALL
SELECT
    'Household' AS c360constituenttype, accountid AS accountid, constituentcategory AS constituentcategory, NULL AS preferredindicator, NULL AS agerange, anonymousgiftindicator AS anonymousgiftindicator, NULL AS birthdate, NULL AS birthday, NULL AS birthmonth, NULL AS birthyear, briefname AS briefname, c360constituentnk AS c360constituentnk, NULL AS c360parentorganizationid, channelinsertedby AS channelinsertedby, channelupdatedby AS channelupdatedby,
    /* ChildIndicator = NULL, */
    constituentsk AS constituentsk, NULL AS deceaseddate, NULL AS deceasedday, NULL AS deceasedindicator, NULL AS deceasedmonth, NULL AS deceasedyear, defaultcurrency AS defaultcurrency, dmslookupid AS dmslookupid, NULL AS firstname, fullname AS fullname, NULL AS gender, householdcomments AS householdcomments, householdstatusdescription AS householdstatusdescription, householdupdateddate AS householdupdateddate, NULL AS individualcomments, NULL AS individualstatusdescription, NULL AS individualupdateddate, NULL AS lastname, NULL AS maidenname, NULL AS maritalstatusdescription, NULL AS marriagedate, matchratio AS matchratio, NULL AS maximumcontribution, maximummatched AS maximummatched, NULL AS middlename, NULL AS minimumcontribution, nameid AS nameid, NULL AS numberofchildren, NULL AS numberofemployees, NULL AS numberofgrandchildren, NULL AS organizationcomments, NULL AS organizationdateupdated, NULL AS organizationname, NULL AS organizationstatusdescription, NULL AS salutationindicator, NULL AS salutationdescription, staff AS staff, NULL AS suffixdescription, NULL AS titledescription, vscindicator AS vscindicator, inferendapid AS inferendapid, xrefconstituentsk AS xrefconstituentsk
    FROM hh)
SELECT
    u.c360constituenttype, u.accountid, u.constituentcategory, u.preferredindicator, u.agerange, u.anonymousgiftindicator, u.birthdate, u.birthday, u.birthmonth, u.birthyear, u.briefname, u.c360constituentnk, u.c360parentorganizationid, u.channelinsertedby, u.channelupdatedby, xref.constituentsk,
    CASE
        WHEN u.c360constituenttype = 'Household' THEN u.fullname
        WHEN u.c360constituenttype = 'Individual' THEN u.fullname
        WHEN u.c360constituenttype = 'Organization' THEN u.organizationname
        ELSE NULL
    END AS constituentname,
    CASE
        WHEN u.c360constituenttype = 'Household' THEN u.householdstatusdescription
        WHEN u.c360constituenttype = 'Individual' THEN u.individualstatusdescription
        WHEN u.c360constituenttype = 'Organization' THEN u.organizationstatusdescription
        ELSE NULL
    END AS constituentstatusdescription, u.deceaseddate, u.deceasedday, u.deceasedindicator, u.deceasedmonth, u.deceasedyear, u.defaultcurrency, u.dmslookupid, u.firstname, u.fullname, u.gender, u.householdcomments, u.householdupdateddate, u.individualcomments, u.individualupdateddate, u.lastname, u.maidenname, u.maritalstatusdescription, u.marriagedate, u.matchratio, u.maximumcontribution, u.maximummatched, u.middlename, u.minimumcontribution, u.nameid, u.numberofchildren, u.numberofemployees, u.numberofgrandchildren, u.organizationcomments, u.organizationdateupdated, u.organizationname, u.salutationindicator, u.salutationdescription, u.staff, u.suffixdescription, u.titledescription, u.vscindicator, u.inferendapid, 0 AS dmsconstituentdonotmailindicator, 0 AS dmsconstituentdonotemailindicator, xref.constituentsk AS xrefconstituentsk
    FROM u    
    LEFT OUTER JOIN xref.dimconstituent AS xref
        ON xref.c360constituentnk = u.c360constituentnk;

GRANT SELECT ON model.dimconstituent TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimconstituent TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimconstituent TO dev_redshiftcoreadmingroup;
GRANT SELECT ON model.dimconstituent TO dev_redshiftcoredevgroup;


