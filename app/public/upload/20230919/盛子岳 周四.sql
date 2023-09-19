/*--20220916  地址失效 排除下。8510013311945,迁移
select * from   files2.um_address t,cp2.cm_customer c ,rep.v_addr_set_js gis
where t.cust_id=c.cust_id
and t.std_addr_id = gis.segm_id
and c.cust_code = '8510013326011'--,'8510013311945'
and t.expire_date>sysdate 
*/


--1  现金缴费 余额小于30

select distinct c.cust_code 客户证号,p.party_name 参与人姓名,
gis.stand_name 地址,gis.region_name 区域,
gis.village_name||'-'||gis.building_name||'-'||gis.segm_name 地址, ---陈聚短信不用详细地址，只用小区
gis.village_name 小区,
ccci.cont_number,ccci.family_number,ccci.cont_number2,ccci.family_number2,/*rat.balance/100 冲销前余额,*/rat.rest_balance/100 冲销后余额,
--ccci.bank_name 银行名称 ,
--fca.pay_mode,--rela.state ,
--fca.pay_type,
(case  when tt.offer_status = '1' and tt.os_status is null then
                   '正常'
                  when tt.offer_status = '3' and tt.os_status = '1' then
                   '欠停'
                  when tt.offer_status = '3' and tt.os_status = '3' then
                   '暂停'
                  when tt.offer_status = '99' then
                   '割接状态'
                end) srvpkg_state
from cp2.cm_customer c  
--join wx_region_address_rel dd on c.cust_id=dd.cust_id
left join rep2.rep_fact_cust_info_20230620 ccci on c.cust_id=ccci.cust_id -----------修改 1
left join files2.cm_account fca on fca.cust_id=c.cust_id
left join ac2.am_busi_ext ext on ext.acct_id=fca.acct_id
left join cp2.cb_party p on p.party_id = c.party_id
left join wx_rep_account_temp rat on rat.acct_id=fca.acct_id
left join files2.um_subscriber us on us.cust_id=c.cust_id
left join files2.um_offer_06 t6 on  t6.subscriber_ins_id = us.subscriber_ins_id and t6.parent_offer_id <> '-1'--产品
left join files2.um_offer_sta_02 tt on t6.offer_ins_id = tt.offer_ins_id
--left join ac2.am_entrust_relation rela on  fca.acct_id= rela.acct_id
join files2.um_address t on t.cust_id=c.cust_id  and t.expire_date > sysdate
join rep.v_addr_set_js gis on t.std_addr_id = gis.segm_id
where c.own_corp_org_id =3303
and c.cust_type = '1'
and c.cust_level =1 ---客户级别：普通 @1 代表cust_type=1
and fca.pay_type ='1' -- 朱： 1现金
and t6.PROD_SERVICE_ID = 1002
and rat.rest_balance/100 <30
and tt.offer_status = '1'
and t.expire_date>sysdate  --地址当前有效--
--and rela.state <> 0 ---0是有效，1是失效，也就是解约了，1也 还是代扣的，要看files.cm_account表里面的pay_type
and us.main_subscriber_ins_id=0
and not exists(select * from files2.um_offer_06 iof
where iof.offer_id in (800500211385,800600132727,800600131409,800600132763,800600131515,
800500211472,800600122638,800500211313,800500211471,800500211470,800500211307,800600132726,
800600132985,800600131408,800500211386,800500211309,800600132744,800600132729,800500211308,
800600132728,800500211473,800600132730,800600132731,800600132748,800600131513,800600131516,
800600122635
) and iof.cust_id = c.cust_id)  --排除广联
and not exists (select 1 from ac2.am_busi busi where c.cust_id = busi.cust_id
and to_char(busi.create_date,'yyyymmdd') = to_char(sysdate,'yyyymmdd')
)




--2 本月代扣没有扣到的开通客户

select distinct c.cust_code 客户证号,p.party_name 参与人姓名,
/*dd.std_addr_name 地址,*/gis.district_name 区域,
gis.village_name/*||'-'||gis.building_name||'-'||gis.segm_name*/,
ccci.cont_number,ccci.family_number,ccci.cont_number2,ccci.family_number2,
/*rat.balance/100 冲销前余额,*/rat.rest_balance/100 欠费金额 /*冲销后余额*/,
ccci.bank_name 银行名称 ,
--fca.pay_mode,--rela.state ,
fca.pay_type,
(case  when tt.offer_status = '1' and tt.os_status is null then
                   '正常'
                  when tt.offer_status = '3' and tt.os_status = '1' then
                   '欠停'
                  when tt.offer_status = '3' and tt.os_status = '3' then
                   '暂停'
                  when tt.offer_status = '99' then
                   '割接状态'
                end) srvpkg_state
from cp2.cm_customer c
join wx_region_address_rel dd on c.cust_id=dd.cust_id
left join rep2.rep_fact_cust_info_20230620 ccci on c.cust_id=ccci.cust_id ---------------------修改 1 
left join files2.cm_account fca on fca.cust_id=c.cust_id
left join ac2.am_busi_ext ext on ext.acct_id=fca.acct_id
left join cp2.cb_party p on p.party_id = c.party_id
left join wx_rep_account_temp rat on rat.acct_id=fca.acct_id
left join files2.um_subscriber us on us.cust_id=c.cust_id
left join files2.um_offer_06 t6 on  t6.subscriber_ins_id = us.subscriber_ins_id and t6.parent_offer_id <> '-1'--产品
left join files2.um_offer_sta_02 tt on t6.offer_ins_id = tt.offer_ins_id
left join ac2.am_bill_item bi on bi.acct_id=fca.acct_id and bi.balance>0 ---未消账单
left join ac2.am_entrust_relation er on  er.acct_id=fca.acct_id
join files2.um_address t on t.cust_id=c.cust_id
join rep.v_addr_set_js gis on t.std_addr_id = gis.segm_id
--left join ac2.am_entrust_relation rela on  fca.acct_id= rela.acct_id
where c.own_corp_org_id =3303
and c.cust_type = '1'
and fca.pay_type<>'1' -- 朱： 1现金
and t6.PROD_SERVICE_ID = 1002
and rat.rest_balance/100 <30
and t.expire_date>sysdate
and er.state=0  ---0是有效，1是失效，也就是解约了
and bi.bill_month='202305'  ----代扣为上月账单---修改 2
and tt.offer_status = '1'--开通客户
--and rela.state <> 0 ---0是有效，1是失效，也就是解约了，1也 还是代扣的，要看files.cm_account表里面的pay_type
and us.main_subscriber_ins_id=0
and not exists(--不存在期间内有成功代扣的客户，不能算失败了
   select 1 from ac2.am_entrust_create_dtl dt
   where dt.acct_id =  fca.acct_id
   and to_char(dt.create_time,'yyyymm') ='202306'---------------------修改3 按月.！！！！修改！！！修改！！！！！修改！！！
   and dt.state =3 and dt.is_err is null
    )--state = 3 is_err is null 成功
--3 然后is_err 不为空 失败   --4是不扣，实际没有发给银行
