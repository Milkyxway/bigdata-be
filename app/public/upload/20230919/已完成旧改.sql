
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
                addr.VILLAGE_NAME 小区, addr.BUILDING_NAME 楼栋,
                addr.mobile1,
                addr.phone1,
                addr.mobile2,
                addr.phone2,
                case when exists(select 1
          from files2.um_offer_06 ppi where  ppi.subscriber_ins_id =um.subscriber_ins_id
           and ppi.offer_name like '%FTTH入户改造优惠%'
           and ppi.expire_date > sysdate) then 'FTTH入户改造优惠'
          else null end  "机顶盒FTTH入改优惠",
to_char(ures1.Create_Date,'yyyymmdd') 光猫时间,
ures1.res_equ_no 光猫号码,
decode(ures1.res_sku_id,1153929,'三合一',1153930,'二合一',1153909 ,'FTTH猫_独立式（无锡)',1151326,'FTTH猫') 光猫型号,
                decode(acct.pay_type, 1, '现金',2, '支付宝代扣', 3, '银行代扣') 缴费方式,
                case
                  when exists (select 1
                          from files2.um_offer_06 sp1
                         where sp1.cust_id = um.cust_id
                           and sp1.prod_service_id = 1003
                           and sp1.expire_date > sysdate) then
                   '互动'
                  else
                   null
                end "是否互动客户",
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
                           where sub.subscriber_ins_id = sub.subscriber_ins_id and sub.cust_id =cust.cust_id 
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
         
                case
                  when exists (select 1
                          from files2.um_SUBSCRIBER p0
                         where p0.cust_id = cust.cust_id
                           and p0.SUBSCRIBER_type = 3) then
                   '有宽带'
                  else
                   null
                end "是否有宽带",
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
           
                decode(cust.cust_type,
                       1,
                       '公众客户',
                       4,
                       '普通商业客户',
                       7,
                       '合同商业客户') 客户类型, -- substr(cus.cust_cert_no,7,4) 出身年份 ,
                decode(acct.pay_type, 1, '现金', 2, '银行代扣') 缴费方式
  from files2.um_SUBSCRIBER   um,
        files2.um_res          ures,
         files2.um_res          ures1,
       files2.um_offer_06     sp,
       files2.um_offer_sta_02 tt,
       cp2.cm_customer        cust,
       files2.cm_account      acct,
       SZJFGRID.CUST_TOJF     grid_rel,
       szjfgrid.grid_tojf     grid,  
    files2.um_address t，
     rep.v_addr_set_js setjs，
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
   and ures1.res_sku_id  in ( '1153930','1153929','1153909'，'1151326') 
   --and addr.region_name in ('湖滨广电站')
   and (      addr.village_name like '%阳山镇五层楼%'
                       or addr.village_name like '%人民南路大井头商品房%'
                                   or addr.village_name like '%留芳声巷%'
                                   or addr.village_name like '%东河头巷%'
                                     or addr.village_name like '%崇宁路%'
                                   or addr.village_name like '%进士坊巷%'
                                   or addr.village_name like '%曹张新村%'
                                   or addr.village_name like '%锦旺小区%'
                                   or addr.village_name like '%锡通小区%'
                                   or addr.village_name like '%梓旺小区%'
                                   or addr.village_name like '%东华公寓%'
                                 or addr.village_name like '%府北路店面%'
                                     or addr.village_name like '%金锡苑%'
                                 or addr.village_name like '%金锡苑二期%'
                                     or addr.village_name like '%隆亭苑%'
                                   or addr.village_name like '%二泉东路%'
                                   or addr.village_name like '%锦绣花园%'
                               or addr.village_name like '%锦绣花园别墅%'
                                   or addr.village_name like '%竹苑新村%'
                                   or addr.village_name like '%门楼新村%'
                               or addr.village_name like '%庄桥村牛车桥%'
                                   or addr.village_name like '%柏庄小区%'
                                   or addr.village_name like '%电厂家舍%'
                                   or addr.village_name like '%鸿发家园%'
                                   or addr.village_name like '%锡洲东路%'
                                   or addr.village_name like '%新光小区%'
                                     or addr.village_name like '%夜巴黎%'
                                 or addr.village_name like '%云林苑南区%'
                                   or addr.village_name like '%竹苑南区%'
                                   or addr.village_name like '%广丰二村%'
                                   or addr.village_name like '%广丰一村%'
                           or addr.village_name like '%广勤路(广瑞片区)%'
                                   or addr.village_name like '%广瑞二村%'
                                   or addr.village_name like '%广瑞三村%'
                                   or addr.village_name like '%广瑞一村%'
                                     or addr.village_name like '%荷花里%'
                                     or addr.village_name like '%荷叶村%'
                                     or addr.village_name like '%石人桥%'
                                   or addr.village_name like '%五河新村%'
                                     or addr.village_name like '%野花园%'
                                   or addr.village_name like '%庄前新村%'
                                     or addr.village_name like '%江阴巷%'
                           or addr.village_name like '%广瑞路(广瑞片区)%'
                                   or addr.village_name like '%春雷公寓%'
                                   or addr.village_name like '%柏庄一村%'
                                   or addr.village_name like '%柏庄中路%'
                                   or addr.village_name like '%柏庄北路%'
                                     or addr.village_name like '%聚江苑%'
                       or addr.village_name like '%柏庄北路商联公司家舍%'
                                     or addr.village_name like '%学士路%'



)
 

  create table tmp_20230817_zy(rownumb number, cust_code varchar(255))
 select * from tmp_20230817_zy for update
 delete from tmp_18_cust
 drop table tmp_18_cust

