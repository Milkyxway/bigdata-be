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
       to_char(res.Create_Date,'yyyymmdd') 光猫时间,
res.res_equ_no 光猫号码,
decode(res.res_sku_id,1153929,'三合一',1153930,'二合一',1153909 ,'FTTH猫_独立式（无锡)',1151326,'FTTH猫') 光猫型号
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

 where sub.subscriber_type = 3 -- 宽带
   and sub.corp_org_id = 3303
   and ofer.offer_name <> '开户惠_宽带4M_500元'
   and ofer.offer_name Not Like '%宽带活动%'
   and ofer.offer_name Not Like '%按天%'
   and ofer.offer_name <> '合同产品'
   and acct.acct_name not like '%测试%'

 and not exists (select 1 from files2.um_offer_06 pk2 where pk2.prod_service_id=1002 and    pk2.cust_id=cus.cust_id)--没有数字电视
and not exists(select 1 from files2.um_offer_06 pk3 where pk3.prod_service_id=1003 and    pk3.cust_id=cus.cust_id)--没有互动
and res.res_sku_id  in  ( '1153930','1153929','1153909'，'1151326') 
--and to_char(res.create_date,'yyyy') = '2022'
--and addr.district_name in ('湖滨广电站')
and (    addr.village_name like '%阳山镇五层楼%'
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












