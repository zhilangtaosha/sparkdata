#!/bin/bash
date=`hadoop fs -ls /hive/warehouse/wlbase_dev.db/t_base_ec_shopitem_b | awk -F '=' '{print $2}' | sort -r |awk 'NR==1{print $0}'`
echo $date