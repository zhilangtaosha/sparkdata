

SELECT
sum(case when split(t1.tloc,'\t')[0]= split(t2.location,'\t')[0] then 1 else 0 end ) ,
sum(1)
from
t_base_user_info_s t1  join  t_base_ec_tb_userinfo  t2 on t1.ds=20160310 and t1.tb_id=t2.uid ;


20160418
776612  185953723



20160310
2447757 185953723

select count(1) from t_base_user_info_s where    ds=20160418;


--

create TABLE  t_base_user_info_s_tbuserinfo as
SELECT
tb_id,tgender,tage,tname,
case when  t1.tloc is not null  then t1.tloc else t2.location end as  tloc,
alipay,buycnt,verify,regtime,nick
from t_base_user_info_s t1  left join  t_base_ec_tb_userinfo  t2
on t1.ds=20160310 and t1.tb_id=t2.uid ;


-- select rt,COUNT(1) from (SELECT split(regtime,'.')[0] as rt from t_base_ec_tb_userinfo )t group by rt