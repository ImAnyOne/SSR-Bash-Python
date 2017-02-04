# SSR-Bash #
ShadowsocksR多用户管理脚本（基于官方版本）
## 介绍 ##
一个Shell脚本，集成SSR多用户管理，流量限制，加密更改等基本操作。
如有任何问题和意见，欢迎加QQ群：277717865

## 更新日志 ##
- 实验性版本上线

## 功能 ##
- 一键开启、关闭SSR服务
- 添加、删除、修改用户端口和密码
- 自由限制用户端口流量使用
- 自动修改防火墙规则
- 自助修改SSR加密方式、协议、混淆等参数
- 自动统计，方便查询每个用户端口的流量使用情况
- 自动安装Libsodium库以支持Chacha20等加密方式

## 缺点 ##
1. 无法删除最后一名用户（官方限制）
## 系统支持 ##
- SSR官方支持的操作系统均可
## 安装 ##
    wget -N --no-check-certificate https://raw.githubusercontent.com/FunctionClub/SSR-Bash-Python/master/install.sh && bash install.sh

## 卸载 ##
    wget -N --no-check-certificate https://raw.githubusercontent.com/FunctionClub/SSR-Bash-Python/master/uninstall.sh && bash uninstall.sh

