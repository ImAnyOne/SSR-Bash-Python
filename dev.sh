#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

echo "测试区域，请勿随意使用"
echo "1.更新SSR-Bsah"

while :; do echo
read -p "请选择： " devc
if [[ ! $devc =~ ^[1-1]$ ]]; then
	echo "${CWARNING}输入错误! 请输入正确的数字!${CEND}"
else
	break	
fi
done

if [[ $devc == 1 ]];then
	rm -rf /usr/local/bin/ssr
	rm -rf /usr/local/SSR-Bash-Python
	cd /usr/local
	git clone https://github.com/FunctionClub/SSR-Bash-Python
	mv /usr/local/SSR-Bash-Python/ssr /usr/local/bin/
	chmod +x /usr/local/bin/ssr
	echo 'SSR-Bash升级成功！'
fi
