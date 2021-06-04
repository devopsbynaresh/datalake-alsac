CREATE OR REPLACE PROCEDURE public.sp_load_factcommitment()
 LANGUAGE plpgsql
AS $$ 
BEGIN
create temp table revenuetribute as 
SELECT
    revenuetribute.revenueid AS revenueid, revenuetribute.tmsid AS tmsid
    FROM dms.usr_revenuetribute AS revenuetribute
    WHERE revenuetribute.tmsid IS NOT NULL
    ORDER BY row_number() OVER (PARTITION BY revenuetribute.revenueid ORDER BY revenuetribute.dateadded DESC NULLS FIRST) ASC NULLS FIRST
    LIMIT 1;

create temp table pledgedata1
as
--explain 
SELECT
ft.id AS financialtransactionid,
sce.activity AS activitynk,
COALESCE(NULLIF(ute.station_support, ''), NULLIF(sce.station_support, ''), '-1') AS costcenternk,
ft.constituentid AS c360constituentnk,
sce.campaign AS campaignnk,
sce.credit_account AS creditaccountnk,
sce.debit_account AS debitaccountnk,

rpm.id AS dmsrevenuepaymentmethodnk,
rpm.paymentmethodcode AS dmspaymentmethodcategorycodenk,
 CASE
        WHEN rpm.paymentmethodcode = 2 THEN COALESCE(CAST (cc.credittypecodeid AS VARCHAR(108)), CAST (rpm.paymentmethodcode AS VARCHAR(108)))

        WHEN rpm.paymentmethodcode = 10 THEN COALESCE(CAST (opmd.otherpaymentmethodcodeid AS VARCHAR(108)), CAST (rpm.paymentmethodcode AS VARCHAR(108)))
        ELSE CAST (rpm.paymentmethodcode AS VARCHAR(108))


    END AS dmspaymentmethodidnk,
sce.effort AS effortnk,
CAST (ft.date AS TIMESTAMP) AS financialtransactiondate,
ft.typecode AS financialtransactiontypecode,
ft.postdate AS pledgepostdate,
ute.fund AS fundnk,
sce.initiative AS initiativenk,
ute.project AS projectnk,
ft.typecode AS typecodenk,
COALESCE(NULLIF(ute.event, CAST ('00000000-0000-0000-0000-000000000000' AS VARCHAR(36)))) AS eventnk,
revenuetribute.tmsid AS tributenk
from

    dms.otherpaymentmethoddetail AS opmd
        join dms.revenuepaymentmethod AS rpm
         on rpm.id = opmd.id AND rpm.paymentmethodcode = 10
    LEFT OUTER JOIN dms.revenueschedule AS rs
        ON rpm.revenueid = rs.id
    LEFT OUTER JOIN dms.creditcard AS cc
        ON rs.creditcardid = cc.id
        LEFT OUTER JOIN

    dms.financialtransaction AS ft
        ON ft.id = rpm.revenueid
     LEFT OUTER JOIN
    dms.usr_transactionext AS ute
        ON ute.id = ft.id
    left outer join dms.usr_interactionsourcetype_ext AS sce
    ON ute.sourcetypecodeid = sce.sourcetypecodeid
        LEFT OUTER JOIN

    RevenueTribute AS revenuetribute
        ON revenuetribute.revenueid = ft.id;



create temp table pledgedata2 
as
--explain 
SELECT
    ftli.id AS dmsfinancialtransactionlineitemnk, ft.id AS financialtransactionid,
         ftli.transactionamount AS financialtransactionlineitemtransactionamount, ftli.dateadded AS financialtransactionlineitemdateadded, ftli.datechanged AS financialtransactionlineitemdatechanged,
     -- CAST (ft.date AS TIMESTAMP) AS financialtransactiondate,ft.typecode AS financialtransactiontypecode, ute.fund AS fundnk, sce.initiative AS initiativenk,
      ftli.transactionamount AS installmentamount, ftli.orgamount AS ftli_orgamount, ftli.transactionamount AS ftli_transactionamount,
      CAST (ftli.postdate AS TIMESTAMP) AS pledgedepositdate, COALESCE(ute.processed_date, ftli.dateadded) AS pledgeprocessdate, revenueext.sourcecode AS sourcenk
      FROM dms.financialtransactionlineitem AS ftli
    JOIN dms.financialtransaction AS ft
        ON ft.id = ftli.financialtransactionid
        LEFT OUTER JOIN
    dms.usr_transactionext AS ute
        ON ute.id = ft.id
         LEFT OUTER JOIN dms.revenue_ext AS revenueext
        ON revenueext.id = ft.id;
     
