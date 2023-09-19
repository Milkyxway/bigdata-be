
select distinct cust.cust_code,
                cust.cust_id,
                acct.acct_name,
                um.bill_id,
                um.sub_bill_id,
                ures.res_sku_name,
                ures.res_sub_type_name,
                grid.GRID_NAME,
                addr.region_name2,       
                addr.std_addr_name,
                addr.VILLAGE_NAME С��, addr.BUILDING_NAME ¥��,
                addr.mobile1,
                addr.phone1,
                addr.mobile2,
                addr.phone2,
                case when exists(select 1
          from files2.um_offer_06 ppi where  ppi.subscriber_ins_id =um.subscriber_ins_id
           and ppi.offer_name like '%FTTH�뻧�����Ż�%'
           and ppi.expire_date > sysdate) then 'FTTH�뻧�����Ż�'
          else null end  "������FTTH����Ż�",
to_char(ures1.Create_Date,'yyyymmdd') ��èʱ��,
ures1.res_equ_no ��è����,
decode(ures1.res_sku_id,1153929,'����һ',1153930,'����һ',1153909 ,'FTTHè_����ʽ������)',1151326,'FTTHè') ��è�ͺ�,
                decode(acct.pay_type, 1, '�ֽ�',2, '֧��������', 3, '���д���') �ɷѷ�ʽ,
                case
                  when exists (select 1
                          from files2.um_offer_06 sp1
                         where sp1.cust_id = um.cust_id
                           and sp1.prod_service_id = 1003
                           and sp1.expire_date > sysdate) then
                   '����'
                  else
                   null
                end "�Ƿ񻥶��ͻ�",
                                case
                  when exists
                   (select 1
                          from files2.um_offer_06 sp1
                         where sp1.subscriber_ins_id = um.subscriber_ins_id
                           and sp1.prod_service_id = 1003
                        -- and  t.main_spec_id = 80020199= 80020199
                           and sp1.expire_date > sysdate
                      ) and  nvl(um.main_subscriber_ins_id,0) = 0 then
                   '��'    
                    when exists
                   (select 1
                          from files2.um_offer_06 sp1,files2.um_SUBSCRIBER sub
                           where sub.subscriber_ins_id = sub.subscriber_ins_id and sub.cust_id =cust.cust_id 
                           and sp1.prod_service_id = 1003
                          and  sub.main_spec_id = 80020199
                           and sp1.expire_date > sysdate
                      ) and  nvl(um.main_subscriber_ins_id,0) = 0 then
                   '��'    
                    when exists
                   (select 1
                          from files2.um_offer_06 sp1
                         where sp1.subscriber_ins_id = um.subscriber_ins_id
                           and (sp1.offer_name in ('���廥����Ʒ_10Ԫ/��_����','���廥����Ʒ_8Ԫ/��_����' ))
                           and sp1.expire_date > sysdate
                      ) and  nvl(um.main_subscriber_ins_id,0) <> 0 then
                   '��'
                   else
                   null
                end "�Ƿ񻥶��ն�",
         
                case
                  when exists (select 1
                          from files2.um_SUBSCRIBER p0
                         where p0.cust_id = cust.cust_id
                           and p0.SUBSCRIBER_type = 3) then
                   '�п��'
                  else
                   null
                end "�Ƿ��п��",
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
           
                decode(cust.cust_type,
                       1,
                       '���ڿͻ�',
                       4,
                       '��ͨ��ҵ�ͻ�',
                       7,
                       '��ͬ��ҵ�ͻ�') �ͻ�����, -- substr(cus.cust_cert_no,7,4) ������� ,
                decode(acct.pay_type, 1, '�ֽ�', 2, '���д���') �ɷѷ�ʽ
  from files2.um_SUBSCRIBER   um,
        files2.um_res          ures,
         files2.um_res          ures1,
       files2.um_offer_06     sp,
       files2.um_offer_sta_02 tt,
       cp2.cm_customer        cust,
       files2.cm_account      acct,
       SZJFGRID.CUST_TOJF     grid_rel,
       szjfgrid.grid_tojf     grid,  
    files2.um_address t��
     rep.v_addr_set_js setjs��
       wx.wx_cust_addr        addr,
       resnjgd.addr_segm      segm
 where um.subscriber_ins_id = ures.subscriber_ins_id
 and  ures1.cust_id = um.cust_id
   and um.subscriber_type = 1
   and um.subscriber_ins_id = sp.subscriber_ins_id
   and sp.offer_ins_id = tt.offer_ins_id
   --and segm.segm_name = addr.segm_name(+)
  and  setjs.segm_id = segm.segm_id(+)
   and t.door_name(+) = setjs.set_addr_id
   and t.cust_id =cust.cust_id
   and ures.res_type_id =2
  and sp.prod_service_id = 1002
  and sp.expire_date >sysdate
   and cust.cust_id = um.cust_id
   and acct.cust_id = cust.cust_id
  and ures.expire_date > sysdate
   and cust.corp_org_id = 3303
   and grid_rel.cust_code(+) = cust.cust_code
   and grid_rel.ms_area_id = grid.grid_id(+)
   and addr.cust_id(+) = cust.cust_id
   and cust.cust_type = '1'
   --and to_char(ures1.create_date,'yyyy') = '2022'
 and ures1.expire_date > sysdate
   and ures1.res_sku_id  in ( '1153930','1153929','1153909'��'1151326') 
   --and addr.region_name in ('�������վ')
   and (      addr.village_name like '%��ɽ�����¥%'
                       or addr.village_name like '%������·��ͷ��Ʒ��%'
                                   or addr.village_name like '%��������%'
                                   or addr.village_name like '%����ͷ��%'
                                     or addr.village_name like '%����·%'
                                   or addr.village_name like '%��ʿ����%'
                                   or addr.village_name like '%�����´�%'
                                   or addr.village_name like '%����С��%'
                                   or addr.village_name like '%��ͨС��%'
                                   or addr.village_name like '%����С��%'
                                   or addr.village_name like '%������Ԣ%'
                                 or addr.village_name like '%����·����%'
                                     or addr.village_name like '%����Է%'
                                 or addr.village_name like '%����Է����%'
                                     or addr.village_name like '%¡ͤԷ%'
                                   or addr.village_name like '%��Ȫ��·%'
                                   or addr.village_name like '%���廨԰%'
                               or addr.village_name like '%���廨԰����%'
                                   or addr.village_name like '%��Է�´�%'
                                   or addr.village_name like '%��¥�´�%'
                               or addr.village_name like '%ׯ�Ŵ�ţ����%'
                                   or addr.village_name like '%��ׯС��%'
                                   or addr.village_name like '%�糧����%'
                                   or addr.village_name like '%�跢��԰%'
                                   or addr.village_name like '%���޶�·%'
                                   or addr.village_name like '%�¹�С��%'
                                     or addr.village_name like '%ҹ����%'
                                 or addr.village_name like '%����Է����%'
                                   or addr.village_name like '%��Է����%'
                                   or addr.village_name like '%������%'
                                   or addr.village_name like '%���һ��%'
                           or addr.village_name like '%����·(����Ƭ��)%'
                                   or addr.village_name like '%�������%'
                                   or addr.village_name like '%��������%'
                                   or addr.village_name like '%����һ��%'
                                     or addr.village_name like '%�ɻ���%'
                                     or addr.village_name like '%��Ҷ��%'
                                     or addr.village_name like '%ʯ����%'
                                   or addr.village_name like '%����´�%'
                                     or addr.village_name like '%Ұ��԰%'
                                   or addr.village_name like '%ׯǰ�´�%'
                                     or addr.village_name like '%������%'
                           or addr.village_name like '%����·(����Ƭ��)%'
                                   or addr.village_name like '%���׹�Ԣ%'
                                   or addr.village_name like '%��ׯһ��%'
                                   or addr.village_name like '%��ׯ��·%'
                                   or addr.village_name like '%��ׯ��·%'
                                     or addr.village_name like '%�۽�Է%'
                       or addr.village_name like '%��ׯ��·������˾����%'
                                     or addr.village_name like '%ѧʿ·%'



)
 

  create table tmp_20230817_zy(rownumb number, cust_code varchar(255))
 select * from tmp_20230817_zy for update
 delete from tmp_18_cust
 drop table tmp_18_cust

