CREATE MATERIALIZED VIEW model.dimaddress diststyle key distkey (c360addressnk) sortkey (c360addressnk)
AS
WITH staffbystate
AS
(SELECT state_code,
       staff
FROM (SELECT s.abbreviation AS state_code,
             c_xref1.xref_key AS staff,
             a.stafftypeid,
             st.description,
             st.stafftype,
             ROW_NUMBER() OVER (PARTITION BY s.abbreviation ORDER BY isnull (a.datechanged,'12-31-3000') DESC) AS rn
      FROM dms.usr_gpstaffzip a
        JOIN dms.state s ON a.stateid = s.id
        LEFT JOIN mdm.constituent_xref c_xref1
               ON a.staffid = c_xref1.constituent_id
              AND c_xref1.system_id = 'e0c62670-7c67-4c60-9a46-8ad84e5a0fbe'
      -- brief name
      
        LEFT JOIN dms.usr_gpstafftype st ON a.stafftypeid = st.id
      WHERE a.shortzip = 'all'
      AND   st.stafftype IN ('r')) a
WHERE rn = 1),staffbyzip AS (SELECT short_zip_code,
                                    staff
                             FROM (SELECT a.shortzip AS short_zip_code,
                                          c_xref2.xref_key AS staff,
                                          a.stafftypeid,
                                          st.description,
                                          st.stafftype,
                                          s.abbreviation AS state,
                                          ROW_NUMBER() OVER (PARTITION BY a.shortzip ORDER BY isnull (a.datechanged,'12-31-3000') DESC) AS rn
                                   FROM dms.usr_gpstaffzip a
                                     JOIN dms.state s ON a.stateid = s.id
                                     JOIN mdm.constituent_xref c_xref2
                                       ON a.staffid = c_xref2.constituent_id
                                      AND c_xref2.system_id = 'e0c62670-7c67-4c60-9a46-8ad84e5a0fbe'
                                   -- brief name
                                   
                                     JOIN dms.usr_gpstafftype st ON a.stafftypeid = st.id
                                   WHERE a.shortzip <> 'all'
                                   AND   st.stafftype IN ('r')) a
                             WHERE rn = 1) SELECT add_xref.addresssk AS addresssk,
--xrefaddresssk = add_xref.addresssk,
address.address_id AS c360addressnk,address.updated AS addressdateupdated,'extra_line_1' AS addressextraline1,
--address.extra_line_1: fix this later
'extra_line_2' AS addressextraline2,
--address.extra_line_2: fix this later
'address.address' AS addressline,
--address.address: fix this later
TRIM(address.city || ', ' || address.state || ' ' || address.zip || '-' || address.zip_ext) AS addresscitystatezipext,s.description AS addressstatusdescription,addresstype.description AS addresstypedescription,'address.apartment_num' AS apartmentnumber,
--address.apartment_num: fix this later
'address.carrier_route' AS carrierroutenumber,
--address.carrier_route: fix this later
address.city AS cityname,'ct.country' AS countrycode,
--ct.country: fix this later. mdm.country does not exist
'ct.description' AS countrydescription,
--ct.description: fix this later. mdm.country does not exist
cc.market_identifier AS marketidentifier,cc.description AS marketdescription,address.zip AS postalcode,address.zip_ext AS postalcodeextension,cc.region AS region,cc.region_code AS regioncode,CASE cc.region WHEN 'a' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'b' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'c' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'd' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'e' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'f' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'g' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'h' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'i' THEN LEFT ('0' + RIGHT (cc.region_code,1),3) WHEN 'j' THEN RIGHT (cc.region_code,2) WHEN 'k' THEN RIGHT (cc.region_code,2) WHEN 'l' THEN RIGHT (cc.region_code,2) WHEN 'm' THEN RIGHT (cc.region_code,2) WHEN 'o' THEN RIGHT (cc.region_code,2) WHEN 'p' THEN RIGHT (cc.region_code,2) WHEN 'q' THEN RIGHT (cc.region_code,2) WHEN 'r' THEN RIGHT (cc.region_code,2) WHEN 's' THEN RIGHT (cc.region_code,2) WHEN 't' THEN RIGHT (cc.region_code,2) WHEN 'u' THEN RIGHT (cc.region_code,2) WHEN 'v' THEN RIGHT (cc.region_code,2) WHEN 'w' THEN RIGHT (cc.region_code,2) WHEN 'x' THEN RIGHT (cc.region_code,2) ELSE NULL END AS regionnumber,st.state AS statecode,CASE WHEN st.state IS NULL THEN NULL ELSE st.description END AS statedescription, /*
       cast(case
                                         when address.street_number = '501'
                                              and
                                              (
                                                  upper(address.street_name) like '%st%jude%pl%'
                                                  or upper(address.street_name) like '%saint%jude%pl%'
                                              ) then
                                             1
                                         when address.address like '%501%st%jud%' then
                                             1
                                         when address.address like '%501%saint%jud%' then
                                             1
                                         else
                                             0
                                     end as bit) as stjudeaddressindicator,*/  0 AS stjudeaddressindicator,'address.street_number' AS streetnumber,