create temp table pledgedata3
as
--explain
select ftli.id AS dmsfinancialtransactionlineitemnk,
ft.id AS financialtransactionid,
rse.applicationcode AS applicationcodenk,
 CASE
        WHEN rpm.paymentmethodcode = 2 THEN COALESCE(cce.creditcardsubtypecodeid, CAST (CAST (0 AS VARCHAR(10000)) AS VARCHAR(36)))
        ELSE CAST (CAST (0 AS VARCHAR(10000)) AS VARCHAR(36))
    END AS dmspaymentmethodsubcategoryidnk,
   CASE
        WHEN ft.typecode = 1 THEN CAST (poa.originalamount AS NUMERIC(11, 2))
        WHEN ft.typecode = 2 THEN ftli.transactionamount
    END AS originalpledgeamount  
FROM dms.financialtransactionlineitem AS ftli
    JOIN dms.financialtransaction AS ft
        ON ft.id = ftli.financialtransactionid
    INNER JOIN dms.revenuesplit_ext AS rse
        ON ftli.id = rse.id
    LEFT OUTER JOIN
   dms.revenuepaymentmethod AS rpm
        ON ft.id = rpm.revenueid
    LEFT OUTER JOIN dms.revenueschedule AS rs
        ON rpm.revenueid = rs.id
    LEFT OUTER JOIN
    dms.usr_creditcard AS cce
        ON rs.creditcardid = cce.id
    LEFT OUTER JOIN
    dms.otherpaymentmethoddetail AS opmd
        ON rpm.id = opmd.id AND rpm.paymentmethodcode = 10
    LEFT OUTER JOIN dms.pledgeoriginalamount AS poa
        ON ft.id = poa.id;
   

    
create temp table pledgedata as
--distkey(dmsfinancialtransactionlineitemnk) sortkey(dmsfinancialtransactionlineitemnk) 
--explain
SELECT
p2.dmsfinancialtransactionlineitemnk,
p1.financialtransactionid,  
p1.activitynk,
p1.costcenternk,
p1.c360constituentnk, 
p1.campaignnk, 
p1.creditaccountnk,  
p1.debitaccountnk, 
p1.dmsrevenuepaymentmethodnk,
p1.dmspaymentmethodcategorycodenk,
p1.dmspaymentmethodidnk,
p3.dmspaymentmethodsubcategoryidnk, 
p1.effortnk, 
p1.eventnk,  
p2.financialtransactionlineitemtransactionamount, 
p2.financialtransactionlineitemdateadded,  
p2.financialtransactionlineitemdatechanged,  
p1.financialtransactiondate,  
p1.financialtransactiontypecode, 
p1.fundnk, 
p1.initiativenk,  
p2.installmentamount,  
p2.ftli_orgamount, 
p2.ftli_transactionamount,
p3.originalpledgeamount,
p2.pledgedepositdate,  
p1.pledgepostdate,  
p2.pledgeprocessdate,  
p1.projectnk,
p2.sourcenk,
p1.tributenk,
p1.typecodenk,  
p3.applicationcodenk
from pledgedata1 as p1
join pledgedata2 as p2
on p1.financialtransactionid = p2.financialtransactionid
join pledgedata3 as p3
on p2.financialtransactionid = p3.financialtransactionid;

