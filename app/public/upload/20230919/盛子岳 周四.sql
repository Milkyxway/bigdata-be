/*--20220916  ��ַʧЧ �ų��¡�8510013311945,Ǩ��
select * from   files2.um_address t,cp2.cm_customer c ,rep.v_addr_set_js gis
where t.cust_id=c.cust_id
and t.std_addr_id = gis.segm_id
and c.cust_code = '8510013326011'--,'8510013311945'
and t.expire_date>sysdate 
*/


--1  �ֽ�ɷ� ���С��30

select distinct c.cust_code �ͻ�֤��,p.party_name ����������,
gis.stand_name ��ַ,gis.region_name ����,
gis.village_name||'-'||gis.building_name||'-'||gis.segm_name ��ַ, ---�¾۶��Ų�����ϸ��ַ��ֻ��С��
gis.village_name С��,
ccci.cont_number,ccci.family_number,ccci.cont_number2,ccci.family_number2,/*rat.balance/100 ����ǰ���,*/rat.rest_balance/100 ���������,
--ccci.bank_name �������� ,
--fca.pay_mode,--rela.state ,
--fca.pay_type,
(case  when tt.offer_status = '1' and tt.os_status is null then
                   '����'
                  when tt.offer_status = '3' and tt.os_status = '1' then
                   'Ƿͣ'
                  when tt.offer_status = '3' and tt.os_status = '3' then
                   '��ͣ'
                  when tt.offer_status = '99' then
                   '���״̬'
                end) srvpkg_state
from cp2.cm_customer c  
--join wx_region_address_rel dd on c.cust_id=dd.cust_id
left join rep2.rep_fact_cust_info_20230620 ccci on c.cust_id=ccci.cust_id -----------�޸� 1
left join files2.cm_account fca on fca.cust_id=c.cust_id
left join ac2.am_busi_ext ext on ext.acct_id=fca.acct_id
left join cp2.cb_party p on p.party_id = c.party_id
left join wx_rep_account_temp rat on rat.acct_id=fca.acct_id
left join files2.um_subscriber us on us.cust_id=c.cust_id
left join files2.um_offer_06 t6 on  t6.subscriber_ins_id = us.subscriber_ins_id and t6.parent_offer_id <> '-1'--��Ʒ
left join files2.um_offer_sta_02 tt on t6.offer_ins_id = tt.offer_ins_id
--left join ac2.am_entrust_relation rela on  fca.acct_id= rela.acct_id
join files2.um_address t on t.cust_id=c.cust_id  and t.expire_date > sysdate
join rep.v_addr_set_js gis on t.std_addr_id = gis.segm_id
where c.own_corp_org_id =3303
and c.cust_type = '1'
and c.cust_level =1 ---�ͻ�������ͨ @1 ����cust_type=1
and fca.pay_type ='1' -- �죺 1�ֽ�
and t6.PROD_SERVICE_ID = 1002
and rat.rest_balance/100 <30
and tt.offer_status = '1'
and t.expire_date>sysdate  --��ַ��ǰ��Ч--
--and rela.state <> 0 ---0����Ч��1��ʧЧ��Ҳ���ǽ�Լ�ˣ�1Ҳ ���Ǵ��۵ģ�Ҫ��files.cm_account�������pay_type
and us.main_subscriber_ins_id=0
and not exists(select * from files2.um_offer_06 iof
where iof.offer_id in (800500211385,800600132727,800600131409,800600132763,800600131515,
800500211472,800600122638,800500211313,800500211471,800500211470,800500211307,800600132726,
800600132985,800600131408,800500211386,800500211309,800600132744,800600132729,800500211308,
800600132728,800500211473,800600132730,800600132731,800600132748,800600131513,800600131516,
800600122635
) and iof.cust_id = c.cust_id)  --�ų�����
and not exists (select 1 from ac2.am_busi busi where c.cust_id = busi.cust_id
and to_char(busi.create_date,'yyyymmdd') = to_char(sysdate,'yyyymmdd')
)




--2 ���´���û�п۵��Ŀ�ͨ�ͻ�

select distinct c.cust_code �ͻ�֤��,p.party_name ����������,
/*dd.std_addr_name ��ַ,*/gis.district_name ����,
gis.village_name/*||'-'||gis.building_name||'-'||gis.segm_name*/,
ccci.cont_number,ccci.family_number,ccci.cont_number2,ccci.family_number2,
/*rat.balance/100 ����ǰ���,*/rat.rest_balance/100 Ƿ�ѽ�� /*���������*/,
ccci.bank_name �������� ,
--fca.pay_mode,--rela.state ,
fca.pay_type,
(case  when tt.offer_status = '1' and tt.os_status is null then
                   '����'
                  when tt.offer_status = '3' and tt.os_status = '1' then
                   'Ƿͣ'
                  when tt.offer_status = '3' and tt.os_status = '3' then
                   '��ͣ'
                  when tt.offer_status = '99' then
                   '���״̬'
                end) srvpkg_state
from cp2.cm_customer c
join wx_region_address_rel dd on c.cust_id=dd.cust_id
left join rep2.rep_fact_cust_info_20230620 ccci on c.cust_id=ccci.cust_id ---------------------�޸� 1 
left join files2.cm_account fca on fca.cust_id=c.cust_id
left join ac2.am_busi_ext ext on ext.acct_id=fca.acct_id
left join cp2.cb_party p on p.party_id = c.party_id
left join wx_rep_account_temp rat on rat.acct_id=fca.acct_id
left join files2.um_subscriber us on us.cust_id=c.cust_id
left join files2.um_offer_06 t6 on  t6.subscriber_ins_id = us.subscriber_ins_id and t6.parent_offer_id <> '-1'--��Ʒ
left join files2.um_offer_sta_02 tt on t6.offer_ins_id = tt.offer_ins_id
left join ac2.am_bill_item bi on bi.acct_id=fca.acct_id and bi.balance>0 ---δ���˵�
left join ac2.am_entrust_relation er on  er.acct_id=fca.acct_id
join files2.um_address t on t.cust_id=c.cust_id
join rep.v_addr_set_js gis on t.std_addr_id = gis.segm_id
--left join ac2.am_entrust_relation rela on  fca.acct_id= rela.acct_id
where c.own_corp_org_id =3303
and c.cust_type = '1'
and fca.pay_type<>'1' -- �죺 1�ֽ�
and t6.PROD_SERVICE_ID = 1002
and rat.rest_balance/100 <30
and t.expire_date>sysdate
and er.state=0  ---0����Ч��1��ʧЧ��Ҳ���ǽ�Լ��
and bi.bill_month='202305'  ----����Ϊ�����˵�---�޸� 2
and tt.offer_status = '1'--��ͨ�ͻ�
--and rela.state <> 0 ---0����Ч��1��ʧЧ��Ҳ���ǽ�Լ�ˣ�1Ҳ ���Ǵ��۵ģ�Ҫ��files.cm_account�������pay_type
and us.main_subscriber_ins_id=0
and not exists(--�������ڼ����гɹ����۵Ŀͻ���������ʧ����
   select 1 from ac2.am_entrust_create_dtl dt
   where dt.acct_id =  fca.acct_id
   and to_char(dt.create_time,'yyyymm') ='202306'---------------------�޸�3 ����.���������޸ģ������޸ģ����������޸ģ�����
   and dt.state =3 and dt.is_err is null
    )--state = 3 is_err is null �ɹ�
--3 Ȼ��is_err ��Ϊ�� ʧ��   --4�ǲ��ۣ�ʵ��û�з�������
