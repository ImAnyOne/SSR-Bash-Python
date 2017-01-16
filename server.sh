#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

echo "你选择了服务器管理"
echo "1.查看服务器运行状态"
echo "2.启动服务"
echo "3.停止服务"
echo "4.启动带日志的服务"
echo "5.查看日志"
echo "6.修改DNS"

while :; do echo
read -p "请选择： " serverc
if [[ ! $serverc =~ ^[1-6]$ ]]; then
	echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
else
	break	
fi
done

if [[ $serverc == 1 ]];then
	ps aux|grep server.py
fi
if [[ $serverc == 2 ]];then
	cd /usr/local/shadowsocksr
	bash run.sh
fi
if [[ $serverc == 3 ]];then
	cd /usr/local/shadowsocksr
	bash stop.sh
fi
if [[ $serverc == 4 ]];then
	cd /usr/local/shadowsocksr
	bash logrun.sh
fi
if [[ $serverc == 5 ]];then
	cd /usr/local/shadowsocksr
	bash tail.sh
fi
if [[ $serverc == 6 ]];then
	read -p "输入主要 DNS 服务器: " ifdns1
	read -p "输入次要 DNS 服务器: " ifdns2
	echo "nameserver $ifdns1" > /etc/resolv.conf
	echo "nameserver $ifdns2" >> /etc/resolv.conf
	echo "DNS 服务器已设置为  $ifdns1 $ifdns2"
fi