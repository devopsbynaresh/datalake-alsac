CREATE OR REPLACE PROCEDURE public.sp_load_dimtransaction()
 LANGUAGE plpgsql
AS $$
BEGIN

    create temp table rpm_join distkey (revenueid) sortkey (revenueid) as
  select
    rpm.id AS rpmid,
    rpm.paymentmethodcode AS paymentmethodcategory,
    rpm.revenueid,
    COALESCE(LTRIM(RTRIM(uccpmd.bankapprovalcode)), (LTRIM(RTRIM(ddpmd.directdebitresultcode)))) AS bankapprovalcode,
    LTRIM(RTRIM(uccpmd.depositreferencenumber)) AS depositreferencenumber,
    uccpmd.reconciliationid,
    uccpmd.requestid,
    uccpmd.merchantid,
    uccpmd.merchantkey
  FROM dms.revenuepaymentmethod rpm
  LEFT JOIN dms.checkpaymentmethoddetail AS cpmd
      ON rpm.id = cpmd.id AND rpm.paymentmethodcode = 1
  LEFT JOIN dms.usr_creditcardpaymentmethoddetail AS uccpmd
      ON uccpmd.id = rpm.id AND rpm.paymentmethodcode IN (2, 10) AND uccpmd.requirescharging = 0 
  LEFT JOIN dms.creditcardpaymentmethoddetail AS ccpm
      ON ccpm.id = rpm.id AND rpm.paymentmethodcode IN (2, 10) 
  LEFT JOIN dms.directdebitpaymentmethoddetail AS ddpmd
      ON rpm.id = ddpmd.id AND rpm.paymentmethodcode = 3
  LEFT JOIN dms.usr_directdebitpaymentmethoddetail AS uddpmd
      ON rpm.id = uddpmd.id AND rpm.paymentmethodcode = 3
  ;
  --3 min 32 sec runtime

     
  create temp table cc_join distkey (id) sortkey (id) as
  select
    rs.id,
    rs.creditcardid,
    ucc.reconciliationid,  
    ucc.requestid,
    ucc.merchant_id,
    ucc.merchant_key,
    ucc.merchant_name AS merchantname
  FROM dms.revenueschedule rs
  LEFT JOIN dms.creditcard AS cc
      ON rs.creditcardid = cc.id
  LEFT JOIN dms.usr_creditcard AS ucc
     ON rs.creditcardid = ucc.id
  ;
  -- 22 sec

drop table if exists model.dimtransaction_old;
--commit;
alter table model.dimtransaction rename to dimtransaction_old;
--commit;

create table model.dimtransaction diststyle key distkey(transactionsk) sortkey(transactionsk) as
SELECT 
    x.transactionsk AS transactionsk,
    ftli.id AS dmsfinancialtransactionlineitemnk,
    te.acquired_batch_number AS acquiredbatchnumber,
    te.alt_transaction_id AS alternatetransactionid,
    re.batchnumber AS dmsbatchnumber,
    re.donotacknowledge AS donotacknowledgeindicator,   
    CAST (NULLIF(LTRIM(RTRIM(REPLACE(REPLACE(re.reference, CHR(13), ' '), CHR(10), ' '))), '') AS VARCHAR(765)) AS transactioncomment,
    ftli.datechanged AS transactiondatechanged,
    ftli.dateadded AS transactiondateadded,
    te.ta_user_inserting AS transactionuserinserting,
    te.ta_user_updating AS transactionuserupdating,
    te.pledge_number AS pledgenumber,
    te.ack_code AS legacyacknowledgementcode,
    ft.userdefinedid AS dmsuserdefinedid,
    ft.id AS dmsfinancialtransactionid,
    ft.addedbyid AS transactionaddedbyid,
    COALESCE(LTRIM(RTRIM(CASE rpm.paymentmethodcategory
      WHEN 2 THEN rpm.reconciliationid
      WHEN 3 THEN rpm.reconciliationid
      END)), LTRIM(RTRIM(rs.reconciliationid))) AS reconciliationid,
    COALESCE(LTRIM(RTRIM(CASE rpm.paymentmethodcategory
      WHEN 2 THEN rpm.requestid
      WHEN 3 THEN rpm.requestid
      END)), LTRIM(RTRIM(rs.requestid))) AS requestid,
    rpm.depositreferencenumber,
    COALESCE(rpm.merchantid, rs.merchant_id) AS merchantid,
    COALESCE(rpm.merchantkey, rs.merchant_key) AS merchantkey,
    rs.merchantname,
    rpm.bankapprovalcode,
    rpm.paymentmethodcategory,
    re.benefitswaived AS benefitswaivedindicator
  FROM dms.financialtransactionlineitem AS ftli
      INNER JOIN dms.financialtransaction AS ft
          ON ft.id = ftli.financialtransactionid
      INNER JOIN rpm_join rpm 
        ON ft.id = rpm.revenueid
      LEFT JOIN cc_join rs 
        ON rpm.revenueid = rs.id
      LEFT JOIN dms.usr_transactionext AS te
          ON te.id = ft.id
      LEFT JOIN dms.revenue_ext AS re
          ON ft.id = re.id
      LEFT OUTER JOIN xref.dimtransaction AS x
          ON x.dmsfinancialtransactionlineitemnk = ftli.id
  WHERE ft.deletedon IS NULL
  AND  ftli.typecode = 0
  AND  ftli.deletedon IS NULL;
  
--21 min runtime
  
grant select on all tables in schema model to group dev_redshiftcorereadgroup;
grant select on all tables in schema model to group dev_redshiftcoreadmingroup;
grant select on all tables in schema model to group dev_redshiftcoredevgroup;

drop table rpm_join;
drop table cc_join;

END;
$$
