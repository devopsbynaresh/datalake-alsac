CREATE OR REPLACE PROCEDURE public.sp_refresh_mv_dims()
 LANGUAGE plpgsql
AS $$
BEGIN
refresh materialized view model.dimaddress;
refresh materialized view model.dimattribution;
refresh materialized view model.dimcommitmentstatus;
refresh materialized view model.dimcostcenter;
refresh materialized view model.dimevent;
refresh materialized view model.dimconstituent;
refresh materialized view model.dimfund;
refresh materialized view model.dimledgeraccount;
refresh materialized view model.dimproject;
refresh materialized view model.dimrevenueschedule;
refresh materialized view model.dimsource;
refresh materialized view model.dimsourcesystem;
refresh materialized view model.dimtechnique;
refresh materialized view model.dimtransactiontype;
refresh materialized view model.dimtribute;

END;
$$
