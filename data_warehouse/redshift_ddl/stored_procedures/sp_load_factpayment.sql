CREATE OR REPLACE PROCEDURE public.sp_load_factpayment()
 LANGUAGE plpgsql
AS $$
BEGIN

drop table if exists stage.rev_join; 
create table stage.rev_join distkey (revenueid) sortkey (revenueid) as
  select
    rpm.id AS revenuepaymentmethodnk,
    rpm.paymentmethodcode AS paymentmethodcategory,
    rpm.revenueid,
    COALESCE(
        COALESCE(
                    CAST(ccpm.CREDITTYPECODEID AS NVARCHAR(36)),
                    CAST(opmd.OTHERPAYMENTMETHODCODEID AS NVARCHAR(36)),
                    CAST(gkpmd.GIFTINKINDSUBTYPECODEID AS NVARCHAR(36))
                ),
        CASE
            WHEN rpm.PAYMENTMETHODCODE = 2 THEN
                CAST(rpm.PAYMENTMETHODCODE AS NVARCHAR(36))
            WHEN rpm.PAYMENTMETHODCODE = 10 THEN
                COALESCE(
                            CAST(opmd.OTHERPAYMENTMETHODCODEID AS NVARCHAR(36)),
                            CAST(rpm.PAYMENTMETHODCODE AS NVARCHAR(36))
                        )
            ELSE
                CAST(rpm.PAYMENTMETHODCODE AS NVARCHAR(36))
        END,
        CAST(rpm.PAYMENTMETHODCODE AS NVARCHAR(36))
                                   ) AS paymentmethod, 
  COALESCE(uccpmd.creditcardsubtypecodeid, CAST (CAST (0 AS VARCHAR(10000)) AS VARCHAR(36))) AS paymentmethodsubcategory
  FROM dms.revenuepaymentmethod rpm
  LEFT OUTER JOIN DMS.CREDITCARDPAYMENTMETHODDETAIL ccpm
            ON ccpm.ID = rpm.ID
               AND rpm.PAYMENTMETHODCODE IN ( 2, 10 )
  LEFT OUTER JOIN DMS.OTHERPAYMENTMETHODDETAIL opmd
            ON rpm.ID = opmd.ID
               AND rpm.PAYMENTMETHODCODE = 10
  LEFT OUTER JOIN DMS.GIFTINKINDPAYMENTMETHODDETAIL gkpmd
            ON rpm.ID = gkpmd.ID
               AND rpm.PAYMENTMETHODCODE = 6
  LEFT OUTER JOIN DMS.USR_CREDITCARDPAYMENTMETHODDETAIL uccpmd
            ON uccpmd.ID = rpm.ID AND uccpmd.REQUIRESCHARGING = 0
               AND rpm.PAYMENTMETHODCODE IN ( 2, 10 )
  ;

drop table if exists stage.paymethod;  
create table stage.paymethod distkey (revenueid) sortkey (revenueid) as
select revenueid,PaymentMethodSK 
from stage.rev_join rev
LEFT OUTER JOIN Model.DimPaymentMethod dimPaymentMethod
        ON dimPaymentMethod.DMSPaymentMethodSubCategoryIDNK = rev.PaymentMethodSubCategory
        AND dimPaymentMethod.DMSPaymentMethodCategoryCodeNK = rev.PaymentMethodCategory
        AND dimPaymentMethod.DMSPaymentMethodIDNK = rev.PaymentMethod
        ;
--5 min run time

------------------CostCenterCode---------------------------------------------- 
drop table if exists stage.CostCenterCode;
create table stage.CostCenterCode distkey (REVENUEID) sortkey (REVENUEID) as

with
dimCostCenter as
(select C360CostCenterNK, costcentersk
from Model.dimCostCenter)

SELECT
    revenueid, 
    cost.costcentersk
    FROM glinterface.jobexecdetailarchive AS gl
    LEFT JOIN dimcostcenter cost
    on gl.station_support = cost.C360CostCenterNK
    WHERE updated = 0;
    --ORDER BY row_number() OVER (PARTITION BY revenueid ORDER BY jobexecid DESC NULLS FIRST) ASC NULLS FIRST LIMIT 1;
    
    
  

------------------DMSEventTransactions----------------------------------------------   

--create temp table DMSEventTransactions_TEMP  distkey (PAYMENTID) sortkey (PAYMENTID) as
--SELECT     pay.PAYMENTID,
--           res.EVENTID,
--           res.ID RegistrantID
--    FROM DMS.EVENTREGISTRANTPAYMENT AS pay
--        JOIN DMS.REGISTRANT res
--            ON res.ID = pay.REGISTRANTID;
--
--
--create temp table dmsEventTransactions distkey (financialtransactionid) sortkey (financialtransactionid) as
--select et.PAYMENTID,
--       et.eventid,
--       ftli.financialtransactionid
--from  dmsEventTransactions_TEMP et
--inner join ftli
--on et.paymentid = ftli.id;
--
--drop table DMSEventTransactions_TEMP;

