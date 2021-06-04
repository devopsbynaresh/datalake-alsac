CREATE OR REPLACE PROCEDURE sp_load_factconstituentaddress()
AS '
BEGIN
create temp table cons_join distkey (constituentsk) sortkey (constituentsk) as
SELECT
    /*hhaddr.constituentaddresssk AS constituentaddresssk, da.addresssk AS addresssk,*/ cons.constituentsk AS constituentsk, ca.updated AS constituentaddressdateupdated, CAST (ca.preferred AS BOOLEAN) AS constituentaddresspreferredindicator,
    /* These aren"t really dates some of the time, they"re MM/DD to MM/DD to signify a yearly/seasonal change */
/*    CASE
        WHEN ad.preferred_during_dates = "Y" THEN ad.from_date
        ELSE NULL
    END AS constituentaddressseasonalfromdate,
    CASE
        WHEN ad.preferred_during_dates = "Y" THEN ad.through_date
        ELSE NULL
    END AS constituentaddressseasonalthroughdate,*/ ca.constituent_id AS changemdmconstituent_addressconstituent_id, ca.address_id AS changemdmconstituent_addressaddress_id /*, ad.address_id AS changemdmaddressaddress_id*/
    FROM mdm.constituent_address AS ca
    JOIN model.dimconstituent AS cons
        ON cons.c360constituentnk = ca.constituent_id;


        


create temp table da_join distkey (changemdmaddressaddress_id) sortkey (changemdmaddressaddress_id) as
SELECT/* da.addresssk AS addresssk, ca.updated AS constituentaddressdateupdated, CAST (ca.preferred AS BOOLEAN) AS constituentaddresspreferredindicator,*/
CASE
        WHEN ad.preferred_during_dates = "Y" THEN ad.from_date
        ELSE NULL
    END AS constituentaddressseasonalfromdate,
    CASE
        WHEN ad.preferred_during_dates = "Y" THEN ad.through_date
        ELSE NULL
    END AS constituentaddressseasonalthroughdate, /*ca.constituent_id AS changemdmconstituent_addressconstituent_id, ca.address_id AS changemdmconstituent_addressaddress_id,*/ ad.address_id AS changemdmaddressaddress_id
from model.dimaddress AS da
join mdm.constituent_address AS ca
        ON da.c360addressnk = ca.address_id
    JOIN mdm.address AS ad
        ON ad.address_id = ca.address_id;



create table stage.factconstituentaddress as
select 
cj.constituentsk,
cj.constituentaddressdateupdated,
cj.constituentaddresspreferredindicator,
cj.changemdmconstituent_addressconstituent_id,
cj.changemdmconstituent_addressaddress_id, 
dj.constituentaddressseasonalthroughdate,
dj.changemdmaddressaddress_id
from cons_join cj
inner join da_join dj on cj.changemdmconstituent_addressaddress_id = dj.changemdmaddressaddress_id;



--drop tables
drop table cons_join;
drop table da_join;

END;
'
 LANGUAGE plpgsql;