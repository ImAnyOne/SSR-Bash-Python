#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

echo ""
echo "1.启动服务"
echo "2.停止服务"
echo "3.重启服务"
echo "4.查看日志"
echo "5.运行状态"
echo "6.修改DNS"
echo "直接回车返回上级菜单"

while :; do echo
read -p "请选择： " serverc
[ -z "$serverc" ] && ssr && break
if [[ ! $serverc =~ ^[1-6]$ ]]; then
	echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
else
	break	
fi
done

if [[ $serverc == 1 ]];then
	bash /usr/local/shadowsocksr/logrun.sh
	iptables-restore < /etc/iptables.up.rules >> /dev/null 2>&1
	echo "ShadowsocksR服务器已启动"
fi

if [[ $serverc == 2 ]];then
	bash /usr/local/shadowsocksr/stop.sh
	echo "ShadowsocksR服务器已停止"
fi

if [[ $serverc == 3 ]];then
	bash /usr/local/shadowsocksr/stop.sh
	bash /usr/local/shadowsocksr/logrun.sh
	iptables-restore < /etc/iptables.up.rules >> /dev/null 2>&1
	echo "ShadowsocksR服务器已重启"
fi

if [[ $serverc == 4 ]];then
	bash /usr/local/shadowsocksr/tail.sh
fi

if [[ $serverc == 5 ]];then
	ps aux|grep server.py
fi

if [[ $serverc == 6 ]];then
	read -p "输入主要 DNS 服务器: " ifdns1
	read -p "输入次要 DNS 服务器: " ifdns2
	echo "nameserver $ifdns1" > /etc/resolv.conf
	echo "nameserver $ifdns2" >> /etc/resolv.conf
	echo "DNS 服务器已设置为  $ifdns1 $ifdns2"
fi