------------------EVMOrderedEvents---------------------------------------------- 

 
------------------revenuetribute----------------------------------------------     
drop table if exists stage.revenuetribute;
create table stage.revenuetribute distkey (REVENUEID) sortkey (REVENUEID) as

with dimTribute as
(select PFPTributeIDNK, TributeSK
FROM Model.DimTribute)

SELECT
    revenuetribute.revenueid AS revenueid, revenuetribute.tmsid AS tmsid, dt.TributeSK
    FROM dms.usr_revenuetribute AS revenuetribute
    LEFT JOIN dimTribute dt
    ON dt.PFPTributeIDNK = revenuetribute.tmsid
    WHERE revenuetribute.tmsid IS NOT NULL;
    --ORDER BY row_number() OVER (PARTITION BY revenuetribute.revenueid ORDER BY revenuetribute.dateadded DESC NULLS FIRST) ASC NULLS FIRST
    --LIMIT 1;
------------------recurringgiftpaymentspayments----------------------------------------------  

--create temp table ftli_fid distkey (financialtransactionid) sortkey (financialtransactionid) as
--select  
--     id,financialtransactionid, transactionamount, dateadded, deletedon
--FROM dms.financialtransactionlineitem;

--create table stage.recurringgiftpaymentspayments distkey (FINANCIALTRANSACTIONID) sortkey (FINANCIALTRANSACTIONID) as
--SELECT
--    paymentFTLI.ID as paymentfinancialtransactionlineitemid,
--    pledgeFTLI.ID as pledgefinancialtransactionlineitemid,
--    pledgeFTLI.FINANCIALTRANSACTIONID,
--    rgi.id as RecurringGiftInstallmentID,
--		rgip.id as RecurringGiftInstallmentPaymentID
--    FROM DMS.RECURRINGGIFTINSTALLMENT AS rgi
--    INNER JOIN dms.recurringgiftinstallmentpayment AS rgip
--        ON rgi.id = rgip.recurringgiftinstallmentid
--    INNER JOIN DMS.FINANCIALTRANSACTIONLINEITEM AS paymentftli
--        ON rgip.paymentid = paymentftli.financialtransactionid
--    INNER JOIN DMS.FINANCIALTRANSACTIONLINEITEM AS pledgeftli
--        ON rgi.revenueid = pledgeftli.financialtransactionid
--    WHERE paymentFTLI.TRANSACTIONAMOUNT > 0
--          AND paymentFTLI.DELETEDON IS NULL
--          AND pledgeFTLI.DELETEDON IS NULL
--    ORDER BY row_number() OVER (PARTITION BY paymentftli.id ORDER BY pledgeftli.dateadded DESC NULLS FIRST) ASC NULLS FIRST
--    LIMIT 1;

------------------InstallmentPayments----------------------------------------------  

--create temp table installmentpayments_join distkey (pledgeid) sortkey (pledgeid) as
--SELECT
--    ispp.paymentid AS paymentfinancialtransactionlineitemid,
--    isp.ID AS InstallmentSplitID,
--		ispp.ID AS InstallmentSplitPaymentID,
--		ispp.pledgeid
--    FROM dms.installmentsplitpayment AS ispp
--    INNER JOIN dms.installmentsplit AS isp
--        ON isp.id = ispp.installmentsplitid;
----11 sec
--
--create temp table InstallmentPayments distkey (FINANCIALTRANSACTIONID) sortkey (FINANCIALTRANSACTIONID) as
--SELECT
--       PaymentFinancialTransactionLineItemID,
--       pledgeFTLI.ID as PledgeFinancialTransactionLineItemID,
--       pledgeFTLI.FINANCIALTRANSACTIONID,
--		   InstallmentSplitID,
--		   InstallmentSplitPaymentID
--    FROM installmentpayments_join AS ip
--        INNER JOIN DMS.FINANCIALTRANSACTIONLINEITEM AS pledgeFTLI
--            ON ip.PLEDGEID = pledgeFTLI.FINANCIALTRANSACTIONID
--    WHERE pledgeFTLI.TRANSACTIONAMOUNT > 0
--          AND pledgeFTLI.DELETEDON IS NULL
--    ORDER BY row_number() OVER (PARTITION BY ip.paymentfinancialtransactionlineitemid ORDER BY pledgeftli.dateadded DESC NULLS FIRST) ASC NULLS FIRST
--    LIMIT 1;   
----24 sec
-- 
--drop table installmentpayments_join;

