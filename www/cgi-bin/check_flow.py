#! /usr/bin/env python
# -*- coding: utf-8 -*-
import json
import cgi

f = file("/usr/local/shadowsocksr/mudb.json");
json = json.load(f);

# 接受表达提交的数据
form = cgi.FieldStorage() 

# 解析处理提交的数据
getport = form['port'].value

#判断端口是否找到
portexist=0

#循环查找端口
for x in json:
	#当输入的端口与json端口一样时视为找到
	if(str(x[u"port"]) == str(getport)):
		portexist=1
		transfer_enable_int = int(x[u"transfer_enable"])/1024/1024;
		d_int = int(x[u"d"])/1024/1024;
		transfer_unit = "MB"
		d_unit = "MB"

		#流量单位转换
		if(transfer_enable_int > 1024):
			transfer_enable_int = transfer_enable_int/1024
			transfer_unit = "GB"
		if(transfer_enable_int > 1024):
			d_int = d_int/1024
			d_unit = "GB"
		break

if(portexist==0):
	getport = "未找到此端口，请检查是否输入错误！"
	d_int = ""
	d_unit = ""
	transfer_enable_int = ""
	transfer_unit = ""

header = '''
<!DOCTYPE HTML>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
'''
html = '<h3>您的流量信息\n</h3>'
#打印返回的内容
print header
print html
print '<p />'
formhtml = '''
您的端口: %s </br>
已使用流量：%s %s </br>
总流量限制：%s %s </br> </br>
'''
gobackhtml = '''
<input type="button" name="Submit" value="返回" onclick ="location.href='../check_flow.html'"/>
'''
print formhtml % (getport,d_int,d_unit,transfer_enable_int,transfer_unit)
print gobackhtml
f.close();