create table model.factcommitment as
--explain
SELECT
    dimtransaction.transactionsk AS transactionsk, COALESCE(revenueschedule.revenueschedulesk, - 1) AS revenueschedulesk, COALESCE(dimattributioneffort.attributionsk, - 1) AS attributionsk, COALESCE(cons.constituentsk, - 1) AS constituentsk,

    COALESCE(dimcostcenter.costcentersk, - 1) AS costcentersk, COALESCE(dimledgeraccountcredit.ledgeraccountsk, - 1) AS creditaccountsk, COALESCE(dimledgeraccountdebit.ledgeraccountsk, - 1) AS debitaccountsk, COALESCE(dimevent.eventsk, - 1) AS eventsk, COALESCE(dimfund.fundsk, - 1) AS fundsk,
  
    COALESCE(dimpaymentmethod.paymentmethodsk, - 1) AS paymentmethodsk, COALESCE(dimcommitmenstatus.commitmentstatussk, - 1) AS commitmentstatussk,

    COALESCE(dimproject.projectsk, - 1) AS projectsk,
    -- COALESCE(dimsource.sourcesk, - 1) AS sourcesk,
 --    COALESCE(dimtechnique.techniquesk, - 1) AS techniquesk,
  COALESCE(dimtribute.tributesk, - 1) AS tributesk, pledge.financialtransactiondate AS commitmentdate,

    pledge.FinancialTransactionLineItemTransactionAmount AS commitmentamount,

    pledge.ftli_ORGAMOUNT AS commitmentorganizationamount,

    pledge.originalpledgeamount *
    CASE revenueschedule.frequencycode
        WHEN 0 THEN 1

        WHEN 1 THEN 2
        WHEN 2 THEN 4
        WHEN 3 THEN 12
        WHEN 4 THEN NVL(revenueschedule.numberofinstallments, 1)
        WHEN 5 THEN 1
        WHEN 6 THEN 6
        WHEN 7 THEN NVL(revenueschedule.numberofinstallments, 1)
        WHEN 8 THEN 26
        WHEN 9 THEN 52
        ELSE 1
    END AS commitmentoriginalcalculatedamount, pledge.originalpledgeamount AS commitmentoriginalamount,

    pledge.ftli_TRANSACTIONAMOUNT *
    CASE revenueschedule.frequencycode
        WHEN 0 THEN 1

        WHEN 1 THEN 2
        WHEN 2 THEN 4
        WHEN 3 THEN 12
        WHEN 4 THEN NVL(revenueschedule.numberofinstallments, 1)
        WHEN 5 THEN 1
        WHEN 6 THEN 6
        WHEN 7 THEN NVL(revenueschedule.numberofinstallments, 1)
        WHEN 8 THEN 26
        WHEN 9 THEN 52
        ELSE 1
    END AS commitmentcalculatedamount, pledge.pledgedepositdate AS commitmentdepositdate,

    pledge.PledgePostDate AS commitmentpostdate,

    pledge.pledgeprocessdate AS commitmentprocessdate,

    
    COALESCE(dimtransactiontype.transactiontypesk, - 1) AS transactiontypesk
    FROM pledgedata AS pledge
    INNER JOIN model.dimtransaction AS dimtransaction
        ON dimtransaction.dmsfinancialtransactionlineitemnk = pledge.DMSFinancialTransactionLineItemNK
    LEFT OUTER JOIN model.dimrevenueschedule AS revenueschedule
        ON revenueschedule.dmsrevenueschedulenk = dimtransaction.dmsfinancialtransactionid
    LEFT OUTER JOIN model.dimattribution AS dimattributioneffort
        ON dimattributioneffort.attributionactivitynk = pledge.ActivityNK AND dimattributioneffort.attributioncampaignnk = NVL(pledge.CampaignNK, '') AND dimattributioneffort.attributioninitiativenk = NVL(pledge.initiativeNK, '') AND dimattributioneffort.attributioneffortnk = NVL(pledge.effortNK, '')
    LEFT OUTER JOIN model.dimconstituent AS cons
        ON cons.c360constituentnk = pledge.C360ConstituentNK
--    LEFT OUTER JOIN model.dimsource AS dimsource
--        ON dimsource.attributionsourcenk = pledge.sourceNK
    LEFT OUTER JOIN model.dimproject AS dimproject
        ON dimproject.dmsprojectnk = pledge.projectNK
--    LEFT OUTER JOIN model.dimtechnique AS dimtechnique
--        ON dimtechnique.dmstechniquenk = pledge.TechniqueNK OR dimtechnique.techniquecode = pledge.TechniqueDescription
    LEFT OUTER JOIN model.dimfund AS dimfund
        ON dimfund.attributionfundnk = pledge.fundNK
    LEFT OUTER JOIN model.dimledgeraccount AS dimledgeraccountcredit
        ON dimledgeraccountcredit.ledgeraccountnk = pledge.CreditAccountNK
    LEFT OUTER JOIN model.dimledgeraccount AS dimledgeraccountdebit
        ON dimledgeraccountdebit.ledgeraccountnk = pledge.DebitAccountNK
    LEFT OUTER JOIN model.dimtribute AS dimtribute
        ON dimtribute.pfptributeidnk = pledge.TributeNK
    LEFT OUTER JOIN model.dimevent AS dimevent
        ON pledge.eventnk = dimevent.evmeventnk
    LEFT OUTER JOIN
   

    model.dimpaymentmethod AS dimpaymentmethod
        ON dimpaymentmethod.dmspaymentmethodsubcategoryidnk = pledge.dmspaymentmethodsubcategoryidnk AND dimpaymentmethod.dmspaymentmethodcategorycodenk = pledge.DMSPaymentMethodCategoryCodeNK AND dimpaymentmethod.dmspaymentmethodidnk = CAST (pledge.dmspaymentmethodidnk AS VARCHAR(108))
    LEFT OUTER JOIN

    model.dimtransactiontype AS dimtransactiontype
        ON dimtransactiontype.typecodenk = pledge.typecodeNK AND dimtransactiontype.applicationcodenk = pledge.applicationcodeNK
    LEFT OUTER JOIN model.dimcommitmentstatus AS dimcommitmenstatus
        ON dimcommitmenstatus.commitmentstatusnk = revenueschedule.statuscode
    LEFT OUTER JOIN model.dimcostcenter AS dimcostcenter
        ON dimcostcenter.c360costcenternk = pledge.costcenternk;

--drop tables
drop table pledgedata1;
drop table pledgedata2;
drop table pledgedata3;
drop table revenuetribute;
drop table pledgedata;

END;
$$