--address.street_number: fix this later
'address.street_name' AS streetname,
--address.street_name: fix this later
/*
       case
                              when ct.country != 'usa' -- non usa addresses
       then
                                  ct.country
                              else
                                  case st.state
                                      when 'as' then
                                          'asm' --# american samoa
                                      when 'fm' then
                                          'fsm' --# federated states of micronesia
                                      when 'gu' then
                                          'gum' --# guam
                                      when 'mh' then
                                          'mhl' --# marshall islands
                                      when 'pw' then
                                          'plw' --# palau
                                      when 'pr' then
                                          'pri' --# puerto rico
                                      when 'vi' then
                                          'vir' --# virgin islands 
                                      --
                                      when 'ae' then
                                          'ae'  --# armed forces europe, africa, canada, middle east 
                                      when 'aa' then
                                          'aa'  --# armed forces americas 
                                      when 'ap' then
                                          'ap'  --# armed forces pacific 
                                  end
                          end as intllocationcode,
                          */  'ic' AS intllocationcode,fips.cbsa_code AS cbsacode,fips.cbsa_title AS cbsatitle,fips2013.cbsa_code AS cbsacode2013,fips2013.cbsa_title AS cbsatitle2013,fips."metropolitan/micropolitan statistical area" AS metromicrodesc,fips2013.metro_micro_desc AS metromicrodesc2013,CASE WHEN staffbyzip.staff IS NOT NULL THEN staffbyzip.staff WHEN staffbystate.staff IS NOT NULL THEN staffbystate.staff ELSE NULL END AS geostaff FROM mdm.address address LEFT OUTER JOIN mdm.address_type addresstype ON addresstype.address_type_lookup_id = address.address_type_lookup_id LEFT OUTER JOIN mdm.state st ON isnull(st.state,'') = isnull(address.state,'') AND st.country = address.country
--   left outer join mdm.country ct
--      on ct.country = address.country
LEFT OUTER JOIN mdm.status s ON address.status_id = s.status_id LEFT JOIN mdm.alsac_market_regions mr ON address.zip = mr.zip LEFT JOIN mdm.alsac_cost_centers cc ON cc.cost_center = mr.cost_center LEFT JOIN staticdata.visual_zip_centers vz ON vz.zip = address.zip LEFT JOIN staticdata.fips_county_to_cbsa_map_2017 fips ON fips.fips_state_county = vz.countyfips LEFT JOIN staticdata.fips_county_to_cbsa_map_2013 AS fips2013 ON vz.countyfips = fips2013.fips_state_county LEFT JOIN staffbyzip staffbyzip ON SUBSTRING(LTRIM(RTRIM(address.zip)),1,3) = staffbyzip.short_zip_code LEFT JOIN staffbystate staffbystate ON address.state = staffbystate.state_code LEFT JOIN xref.dimaddress add_xref ON add_xref.c360addressnk = address.address_id;

GRANT SELECT ON model.dimaddress TO dev_redshiftcorereadgroup;
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, TRIGGER, RULE ON model.dimaddress TO dev-datawarehouse-core-master-user;
GRANT DELETE, INSERT, UPDATE, TRIGGER, REFERENCES, SELECT, RULE ON model.dimaddress TO dev_redshiftcoreadmingroup;
GRANT RULE, SELECT, INSERT, UPDATE, REFERENCES, TRIGGER, DELETE ON model.dimaddress TO dev_redshiftcoredevgroup;


