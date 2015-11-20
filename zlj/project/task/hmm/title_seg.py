# encoding: utf-8
__author__ = 'zlj'

from pyspark import SparkContext
from pyspark.sql import *

sc = SparkContext(appName="cmt")
sqlContext = SQLContext(sc)
from pyspark.sql.types import *

hiveContext = HiveContext(sc)

import jieba.posseg as pseg



# jieba.load_userdict('./dict/userdict')


schema1 = StructType([
    StructField("item_id", StringType(), True),
    StructField("root_cat_id", StringType(), True),
    StructField("root_cat_name", StringType(), True),
    StructField("title", StringType(), True),
    StructField("title_cut", StringType(), True),
    StructField("title_seg", StringType(), True)
   ])
def valid_jsontxt(content):
    if type(content) == type(u""):
        return content.encode("utf-8")
    else :
        return content
def seg(title):
    lv1=[]
    lv2=[]
    for word,tag in pseg.cut(title.strip()):
        lv1.append(valid_jsontxt(word))
        lv2.append(valid_jsontxt(word)+"@_@"+tag)
    return [' '.join(lv1),' '.join(lv2)]



hiveContext.sql('use wlbase_dev')


sql='''

select
item_id,root_cat_id,root_cat_name,title
from
t_base_ec_item_dev
where ds=20151112

'''

df=hiveContext.sql(sql)
rdd=df.map(lambda x:[x.item_id,x.root_cat_id,x.root_cat_name,x.title].append(seg(x.title)))

df1=hiveContext.createDataFrame(rdd,schema1)

hiveContext.registerDataFrameAsTable(df1,'tmptable')


hiveContext.sql('create table  t_zlj_corpus_item_seg  as select * from tmptable')

