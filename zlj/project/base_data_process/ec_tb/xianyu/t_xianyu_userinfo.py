#coding=utf-8
__author__ = 'wrt'
from pyspark import SparkContext

import rapidjson as json

sc = SparkContext(appName="t_xianyu_userinfo")

def valid_jsontxt(content):
    res = str(content)
    if type(content) == type(u""):
        res = content.encode("utf-8")
    # return res.replace("\\n", " ").replace("\n"," ").replace("\u0001"," ").replace("\001", "").replace("\\r", "")
    return res.replace('\n',"").replace("\r","").replace('\001',"").replace("\u0001","")

def f(line):
    result = []
    text = line.strip()
    star = text.find("({")+1
    if star == -1: return None
    end = text.rfind("})") + 1
    ob = json.loads(valid_jsontxt(text[star:-2]))
    if type(ob)==type(1.0):return None
    idleItemSearch = ob.get("idleItemSearch@2",{}).get("data",{})
    totalCount = idleItemSearch.get("totalCount","-")
    userPersonalInfo = ob.get("userPersonalInfo@1",{}).get("data",{})
    if userPersonalInfo == {}: return None
    userId = userPersonalInfo.get("userId","-")
    if userId == "-": return None
    gender = userPersonalInfo.get("gender","-")
    idleUserId = userPersonalInfo.get("idleUserId","-")
    nick = userPersonalInfo.get("nick","-") #闲鱼nick
    tradeCount = userPersonalInfo.get("tradeCount","-")
    tradeIncome = userPersonalInfo.get("tradeIncome","-")
    userNick = userPersonalInfo.get("userNick","-") #淘宝nick
    constellation = userPersonalInfo.get("constellation","-")
    birthday = userPersonalInfo.get("birthday","-")
    city = userPersonalInfo.get("city","-")
    constellation='-' if len(constellation)<1 else constellation
    birthday='-' if len(birthday)<1 else birthday
    city='-' if len(city)<1 else city
    result.append(valid_jsontxt(userId))
    result.append(valid_jsontxt(totalCount))
    result.append(valid_jsontxt(gender))
    result.append(valid_jsontxt(idleUserId))
    result.append(valid_jsontxt(nick))
    result.append(valid_jsontxt(tradeCount))
    result.append(valid_jsontxt(tradeIncome))
    result.append(valid_jsontxt(userNick))
    result.append(valid_jsontxt(constellation))
    result.append(valid_jsontxt(birthday))
    result.append(valid_jsontxt(city))
    return "\001".join(result)





# s = "/commit/160719.userinfo"

s = "/commit/taobao_xianyu/"

rdd = sc.textFile(s).map(lambda x:f(x)).filter(lambda x:x!=None)
rdd.saveAsTextFile('/user/zlj/temp/xianyu_userinfo_tmp')