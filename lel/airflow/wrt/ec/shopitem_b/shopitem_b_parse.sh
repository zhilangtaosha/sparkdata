#!/usr/bin/env bash
source ~/.bashrc
pre_path='/home/wrt/sparkdata'
lastday=$1
last_update_day=$2

hadoop fs -test -e /user/wrt/shopitem_tmp
if [ $? -eq 0 ] ;then
hadoop fs  -rmr /user/wrt/shopitem_tmp
else
echo 'Directory is not exist,you can run you spark job as you want!!!'
fi

spark-submit  --executor-memory 6G  --driver-memory 6G  --total-executor-cores 60 \
$pre_path/wrt/data_base_process/t_base_shopitem_b.py $lastday $last_update_day
