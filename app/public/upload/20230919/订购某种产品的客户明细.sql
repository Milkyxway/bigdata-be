select distinct cust.cust_code ֤��,
                acct.acct_name ����,
                --cust_old.cust_cert_no,
                --����
                addr.stand_name ��ַ,
               addr.cont_number,
                addr.family_number,
                addr.cont_number2,
                addr.family_number2,
                grid.grid_name ����,
                (case
                  when tt.offer_status = '1' and tt.os_status is null then
                   '����'
                  when tt.offer_status = '3' and tt.os_status = '1' then
                   'Ƿͣ'
                  when tt.offer_status = '3' and tt.os_status = '3' then
                   '��ͣ'
                  when tt.offer_status = '3' and tt.os_status = '6' then
                   '����ͣ'
                  when tt.offer_status = '3' and tt.os_status = '4' then
                   '����ͣ'
                  when tt.offer_status = '99' then
                   '���״̬'
                  ELSE
                   '����'
                end),
                decode(acct.pay_type, 1, '�ֽ�', 3, '���д���') �ɷѷ�ʽ,
                case
                  when exists (select 1
                          from files2.um_offer_06 sp
                         where sp.cust_id = cust.cust_id
                           and sp.prod_service_id = 1003
                           and sp.expire_date > sysdate) then
                   '�����ͻ�'
                  else
                   null
                end "�Ƿ񻥶��ͻ�",
                case
                  when exists
                   (select 1
                          from files2.um_offer_06   sp1,
                               files2.um_SUBSCRIBER sub
                         where sp1.subscriber_ins_id = sub.subscriber_ins_id
                           and sub.cust_id = cust.cust_id
                           and sp1.prod_service_id = 1003
                           and sub.main_spec_id = 80020199
                           and sp1.expire_date > sysdate) then
                   '��'
                  else
                   null
                end "�Ƿ��пͻ�������",
                case
                  when exists (select 1
                          from files2.um_offer_06 sp
                         where sp.cust_id = cust.cust_id
                           and sp.prod_service_id = 1004
                           and sp.expire_date > sysdate) then
                   '�п��'
                  else
                   null
                end "�Ƿ��п��",
                Count(Distinct Case
                        When exists
                         (select *
                                from files2.um_res ures
                               where um.subscriber_ins_id = ures.subscriber_ins_id
                                 and ures.res_sub_type_name like '%����%'
                                 and ures.expire_date > sysdate
                                 ) Then
                         um.subscriber_ins_id
                        Else
                         Null
                      End) �����ն���,
                Count(Distinct Case
                        When exists
                         (select 1
                                from files2.um_res ures
                               where um.subscriber_ins_id = ures.subscriber_ins_id
                                 and ures.res_sub_type_name like '%����%'
                                   and ures.expire_date > sysdate) Then
                         um.subscriber_ins_id
                        Else
                         Null
                      End) �����ն���,
                writeoff.writeoff_fee / 100,
                rap.rest_balance / 100,
                ofer1.offer_name,
                ofer1.create_date,
                ofer1.expire_date
  from cp2.cm_customer   cust,
  --so1.cm_customer@szrep cust_old,
       files2.cm_account acct,
       rep2.rep_fact_cust_info_20230523   addr,
       wx_region_address_rel can,
       SZJFGRID.CUST_TOJF grid_rel,
       szjfgrid.grid_tojf grid,
       files2.um_subscriber um,
       files2.um_subscriber um1,
       files2.um_offer_06 ofer,
        files2.um_offer_06 ofer1,
       files2.um_offer_sta_02 tt,
       (select distinct t.acct_id, sum(t.writeoff_fee) writeoff_fee
          from (select acct_id, writeoff_fee
                  from ac2.am_writeoff t
                 where t.cancel_flag <> 'C'
                   and t.bill_month = '202305' --ʵ����
                union all
                select acct_id, writeoff_fee
                  from ac2.am_writeoff_d
                 where bill_month = '202305') t -- ������  writeoff_fee��ʵ�����
         group by t.acct_id) writeoff,
       wx_rep_account_temp rap/*,
       temp_11 temp*/
 where cust.cust_id = acct.acct_id(+)
   and addr.cust_id(+) = cust.cust_id
 --  and cust.cust_code = cust_old.cust_code(+)
