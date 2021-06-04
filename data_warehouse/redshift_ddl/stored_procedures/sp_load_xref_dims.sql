CREATE OR REPLACE PROCEDURE public.sp_load_xref_dims()
 LANGUAGE plpgsql
AS $$
BEGIN

insert into xref.dimaddress(c360addressnk, maxrowversion, etlauditkey, dateadded)
select a.c360addressnk, '' as maxrowversion, 1 as etlauditkey, getdate() as dateadded from model.dimaddress a
left join xref.dimaddress x on a.c360addressnk = x.c360addressnk
where x.c360addressnk is null;

insert into xref.dimattribution(attributionactivitynk,attributioncampaignnk,attributioninitiativenk,attributioneffortnk, maxrowversion, etlauditkey, dateadded)
select a.attributionactivitynk,a.attributioncampaignnk,a.attributioninitiativenk,a.attributioneffortnk, '' as maxrowversion, 1 as etlauditkey, getdate() as dateadded from model.dimattribution a
left join xref.dimattribution x on a.attributionactivitynk = x.attributionactivitynk
                               and a.attributioncampaignnk = x.attributioncampaignnk
                               and a.attributioninitiativenk = x.attributioninitiativenk
                               and a.attributioneffortnk = x.attributioneffortnk
where x.attributionactivitynk is null and x.attributioncampaignnk is null and x.attributioninitiativenk is null and x.attributioneffortnk is null;

insert into xref.dimcommitmentstatus(commitmentstatusnk, maxrowversion, etlauditkey, dateadded)
select a.commitmentstatusnk, '' as maxrowversion, 1 as etlauditkey, getdate() as dateadded from model.dimcommitmentstatus a
left join xref.dimcommitmentstatus x on a.commitmentstatusnk = x.commitmentstatusnk
where x.commitmentstatusnk is null;

insert into xref.dimconstituent(c360constituentnk, maxrowversion, etlauditkey, dateadded)
select a.c360constituentnk, '' as maxrowversion, 1 as etlauditkey, getdate() as dateadded from model.dimconstituent a
left join xref.dimconstituent x on a.c360constituentnk = x.c360constituentnk
where x.c360constituentnk is null;

insert into xref.dimcostcenter(c360costcenternk, maxrowversion, etlauditkey, dateadded)
select a.c360costcenternk, '' as maxrowversion, 1 as etlauditkey, getdate() as dateadded from model.dimcostcenter a
left join xref.dimcostcenter x on a.c360costcenternk = x.c360costcenternk
where x.c360costcenternk is null;

insert into xref.dimevent(evmeventnk, maxrowversion, etlauditkey, dateadded)
select a.evmeventnk, '' as maxrowversion, 1 as etlauditkey, getdate() as dateadded from model.dimevent a
left join xref.dimevent x on a.evmeventnk = x.evmeventnk
where x.evmeventnk is null;

insert into xref.dimfund(attributionfundnk, maxrowversion, etlauditkey)
select a.attributionfundnk, '' as maxrowversion, 1 as etlauditkey from model.dimfund a
left join xref.dimfund x on a.attributionfundnk = x.attributionfundnk
where x.attributionfundnk is null;

insert into xref.dimledgeraccount(ledgeraccountnk, maxrowversion, etlauditkey)
select a.ledgeraccountnk, '' as maxrowversion, 1 as etlauditkey from model.dimledgeraccount a
left join xref.dimledgeraccount x on a.ledgeraccountnk = x.ledgeraccountnk
where x.ledgeraccountnk is null;

insert into xref.dimpaymentmethod(dmspaymentmethodcategorycodenk, maxrowversion, etlauditkey)
select a.dmspaymentmethodcategorycodenk, '' as maxrowversion, 1 as etlauditkey from model.dimpaymentmethod a
left join xref.dimpaymentmethod x on a.dmspaymentmethodcategorycodenk = x.dmspaymentmethodcategorycodenk
where x.dmspaymentmethodcategorycodenk is null;

insert into xref.dimproject(dmsprojectnk, maxrowversion, etlauditkey)
select a.dmsprojectnk, '' as maxrowversion, 1 as etlauditkey from model.dimproject a
left join xref.dimproject x on a.dmsprojectnk = x.dmsprojectnk
where x.dmsprojectnk is null;

insert into xref.dimrevenueschedule(dmsrevenueschedulenk, maxrowversion, etlauditkey)
select a.dmsrevenueschedulenk, '' as maxrowversion, 1 as etlauditkey from model.dimrevenueschedule a
left join xref.dimrevenueschedule x on a.dmsrevenueschedulenk = x.dmsrevenueschedulenk
where x.dmsrevenueschedulenk is null;

insert into xref.dimsource(attributionsourcenk, maxrowversion, etlauditkey)
select a.attributionsourcenk, '' as maxrowversion, 1 as etlauditkey from model.dimsource a
left join xref.dimsource x on a.attributionsourcenk = x.attributionsourcenk
where x.attributionsourcenk is null;

insert into xref.dimsourcesystem(sourcesystemnk, maxrowversion, etlauditkey)
select a.sourcesystemnk, '' as maxrowversion, 1 as etlauditkey from model.dimsourcesystem a
left join xref.dimsourcesystem x on a.sourcesystemnk = x.sourcesystemnk
where x.sourcesystemnk is null;

insert into xref.dimtechnique(dmstechniquenk, maxrowversion, etlauditkey)
select a.dmstechniquenk, '' as maxrowversion, 1 as etlauditkey from model.dimtechnique a
left join xref.dimtechnique x on a.dmstechniquenk = x.dmstechniquenk
where x.dmstechniquenk is null;

insert into xref.dimtransaction(dmsfinancialtransactionlineitemnk, maxrowversion, etlauditkey)
select a.dmsfinancialtransactionlineitemnk, '' as maxrowversion, 1 as etlauditkey from model.dimtransaction a
left join xref.dimtransaction x on a.dmsfinancialtransactionlineitemnk = x.dmsfinancialtransactionlineitemnk
where x.dmsfinancialtransactionlineitemnk is null;

insert into xref.dimtransactiontype(typecodenk, applicationcodenk, maxrowversion, etlauditkey)
select a.typecodenk, a.applicationcodenk, '' as maxrowversion, 1 as etlauditkey from model.dimtransactiontype a
left join xref.dimtransactiontype x on a.typecodenk = x.typecodenk
where x.typecodenk is null
and a.typecodedescription <> '';

insert into xref.dimtribute(pfptributeidnk, maxrowversion, etlauditkey)
select a.pfptributeidnk, '' as maxrowversion, 1 as etlauditkey from model.dimtribute a
left join xref.dimtribute x on a.pfptributeidnk = x.pfptributeidnk
where x.pfptributeidnk is null;


END;
$$
