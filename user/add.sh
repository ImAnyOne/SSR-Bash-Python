#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

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
#read -p "输入协议参数： " ux2
#read -p "输入混淆参数： " uo2
read -p "输入流量限制(G)： " ut
#read -p "输入端口限制（如1~80和90~100输入"1-80,90-100"）： " ub

cd /usr/local/shadowsocksr
#python mujson_mgr.py -a -u $uname -p $uport -k $upass -m $um1 -O $ux1 -o $uo1 -G $ux2 -g $uo2 -t $ut -f $ub
python mujson_mgr.py -a -u $uname -p $uport -k $upass -m $um1 -O $ux1 -o $uo1 -t $ut