/*   and temp.cust_code =cust.cust_code
*/   and writeoff.acct_id(+) = cust.cust_id
   and rap.cust_id(+) = cust.cust_id
      and can.cust_id(+) = cust.cust_id
   and grid_rel.cust_code(+) = cust.cust_code
   and grid_rel.ms_area_id = grid.grid_id(+)
      /*    and ofer.subscriber_ins_id = um.subscriber_ins_id
      and ofer.prod_service_id = 1002 --������
      and ofer.subscriber_ins_id = um1.subscriber_ins_id
      and nvl(um1.main_SUBSCRIBER_ins_id, 0) = 0 --����
      and ofer.offer_ins_id = tt.offer_ins_id*/
      
   and ofer.cust_id = cust.cust_id
   and ofer.prod_service_id = 1002 --������
   and ofer.subscriber_ins_id = um1.subscriber_ins_id
   and nvl(um1.main_SUBSCRIBER_ins_id, 0) = 0 --����
   and ofer.offer_ins_id = tt.offer_ins_id
   and ofer.expire_date > sysdate
   and um1.subscriber_type = 1 -- ������
      
   and um.cust_id = cust.cust_id
   and um.subscriber_type = 1 -- ������
   and cust.corp_org_id = 3303
  
   and ofer1.cust_id = cust.cust_id
   --and ofer1.offer_name like '%â��TV%'
   and ofer1.parent_offer_id = -1
   and ofer1.expire_date > sysdate
/* and   exists (select 1 from files2.um_offer_06  ofer1 where ofer1.cust_id = cust.cust_id
   and ofer1.expire_date> sysdate 
   and (ofer1.offer_name like '%���ӽ�-����%'
)
   )
     and  exists (select 1 from files2.um_offer_06  ofer1 where ofer1.cust_id =  cust.cust_id
   and ofer1.expire_date> sysdate 
   and ofer1.offer_name like '%����%24%'
   )*/

/*  and  exists (select 1 from files2.um_offer_06  ofer1 where ofer1.cust_id = cust.cust_id
   and ofer1.expire_date> sysdate and ofer1.offer_name like '%���廥��%8%'
   )
     and  exists (select 1 from files2.um_offer_06  ofer1 where ofer1.cust_id = cust.cust_id
   and ofer1.expire_date> sysdate and ofer1.offer_name like '%����%24%'
   )*/
   --and can.region_name in ('���Ź��վ')
and addr.village_name like '%������%'
 group by cust.cust_code,
          acct.acct_name,
          -- cust_old.cust_cert_no,
          --����
                   addr.stand_name ,
               addr.cont_number,
                addr.family_number,
                addr.cont_number2,
                addr.family_number2,
          grid.grid_name,
          (case
            when tt.offer_status = '1' and tt.os_status is null then
             '����'
            when tt.offer_status = '3' and tt.os_status = '1' then
             'Ƿͣ'
            when tt.offer_status = '3' and tt.os_status = '3' then
             '��ͣ'
            when tt.offer_status = '3' and tt.os_status = '6' then
             '����ͣ'
            when tt.offer_status = '3' and tt.os_status = '4' then
             '����ͣ'
            when tt.offer_status = '99' then
             '���״̬'
            ELSE
             '����'
          end),
          decode(acct.pay_type, 1, '�ֽ�', 3, '���д���'),
          case
            when exists (select 1
                          from files2.um_offer_06 sp
                         where sp.cust_id = cust.cust_id
                           and sp.prod_service_id = 1003
                           and sp.expire_date > sysdate) then
             '�����ͻ�'
            else
             null
          end,case
                  when exists
                   (select 1
                          from files2.um_offer_06   sp1,
                               files2.um_SUBSCRIBER sub
                         where sp1.subscriber_ins_id = sub.subscriber_ins_id
                           and sub.cust_id = cust.cust_id
                           and sp1.prod_service_id = 1003
                           and sub.main_spec_id = 80020199
                           and sp1.expire_date > sysdate) then
                   '��'
                  else
                   null
                end,
          case
            when exists (select 1
                          from files2.um_offer_06 sp
                         where sp.cust_id = cust.cust_id
                           and sp.prod_service_id = 1004
                           and sp.expire_date > sysdate) then
             '�п��'
            else
             null
          end,
          writeoff.writeoff_fee,
          rap.rest_balance,
           ofer1.offer_name,
                ofer1.create_date,
                ofer1.expire_date
          
     
