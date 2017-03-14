#! /usr/bin/env python
# -*- coding: utf-8 -*-
import json
import cgi
import urllib2

#取得本机外网IP
myip = urllib2.urlopen('http://members.3322.org/dyndns/getip').read()
myip=myip.strip()
#加载SSR JSON文件
f = file("/usr/local/shadowsocksr/mudb.json");
json = json.load(f);

# 接受表达提交的数据
form = cgi.FieldStorage() 

# 解析处理提交的数据
getport = form['port'].value
getpasswd = form['passwd'].value
#判断端口是否找到
portexist=0
passwdcorrect=0
#循环查找端口
for x in json:
	#当输入的端口与json端口一样时视为找到
	if(str(x[u"port"]) == str(getport)):
		portexist=1
		if(str(x[u"passwd"]) == str(getpasswd)):
			passwdcorrect=1
			jsonmethod=str(x[u"method"])
			jsonobfs=str(x[u"obfs"])
			jsonprotocol=str(x[u"protocol"])
		break

if(portexist==0):
	getport = "未找到此端口，请检查是否输入错误！"
	myip = ""
	getpasswd = ""
	jsonmethod = ""
	jsonprotocol = ""
	jsonobfs = ""

if(portexist!=0 and passwdcorrect==0):
	getport = "连接密码输入错误，请重试"
	myip = ""
	getpasswd = ""
	jsonmethod = ""
	jsonprotocol = ""
	jsonobfs = ""


header = '''
<!DOCTYPE HTML>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
'''
html = '<h3>您的连接信息\n</h3>'
#打印返回的内容
print header
print html
print '<p />'

formhtml = '''
服务器地址: %s </br>
连接端口: %s </br>
连接密码: %s </br>
加密方式: %s </br>
协议方式: %s </br>
混淆方式: %s </br></br>
'''
gobackhtml = '''
<input type="button" name="Submit" value="返回" onclick ="location.href='../show_info.html'"/>
'''
print formhtml % (myip,getport,getpasswd,jsonmethod,jsonprotocol,jsonobfs)
print gobackhtml
f.close();