---------------------------------------------------------------- 

drop table if exists stage.USR_INTERACTIONSOURCETYPE_EXT_DIMS;
create table stage.USR_INTERACTIONSOURCETYPE_EXT_DIMS DISTSTYLE ALL AS
select 
    sce.SOURCETYPECODEID,
    dimledgeraccount.ledgeraccountsk,
    dimledgeraccount_d.ledgeraccountsk as ledgeraccountsk_debit,
    dm.eventsk,
    df.fundsk,
    dimAttributionEffort.attributionsk
from DMS.USR_INTERACTIONSOURCETYPE_EXT sce
LEFT JOIN  Model.DimAttribution dimAttributionEffort  
        ON dimAttributionEffort.AttributionActivityNK = sce.Activity
       AND dimAttributionEffort.AttributionCampaignNK = sce.Campaign
       AND dimAttributionEffort.AttributionInitiativeNK = sce.Initiative
       AND dimAttributionEffort.AttributionEffortNK = sce.Effort
LEFT JOIN model.dimledgeraccount dimledgeraccount  
    ON dimledgeraccount.LedgerAccountNK = sce.credit_account
LEFT JOIN model.dimledgeraccount dimledgeraccount_d  
    ON dimledgeraccount.LedgerAccountNK = sce.debit_account
LEFT JOIN model.DimEvent dm
    ON dm.EVMEventNK = sce.Event
LEFT JOIN model.DimFund df
    ON df.AttributionFundNK = sce.fund;

drop table if exists stage.USR_TRANSACTIONEXT_DIMS;
create table stage.USR_TRANSACTIONEXT_DIMS distkey (ID) sortkey (ID) as
select usr.ID, usr.SOURCETYPECODEID, usr.fairmarketvalue, dt.TechniqueSK, dp.ProjectSK, usr.PROCESSED_DATE
from  DMS.USR_TRANSACTIONEXT usr
LEFT JOIN model.dimTechnique dt
    ON dt.DMSTechniqueNK = usr.interactiontypecodeid
LEFT JOIN model.DimProject dp
    ON dp.DMSProjectNK = usr.project;
    
drop table if exists stage.cons;
create table stage.cons diststyle key distkey (id) sortkey(id) as
select ft.id, con.constituentsk
from DMS.FINANCIALTRANSACTION ft
left join Model.DimConstituent con
on ft.constituentid = con.c360constituentnk;


----------------FactPayment----------------

drop table if exists stage.ftli_id;
create table stage.ftli_id distkey (id) sortkey (id) as
select  id,
        financialtransactionid
FROM dms.financialtransactionlineitem; 

drop table if exists stage.REVENUESPLIT_EXT;
create table stage.REVENUESPLIT_EXT diststyle key distkey (FINANCIALTRANSACTIONID) sortkey(FINANCIALTRANSACTIONID) as
select r.applicationcode, f.FINANCIALTRANSACTIONID
from dms.revenuesplit_ext r
inner join stage.ftli_id f
on r.id = f.id;

drop table if exists stage.transtype;
create table stage.transtype diststyle key distkey (id) sortkey(id) as
select ft.id, dt.TransactionTypeSK 
from DMS.FINANCIALTRANSACTION ft
inner join stage.REVENUESPLIT_EXT rev
on rev.FINANCIALTRANSACTIONID = ft.id
left join Model.DimTransactionType dt
on ft.typecode=dt.typecodenk
and rev.applicationcode = dt.applicationcodenk
and dt.typecodedescription <> '';

drop table if exists stage.dimtrans;
create table stage.dimtrans diststyle key distkey (DMSFinancialTransactionLineItemNK) sortkey (DMSFinancialTransactionLineItemNK) as
select transactionsk, DMSFinancialTransactionLineItemNK
from model.dimtransaction;

drop table if exists stage.dimtrans_join;
create table stage.dimtrans_join diststyle key distkey (financialtransactionid) sortkey (financialtransactionid) as
select transactionsk, financialtransactionid
from stage.dimtrans dt
INNER JOIN stage.ftli_id
    ON dt.DMSFinancialTransactionLineItemNK =  ftli_id.id;


------------------------------
drop table if exists stage.revenue_ext;
create table stage.revenue_ext diststyle key distkey (id) sortkey (id) as

WITH
dimSource as
(select SourceSK,AttributionSourceNK
FROM Model.DimSource)

select re.id, ds.SourceSK
FROM DMS.REVENUE_EXT re
LEFT JOIN dimSource ds
ON re.sourcecode = ds.AttributionSourceNK;
------------------------------

