select distinct addr.district_name ���վ,
       sub.subscriber_ins_id,
       cus.cust_id,
       addr.village_name С��,
       addr.building_name ¥��,
       grid.GRID_NAME ��������,
       cus.cust_code �ͻ�֤��,
       acct.acct_name �ͻ�����,
       addr.stand_name ��ַ,
       sub.login_name �����,
       to_char(res.Create_Date,'yyyymmdd') ��èʱ��,
res.res_equ_no ��è����,
decode(res.res_sku_id,1153929,'����һ',1153930,'����һ',1153909 ,'FTTHè_����ʽ������)',1151326,'FTTHè') ��è�ͺ�
  from files2.um_subscriber sub
  left join cp2.cm_customer cus
    on sub.cust_id = cus.cust_id
  left join files2.cm_account acct
    on acct.cust_id = cus.cust_id
  left join files2.um_address t
    on t.cust_id = cus.cust_id
    and t.expire_date >sysdate
  left join rep.v_addr_set_js addr
    on t.door_name = addr.set_addr_id
    left join resnjgd.addr_segm segm
    on addr.segm_id = segm.segm_id
  left join SZJFGRID.CUST_TOJF grid_rel
    on grid_rel.cust_code = cus.cust_code
  left join szjfgrid.grid_tojf grid
    on grid_rel.ms_area_id = grid.grid_id
  left join files2.um_res res --- �����ô˱��ȡ��������к�
    on res.subscriber_ins_id = sub.subscriber_ins_id
      and res.expire_date >sysdate
  left join wx.wx_cust_contact_info can
    on can.cust_id = cus.cust_id
  left join files2.um_offer_06 ofer
    on ofer.subscriber_ins_id = sub.subscriber_ins_id
   and ofer.parent_offer_id <> -1
   and ofer.prod_service_id = 1004
   and ofer.expire_date > sysdate
   and ofer.valid_date < sysdate
   and ofer.offer_id <> 800500000105 --- �����Ʒ
   left join files2.um_offer_sta_02  tt on tt.offer_ins_id = ofer.offer_ins_id

 where sub.subscriber_type = 3 -- ���
   and sub.corp_org_id = 3303
   and ofer.offer_name <> '������_���4M_500Ԫ'
   and ofer.offer_name Not Like '%����%'
   and ofer.offer_name Not Like '%����%'
   and ofer.offer_name <> '��ͬ��Ʒ'
   and acct.acct_name not like '%����%'

 and not exists (select 1 from files2.um_offer_06 pk2 where pk2.prod_service_id=1002 and    pk2.cust_id=cus.cust_id)--û�����ֵ���
and not exists(select 1 from files2.um_offer_06 pk3 where pk3.prod_service_id=1003 and    pk3.cust_id=cus.cust_id)--û�л���
and res.res_sku_id  in  ( '1153930','1153929','1153909'��'1151326') 
--and to_char(res.create_date,'yyyy') = '2022'
--and addr.district_name in ('�������վ')
and (    addr.village_name like '%��ɽ�����¥%'
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












