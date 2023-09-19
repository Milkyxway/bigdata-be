select distinct addr.district_name 广电站,
       sub.subscriber_ins_id,
       cus.cust_id,
       addr.village_name 小区,
       addr.building_name 楼栋,
       grid.GRID_NAME 网格名称,
       cus.cust_code 客户证号,
       acct.acct_name 客户名称,
       addr.stand_name 地址,
       sub.login_name 宽带名,
       sub.password 密码,
       decode(segm.addr_in_type,
2140706,'HFC-FTTB+LAN',2140707,'  HFC-FTTLAN',2140708,'HFC-FTTB+EOC',2140700,'FTTB+LAN',2140701,'FTTH',2140702,'HFC',2140703,'FTTLAN',
2140704,'WLAN',2140705,'FTTB+EOC',2140709,'DOCSIS准3.0',2140710,'DOCSIS3.0',
2140711,'C-DOCSIS',2140712,'FTTLAN+DOCSIS3.0',2140713,'FTTLAN+DOCSIS准3.0',2140714,'FTTLAN+C-DOCSIS',2140715,'FTTH+DOCSIS3.0',2140716,'FTTH+DOCSIS准3.0'
,2140717,'FTTH+C-DOCSIS',2140718,'FTTH+HFC',2140719,'FTTB+FTTH',
2140720,'DOCSIS2.0',2140721,'光纤双向网络覆盖',2140722,'单向网络',2140723,'EOC双向网络覆盖',2140724,'HFC+FTTB+LAN',2140725,'CMTS',
2140726,'C-CMTS',2140727,'EOC',2140728,'CM-FTTH',
2140729,'EOC-FTTH' ) 所属区域,
       res.res_equ_no 资源编号,
       can.mobile1 移动电话1,
       can.mobile2 移动电话2,
       can.phone1 联系电话1,
       can.phone2 联系电话2,
       decode(acct.pay_type, 1, '现金', 3, '银行代扣') 缴费方式,
       -- 所属区域
       ofer.offer_name 产品名称，
       ofer.valid_date 产品生效时间,
       ofer.expire_date 产品失效时间,
       (case
                    when tt.offer_status = '1' and tt.os_status is null then
                     '正常'
                    when tt.offer_status = '3' and tt.os_status = '1' then
                     '欠停'
                    when tt.offer_status = '3' and tt.os_status = '3' then
                     '暂停'
                    when tt.offer_status = '3' and tt.os_status = '6' then
                     '剪线停'
                    when tt.offer_status = '3' and tt.os_status = '4' then
                     '管理停'
                    when tt.offer_status = '99' then
                     '割接状态'
                    ELSE
                     '其他'
                  end),
                    case
                    when exists (select 1
                            from files2.um_offer_06 sp
                           where sp.cust_id = cus.cust_id
                             and sp.prod_service_id = 1002 and sp.expire_date>sysdate) then
                     '有'
                    else
                     null
                  end "是否有线电视",
                  k.prod_inst_id 是否活跃,
                   
       ofer1.offer_name 促销名称,
       ofer1.valid_date 促销生效时间,
       ofer1.expire_date 促销失效时间,
       ofer2.offer_name 预约促销名称,
       ofer2.valid_date 预约促销生效时间
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
  left join files2.um_res res --- 可以用此表获取宽带的序列号
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
   and ofer.offer_id <> 800500000105 --- 宽带产品
   left join files2.um_offer_sta_02  tt on tt.offer_ins_id = ofer.offer_ins_id
  left join files2.um_offer_06 ofer1
    on ofer1.subscriber_ins_id = sub.subscriber_ins_id
   and ofer1.prod_service_id = 0
   and ofer1.expire_date > sysdate --- 宽带促销
   and ofer.offer_id <> 800500000105
   and ofer1.parent_offer_id not in (800500130044,800500130042)
   and ofer1.offer_ins_id <>ofer.offer_ins_id
   and ofer1.valid_date< sysdate

    left join files2.um_offer_06 ofer2
    on ofer2.subscriber_ins_id = sub.subscriber_ins_id
   and ofer2.prod_service_id = 0
   and ofer2.expire_date > sysdate --- 预约宽带促销
   and ofer.offer_id <> 800500000105
   and ofer2.parent_offer_id not in (800500130044,800500130042)
   and ofer2.offer_ins_id <>ofer.offer_ins_id
   and ofer2.valid_date> sysdate
   left join (select * from REP.DWA_CRM_KD_BEHAVIOR_20230610 be
                          where be.corp_org_name like  '%无锡分公司%'
               and  abs(nvl(be.play_duration, 0)) >= 10800
                           ) k on k.prod_inst_id = sub.subscriber_ins_id
 where sub.subscriber_type = 3 -- 宽带
   and sub.corp_org_id = 3303
   and ofer.offer_name <> '开户惠_宽带4M_500元'
   and ofer.offer_name Not Like '%宽带活动%'
   and ofer.offer_name Not Like '%按天%'
   and ofer.offer_name <> '合同产品'
   and acct.acct_name not like '%测试%'
and addr.district_name in ('旺庄广电站')

