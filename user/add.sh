#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin


#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
OS=CentOS
[ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
[ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
[ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
OS=CentOS
CentOS_RHEL_version=6
elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
OS=Debian
[ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
OS=Debian
[ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
OS=Ubuntu
[ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
[ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
echo "${CFAILURE}Does not support this OS, Please contact the author! ${CEND}"
kill -9 $$
fi


#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }


echo "你选择了添加用户"
echo ""
read -p "输入用户名： " uname
read -p "输入端口： " uport
read -p "输入密码： " upass
echo ""
echo "加密方式"
echo '1.chacha20'
echo '2.aes-128-cfb'
echo '3.aes-256-cfb'
echo '4.salsa20'
echo '5.rc4-md5'
while :; do echo
read -p "输入加密方式： " um
if [[ ! $um =~ ^[1-5]$ ]]; then
	echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
else
	break	
fi
done


echo "协议方式"
echo '1.origin'
echo '2.auth_simple'
echo '3.auth_sha1_v2'
echo '4.auth_sha1_v4'
echo '5.auth_aes128_md5'
echo '6.auth_aes128_sha1'
echo '7.verify_sha1'
echo '8.verify_deflate'
while :; do echo
read -p "输入协议方式： " ux
if [[ ! $ux =~ ^[1-8]$ ]]; then
	echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
else
	break	
fi
done

echo "混淆方式"
echo '1.plain'
echo '2.http_simple'
echo '3.http_post'
echo '4.tls1.2_ticket_auth'
while :; do echo
read -p "输入混淆方式： " uo
if [[ ! $uo =~ ^[1-4]$ ]]; then
	echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
else
	break	
fi
done
if [[ $um == 1 ]];then
	um1="chacha20"
fi
if [[ $um == 2 ]];then
	um1="aes-128-cfb"
fi
if [[ $um == 3 ]];then
	um1="aes-256-cfb"
fi
if [[ $um == 4 ]];then
	um1="salsa20"
fi
if [[ $um == 5 ]];then
	um1="rc4-md5"
fi
if [[ $ux == 1 ]];then
	ux1="origin"
fi
if [[ $ux == 2 ]];then
	ux1="auth_simple"
fi
if [[ $ux == 3 ]];then
	ux1="auth_sha1_v2"
fi
if [[ $ux == 4 ]];then
	ux1="auth_sha1_v4"
fi
if [[ $ux == 5 ]];then
	ux1="auth_aes128_md5"
fi
if [[ $ux == 6 ]];then
	ux1="auth_aes128_sha1"
fi
if [[ $ux == 7 ]];then
	ux1="verify_sha1"
fi
if [[ $ux == 8 ]];then
	ux1="verify_deflate"
fi
if [[ $uo == 1 ]];then
	uo1="plain"
fi
if [[ $uo == 2 ]];then
	uo1="http_simple"
fi
if [[ $uo == 3 ]];then
	uo1="http_post"
fi
if [[ $uo == 4 ]];then
	uo1="tls1.2_ticket_auth"
fi

read -p "输入流量限制(只需输入数字，单位：GB)： " ut
echo "用户添加成功！用户信息如下："
#Run ShadowsocksR
cd /usr/local/shadowsocksr
python mujson_mgr.py -a -u $uname -p $uport -k $upass -m $um1 -O $ux1 -o $uo1 -t $ut

#Set Firewalls
if [[ ${OS} =~ ^Ubuntu$|^Debian$ ]];then
	iptables-restore < /etc/iptables.up.rules >> /dev/null 2>&1
	iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $uport -j ACCEPT
	iptables -I INPUT -m state --state NEW -m udp -p udp --dport $uport -j ACCEPT
	iptables-save > /etc/iptables.up.rules
fi

if [[ ${OS} == CentOS ]];then
    if [[ ${CentOS_RHEL_version} == 7 ]];then
		systemctl status firewalld > /dev/null 2>&1
        if [ $? -eq 0 ]; then
        	firewall-cmd --permanent --zone=public --add-port=$uport/tcp
        	firewall-cmd --permanent --zone=public --add-port=$uport/udp
        	firewall-cmd --reload
        else
            systemctl start firewalld
            if [ $? -eq 0 ]; then
                firewall-cmd --permanent --zone=public --add-port=$uport/tcp
                firewall-cmd --permanent --zone=public --add-port=$uport/udp
                firewall-cmd --reload
            else
            	echo "防火墙配置失败，请手动开放 $uport 端口！" 
            fi
        fi
    else
        iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $uport -j ACCEPT
        iptables -I INPUT -m state --state NEW -m udp -p udp --dport $uport -j ACCEPT
		/etc/init.d/iptables save
		/etc/init.d/iptables restart
    fi
fi
