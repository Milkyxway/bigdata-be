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
       sub.password ����,
       decode(segm.addr_in_type,
2140706,'HFC-FTTB+LAN',2140707,'  HFC-FTTLAN',2140708,'HFC-FTTB+EOC',2140700,'FTTB+LAN',2140701,'FTTH',2140702,'HFC',2140703,'FTTLAN',
2140704,'WLAN',2140705,'FTTB+EOC',2140709,'DOCSIS׼3.0',2140710,'DOCSIS3.0',
2140711,'C-DOCSIS',2140712,'FTTLAN+DOCSIS3.0',2140713,'FTTLAN+DOCSIS׼3.0',2140714,'FTTLAN+C-DOCSIS',2140715,'FTTH+DOCSIS3.0',2140716,'FTTH+DOCSIS׼3.0'
,2140717,'FTTH+C-DOCSIS',2140718,'FTTH+HFC',2140719,'FTTB+FTTH',
2140720,'DOCSIS2.0',2140721,'����˫�����縲��',2140722,'��������',2140723,'EOC˫�����縲��',2140724,'HFC+FTTB+LAN',2140725,'CMTS',
2140726,'C-CMTS',2140727,'EOC',2140728,'CM-FTTH',
2140729,'EOC-FTTH' ) ��������,
       res.res_equ_no ��Դ���,
       can.mobile1 �ƶ��绰1,
       can.mobile2 �ƶ��绰2,
       can.phone1 ��ϵ�绰1,
       can.phone2 ��ϵ�绰2,
       decode(acct.pay_type, 1, '�ֽ�', 3, '���д���') �ɷѷ�ʽ,
       -- ��������
       ofer.offer_name ��Ʒ���ƣ�
       ofer.valid_date ��Ʒ��Чʱ��,
       ofer.expire_date ��ƷʧЧʱ��,
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
                    case
                    when exists (select 1
                            from files2.um_offer_06 sp
                           where sp.cust_id = cus.cust_id
                             and sp.prod_service_id = 1002 and sp.expire_date>sysdate) then
                     '��'
                    else
                     null
                  end "�Ƿ����ߵ���",
                  k.prod_inst_id �Ƿ��Ծ,
                   
       ofer1.offer_name ��������,
       ofer1.valid_date ������Чʱ��,
       ofer1.expire_date ����ʧЧʱ��,
       ofer2.offer_name ԤԼ��������,
       ofer2.valid_date ԤԼ������Чʱ��
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
  left join files2.um_offer_06 ofer1
    on ofer1.subscriber_ins_id = sub.subscriber_ins_id
   and ofer1.prod_service_id = 0
   and ofer1.expire_date > sysdate --- �������
   and ofer.offer_id <> 800500000105
   and ofer1.parent_offer_id not in (800500130044,800500130042)
   and ofer1.offer_ins_id <>ofer.offer_ins_id
   and ofer1.valid_date< sysdate

    left join files2.um_offer_06 ofer2
    on ofer2.subscriber_ins_id = sub.subscriber_ins_id
   and ofer2.prod_service_id = 0
   and ofer2.expire_date > sysdate --- ԤԼ�������
   and ofer.offer_id <> 800500000105
   and ofer2.parent_offer_id not in (800500130044,800500130042)
   and ofer2.offer_ins_id <>ofer.offer_ins_id
   and ofer2.valid_date> sysdate
   left join (select * from REP.DWA_CRM_KD_BEHAVIOR_20230610 be
                          where be.corp_org_name like  '%�����ֹ�˾%'
               and  abs(nvl(be.play_duration, 0)) >= 10800
                           ) k on k.prod_inst_id = sub.subscriber_ins_id
 where sub.subscriber_type = 3 -- ���
   and sub.corp_org_id = 3303
   and ofer.offer_name <> '������_���4M_500Ԫ'
   and ofer.offer_name Not Like '%����%'
   and ofer.offer_name Not Like '%����%'
   and ofer.offer_name <> '��ͬ��Ʒ'
   and acct.acct_name not like '%����%'
and addr.district_name in ('��ׯ���վ')

