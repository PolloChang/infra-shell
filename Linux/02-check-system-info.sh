#!/bin/bash

# Script Name: 02-check-system-info.sh
# Version: 1.0
# Author: PolloChang
# Date: 2024-10-22
# Description: 檢查系統資訊
# 使用方式: sudo ./02-check-system-info.sh >> $(cat /proc/sys/kernel/hostname)-system-info-$(date +%Y%m%d%H%M%S).log 2>&1
# Modified:


echo "### 檢查網路資訊"
echo "--------------------"
ip a
echo "--------------------"
echo ""
echo "### 檢查驅動"
echo "--------------------"
lspci -vvv
echo "--------------------"
echo ""
echo "### 檢查CPU"
echo "--------------------"
lscpu
echo "--------------------"
echo ""
echo "### multipath"
echo "--------------------"
multipath -l
echo "--------------------"
echo ""
echo "### 記憶體資訊"
echo "--------------------"
dmidecode --type 17
echo "--------------------"
echo ""
echo "### 主機板資訊"
echo "--------------------"
dmidecode -t 2
echo "--------------------"
echo ""
echo "### 硬碟資訊"
echo "--------------------"
lshw -class disk -class storage
echo "--------------------"
fdisk -l
echo "--------------------"
echo ""
echo "### 已安裝的軟體"
echo "--------------------"
rpm -qa
echo "--------------------"
echo  ""
echo "### FC WWN"
find /sys/class/fc_host/ -name "host*" -exec sh -c 'ls "$1/port_name" && cat "$1/port_name"' _ {} \;
echo "--------------------"
echo ""
echo "--------------------"
echo "### 清查帳號"
awk -F: '{ print "username:" $1 ",uid:" $3 }' /etc/passwd
echo "--------------------"
echo ""
echo "### 找出所有 UID 大於等於 1000 的帳號"
echo "--------------------"
for user in $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd); do
    echo "密碼資訊 for user: $user"
    sudo chage -l $user
    echo "-------------------------"
done
echo "--------------------"
echo ""
echo "###  清查系統排程"
echo "--------------------"
for user in $(awk -F: ' {print $1}' /etc/passwd); do
    echo "Crontab for user: $user"
    sudo crontab -l -u $user 2>/dev/null
    echo "----------------------------"
done
echo "--------------------"
echo ""
echo "###  近三個月登入失敗紀錄"
echo "--------------------"
sudo lastb | awk -v date="$(date --date="3 months ago" '+%Y-%m-%d')" '$5"-"$6"-"$7 >= date'
echo "--------------------"
echo ""

# 設定三個月前的日期
export three_months_ago=$(date -d "3 months ago" '+%Y-%m-%d')
echo "### 晚上 22:00 到 23:59 的登入成功紀錄, 凌晨 00:00 到 08:00 的登入成功紀錄"
echo "--------------------"
last | awk -v date="$three_months_ago" '{
    if ($4 >= date) {
        time = $7;
        if ((time >= "22:00" && time <= "23:59") || (time >= "00:00" && time <= "08:00")) {
            print
        }
    }
}'
echo "--------------------"
echo ""