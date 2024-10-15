#!/bin/bash

# Script Name: 01-mirror-repos.sh
# Version: 1.0
# Author: PolloChang
# Date: 2024-10-15
# Description: Mirror repos 
# Modified:

export REPO_HOME_PATH="/data/repository/repo"
export REPO_URL="yum-rsync.oracle.com/repo/OracleLinux"
export LOG_FILE="/var/log/repository/refresh-repos-$(date +'%Y%m%d').log"

# 定義路徑陣列
declare -A REPO_PATHS=(
    ["OL7/9/base/x86_64"]="/OL7/9/base/x86_64/"
    ["OL7/UEKR4/x86_64"]="/OL7/UEKR4/x86_64/"
    ["OL7/UEKR5/x86_64"]="/OL7/UEKR5/x86_64/"
    ["OL7/UEKR6/x86_64"]="/OL7/UEKR6/x86_64/"
    ["OL8/10/baseos/base/x86_64"]="/OL8/10/baseos/base/x86_64/"
    ["OL8/appstream/x86_64"]="/OL8/appstream/x86_64/"
    ["OL8/UEKR7/x86_64"]="/OL8/UEKR7/x86_64/"
    ["OL8/kvm/appstream/x86_64"]="/OL8/kvm/appstream/x86_64/"
    ["OL9/4/baseos/base/x86_64"]="/OL9/4/baseos/base/x86_64/"
    ["OL9/appstream/x86_64"]="/OL9/appstream/x86_64/"
    ["OL9/UEKR7/x86_64"]="/OL9/UEKR7/x86_64/"
    ["OL9/kvm/utils/x86_64"]="/OL9/kvm/utils/x86_64/"
)


echo "$(date +'%Y-%m-%d %H:%M:%S') - Mirror Oracle Linux yum repo start"| tee -a $LOG_FILE

# 使用 for 迴圈進行 rsync，並記錄到日誌
for key in "${!REPO_PATHS[@]}"; do
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Starting sync for ${key}" | tee -a $LOG_FILE
    mkdir -p ${REPO_HOME_PATH}/${key}/ 2>&1 | tee -a $LOG_FILE
    rsync -arv rsync://${REPO_URL}${REPO_PATHS[$key]} ${REPO_HOME_PATH}/${key}/ 2>&1 | tee -a $LOG_FILE
    if [[ $? -eq 0 ]]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Sync for ${key} completed successfully" | tee -a $LOG_FILE
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Sync for ${key} failed" | tee -a $LOG_FILE
    fi
done

mkdir -p ${REPO_URL}/OL9/baseos/latest 2>&1 | tee -a $LOG_FILE
ln -s ${REPO_URL}/OL9/4/baseos/base ${REPO_URL}/OL9/baseos/latest 2>&1 | tee -a $LOG_FILE

echo "$(date +'%Y-%m-%d %H:%M:%S') - Mirror Oracle Linux yum repo end"| tee -a $LOG_FILE
