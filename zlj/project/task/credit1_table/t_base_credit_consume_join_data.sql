DROP TABLE t_base_credit_consume_join_data;

CREATE TABLE t_base_credit_consume_join_data AS

  SELECT
    t1.tb_id,
    alipay,
    regtime_month,
    buycnt,
    verify_level,
    size(split(dim, '\\|'))   AS dim_size,
    -- esp_perfer    ,
    size(split(brand, '\\|')) AS brand_size,
    CASE WHEN cast(split(user_per_level, '_') [1] AS INT) > 0
      THEN cast(split(user_per_level, '_') [1] AS INT)
    ELSE 0 END                AS user_per_level,
    ac_score_normal,
    CASE WHEN cast(split(sum_level, 'el') [1] AS INT) > 0
      THEN cast(split(sum_level, 'el') [1] AS INT)
    ELSE 0 END                AS sum_level,
    avg_month_buycnt

  FROM

    t_base_credit_consume_basic_property t1

    LEFT JOIN t_base_credit_consume_perfer t2 ON t1.tb_id = t2.tb_id

    LEFT JOIN t_base_credit_consume_property t3 ON t1.tb_id = t3.user_id
  WHERE length(sum_level) > 0;


-- 用户统计信息
DROP TABLE IF EXISTS t_base_credit_consume_statis_data;
CREATE TABLE t_base_credit_consume_statis_data AS
  SELECT
    user_id,
    sum(price)                  consume_price,
    COUNT(DISTINCT cat_id)      cat_id_num,
    COUNT(DISTINCT root_cat_id) root_cat_id_num,
    COUNT(DISTINCT brand_id)    brand_id_num,
    sum(CASE WHEN length(brand_id) > 2
      THEN 1
        ELSE 0 END)             brand_effec_id_num,
    sum(CASE WHEN length(brand_id) <= 2
      THEN 1
        ELSE 0 END)             brand_no_effec_id_num,
    sum(CASE WHEN annoy = '1'
      THEN 1
        ELSE 0 END)             annoy_num,
    sum(CASE WHEN annoy = '0'
      THEN 1
        ELSE 0 END)             no_annoy_num,
    sum(CASE WHEN bc_type = 'B'
      THEN 1
        ELSE 0 END)             b_bc_type_num,
    sum(CASE WHEN bc_type = 'C'
      THEN 1
        ELSE 0 END)             c_bc_type_num
  FROM
    t_base_ec_record_dev_new
  WHERE ds = 'true1'
  GROUP BY user_id;

create table  t_base_credit_consume_feed_default_feature as
SELECT user_id ,sum(case when feed_default=1 then 1 else 0 end )  feed_default,
  sum(case when feed_default=1 then 0 else 1 end )  feed_non_default
  FROM
(
SELECT
  user_id ,
CASE WHEN  content like  '%默认%'  or content='好评！'THEN 1 ELSE 0 END as feed_default
FROM
  t_base_ec_item_feed_dev
)t
group by  user_id ;



DROP TABLE  IF EXISTS  t_base_credit_consume_feature_data ;
CREATE  table t_base_credit_consume_feature_data as
SELECT t2.* ,
alipay     ,
regtime_month    ,
buycnt        ,
verify_level     ,
dim_size         ,
brand_size       ,
user_per_level   ,
ac_score_normal  ,
sum_level        ,
avg_month_buycnt ,
  feed_default,
  feed_non_default
FROM
  t_base_credit_consume_join_data t1 JOIN t_base_credit_consume_statis_data t2
ON t1.tb_id=t2.user_id
JOIN t_base_credit_consume_feed_default_feature t3 on t1.tb_id=t3.user_id;

  -- 训练数据
  DROP TABLE t_base_credit_consume_join_data_zm_data ;

  create TABLE t_base_credit_consume_join_data_zm_data AS
SELECT
  t2.*,
  t1.id1
FROM
  t_base_uid t1 JOIN
 t_base_credit_consume_feature_data t2 ON t1.uid = t2.user_id AND t1.ds = 'uid_zm_data' ;


SELECT *
FROM
  t_base_credit_consume_feature_data
WHERE user_id IN (
  880087145,
  14813970,
  423908098,
  264718973,
  1051266089,
  1730526634 ,
    1101681998
);

SELECT *
FROM
  t_base_credit_consume_feature_data
WHERE user_id IN (
  1101681998 ,
831457909,
2157904352

);


