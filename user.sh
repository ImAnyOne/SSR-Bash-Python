#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

echo "你选择了用户管理"
echo '1.添加用户'
echo '2.删除用户'
echo '3.修改用户'
echo '4.显示用户完整信息'
echo '5.显示所有用户信息'
echo ""
while :; do echo
read -p "请选择： " userc
if [[ ! $userc =~ ^[1-5]$ ]]; then
	echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
else
	break	
fi
done

if [[ $userc == 1 ]];then
	bash /usr/local/SSR-Bash-Python/user/add.sh
fi
if [[ $userc == 2 ]];then
	bash /usr/local/SSR-Bash-Python/user/del.sh
fi
if [[ $userc == 3 ]];then
	bash /usr/local/SSR-Bash-Python/user/edit.sh
fi
if [[ $userc == 4 ]];then
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
		python mujson_mgr.py -l -u $uid
	fi
	if [[ $lsid == 2 ]];then
		read -p "输入端口号： " uid
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -l -p $uid
	fi
fi
if [[ $userc == 5 ]];then
	cd /usr/local/shadowsocksr
	python mujson_mgr.py -l
fi
