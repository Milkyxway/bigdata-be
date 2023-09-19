

--各站开通状态的高清以及4K终端明细（证号、姓名、所属网格、地址、联系方式、机号、卡号、
--机顶盒类型、是否互动、互动产品起订日期、是否好视乐、是否看视界、缴费方式，用户状态）

select distinct cust.cust_code,
                acct.acct_name,
                um.bill_id,
                um.sub_bill_id,
                ures.res_type_name,
                ures.res_sku_name,
                grid.GRID_NAME,
                addr.region_name2,
                addr.std_addr_name,
                addr.mobile1,
                addr.phone1,
                addr.mobile2,
                addr.phone2,
                decode(acct.pay_type, 1, '现金', 3, '银行代扣') 缴费方式,
             /*   case
                  when exists
                   (select 1
                          from files2.um_offer_06 sp1
                         where sp1.subscriber_ins_id = um.subscriber_ins_id
                           and sp1.prod_service_id = 1003
                           and sp1.expire_date > sysdate) then
                   '互动'
                  else
                   null
                end "是否互动",*/
                   case
                  when exists
                   (select 1
                          from files2.um_offer_06 sp1
                         where sp1.subscriber_ins_id = um.subscriber_ins_id
                           and sp1.prod_service_id = 1003
                        -- and  t.main_spec_id = 80020199= 80020199
                           and sp1.expire_date > sysdate
                      ) and  nvl(um.main_subscriber_ins_id,0) = 0 then
                   '是'    
                   when exists
                   (select 1
                          from files2.um_offer_06 sp1,files2.um_SUBSCRIBER sub
                           where sp1.subscriber_ins_id = sub.subscriber_ins_id and sub.cust_id =cust.cust_id 
                           and sp1.prod_service_id = 1003
                          and  sub.main_spec_id = 80020199
                           and sp1.expire_date > sysdate
                      ) and  nvl(um.main_subscriber_ins_id,0) = 0 then
                   '是'    
                   when exists
                   (select 1
                          from files2.um_offer_06 sp1
                         where sp1.subscriber_ins_id = um.subscriber_ins_id
                           and (sp1.offer_name in ('高清互动产品_10元/月_无锡','高清互动产品_8元/月_无锡' ))
                           and sp1.expire_date > sysdate
                      ) and  nvl(um.main_subscriber_ins_id,0) <> 0 then
                   '是'
                   else
                   null
                end "是否互动终端",
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
                            from files2.um_SUBSCRIBER p0
                           where p0.cust_id = cust.cust_id
                             and p0.SUBSCRIBER_type = 3) then
                     '有宽带'
                    else
                     null
                  end "是否有宽带",
                  --sp1.offer_name 
                    cm.res_sku_name 配置猫名称  ,cm.res_equ_no 配置猫序列号 ,cm.create_date 配置猫时间
  from files2.um_SUBSCRIBER um,
       files2.um_res ures,
       files2.um_offer_06 sp,
       files2.um_offer_sta_02 tt,
       cp2.cm_customer cust,
       files2.cm_account acct,
       SZJFGRID.CUST_TOJF grid_rel,
        szjfgrid.grid_tojf grid,
 wx.wx_cust_addr addr,
        -- files2.um_offer_06 sp1，
            (select res1.create_date  create_date ,res1.res_equ_no res_equ_no,res1.res_sku_name res_sku_name,res1.subscriber_ins_id subscriber_ins_id
  from files2.um_res res1,files2.um_SUBSCRIBER um1
where  res1.subscriber_ins_id = um1.subscriber_ins_id
 and res1.res_sku_id in ('1153930','1153929','1153909'，'1151326')
 and res1.expire_date> sysdate
) cm 
      
 where um.subscriber_ins_id = ures.subscriber_ins_id
   and um.subscriber_type = 1
   and cm.subscriber_ins_id(+) = um.subscriber_ins_id
   and um.subscriber_ins_id = sp.subscriber_ins_id
   and ures.res_type_id = 2
   and sp.offer_ins_id = tt.offer_ins_id
   and sp.prod_service_id = 1002
   and sp.expire_date > sysdate

   and cust.cust_id = um.cust_id
   and acct.cust_id(+) = cust.cust_id
   and ures.expire_date > sysdate
   and cust.corp_org_id = 3303
   and grid_rel.cust_code(+) = cust.cust_code
   and grid_rel.ms_area_id = grid.grid_id(+)
   and addr.cust_id(+) = cust.cust_id

 and addr.region_name in ('安镇广电站')
 and addr.std_addr_name like '%鑫安三期%'
 /* and um.subscriber_ins_id = sp1.subscriber_ins_id
    and sp1.expire_date> sysdate 
   and sp1.offer_name like '%名师讲坛%'


  and  exists (select 1 from files2.um_offer_06  ofer1 where ofer1.subscriber_ins_id =  um.subscriber_ins_id
   and ofer1.expire_date> sysdate 
   and ofer1.offer_name like '%名师讲坛%'
   )

*/