drop table if exists model.factpayment_old;

alter table model.factpayment rename to factpayment_old;
--explain
create table model.factpayment distkey (transactionsk) sortkey (transactionsk) as

SELECT
    COALESCE(dimtrans.transactionsk, -1) as transactionsk,    
    COALESCE(sce.attributionsk, -1) as attributionsk,
    COALESCE(cons.constituentsk, -1) as constituentsk,
    COALESCE(costcenter.costcentersk, -1) as costcentersk, 
    COALESCE(sce.ledgeraccountsk, -1) AS creditaccountsk,
    COALESCE(sce.eventsk, -1) as eventsk,
    COALESCE(ute.fairmarketvalue, 0) AS fairmarketvalue,
    CAST (COALESCE(ftli.postdate, ft.postdate) AS TIMESTAMP) AS paymentpostdate,
    poa.originalamount AS originalpaymentamount,
    ftli.transactionamount AS paymentamount,
    COALESCE(sce.fundsk, -1) as fundsk,
    CAST (ft.date AS TIMESTAMP) AS paymentdate,
    COALESCE(transtype.TransactionTypeSK, -1) AS TransactionTypeSK,
    COALESCE(rpm.paymentmethodsk, -1) as paymentmethodsk,
    COALESCE(ute.PROCESSED_DATE, ftli.DATEADDED) AS paymentprocessdate,
    COALESCE(ute.projectsk, -1) as projectsk,
    COALESCE(revenueext.sourcesk, -1) as sourcesk,
    COALESCE(ute.TechniqueSK, -1) as TechniqueSK,
    COALESCE(revenueTribute.TributeSK, -1) as TributeSK,
    COALESCE(sce.ledgeraccountsk_debit, -1) AS debitaccountsk
    FROM DMS.FINANCIALTRANSACTIONLINEITEM ftli
        INNER JOIN DMS.FINANCIALTRANSACTION ft
            ON ft.ID = ftli.FINANCIALTRANSACTIONID
        INNER JOIN  stage.dimtrans_join dimtrans
           ON dimtrans.FINANCIALTRANSACTIONID = ftli.FINANCIALTRANSACTIONID
        LEFT JOIN stage.paymethod AS rpm
            ON ft.ID = rpm.REVENUEID
        LEFT JOIN stage.cons AS cons
            ON ft.ID = cons.ID
        LEFT JOIN stage.transtype AS transtype
            ON ft.ID = transtype.ID
        LEFT JOIN DMS.PAYMENTORIGINALAMOUNT AS POA
            ON ftli.FINANCIALTRANSACTIONID = POA.ID
        LEFT JOIN stage.USR_TRANSACTIONEXT_DIMS ute
            ON ftli.FINANCIALTRANSACTIONID = ute.id
        LEFT JOIN stage.USR_INTERACTIONSOURCETYPE_EXT_DIMS sce
            ON sce.SOURCETYPECODEID = ute.SOURCETYPECODEID       
        LEFT JOIN stage.REVENUE_EXT revenueExt
            ON revenueExt.ID = ft.ID
        LEFT JOIN stage.CostCenterCode costCenter  
            ON costCenter.REVENUEID = ft.ID
        LEFT JOIN stage.RevenueTribute revenueTribute  
            ON revenueTribute.REVENUEID = ft.ID
       -- LEFT JOIN stage.RecurringGiftPaymentsPayments AS rgp  
       --     ON rgp.PaymentFinancialTransactionLineItemID = ftli.FINANCIALTRANSACTIONID
       -- LEFT OUTER JOIN InstallmentPayments AS ip 
       --    ON ip.FINANCIALTRANSACTIONID = ftli.FINANCIALTRANSACTIONID
    WHERE ft.TYPECODE = 0
          AND ft.DELETEDON IS NULL
          AND ftli.TYPECODE = 0
          AND ftli.DELETEDON IS NULL;
          

--35 mins
 
grant select on all tables in schema model to group dev_redshiftcorereadgroup;
grant select on all tables in schema model to group dev_redshiftcoreadmingroup;
grant select on all tables in schema model to group dev_redshiftcoredevgroup;

------------------drop temp tables------------------------
--drop table if exists stage.USR_TRANSACTIONEXT_DIMS;
--drop table if exists stage.USR_INTERACTIONSOURCETYPE_EXT_DIMS; 
--drop table if exists stage.USR_TRANSACTIONEXT_ID;
--drop table if exists stage.USR_TRANSACTIONEXT_ID_JOIN; 
--drop table if exists stage.CostCenterCode;     
--drop table if exists stage.cons;
--drop table if exists stage.REVENUE_EXT;

END;
$$
