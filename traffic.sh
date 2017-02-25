#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

echo ""
echo "1.清空指定用户流量"
echo "2.清空全部用户流量"
echo "直接回车返回上级菜单"
while :; do echo
read -p "请选择： " tc
[ -z "$tc" ] && ssr && break
if [[ ! $tc =~ ^[1-2]$ ]]; then
	echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
else
	break
fi
done

if [[ $tc == 1 ]];then
	echo "1.使用用户名"
	echo "2.使用端口"
	echo ""
	while :; do echo
	read -p "请选择： " lsid
	if [[ ! $lsid =~ ^[1-2]$ ]]; then
		echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
	else
		break	
	fi
	done
	if [[ $lsid == 1 ]];then
		read -p "输入用户名： " uid
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -c -u $uid
		echo "已清空用户名为 ${uid} 的用户流量"
	fi
	if [[ $lsid == 2 ]];then
		read -p "输入端口号： " uid
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -c -p $uid
		echo "已清空端口号为${uid} 的用户流量"
	fi
fi

if [[ $tc == 2 ]];then
	cd /usr/local/shadowsocksr
	python mujson_mgr.py -c
	echo "已清空全部用户的流量使用记录"
fi

