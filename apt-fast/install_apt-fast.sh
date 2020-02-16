#!/bin/bash -e

# Install dependencies
apt-get update
apt-get install -y aria2 coreutils wget sed apt-utils

# Install apt-fast
cd /tmp
wget --progress=dot https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast -O /usr/local/sbin/apt-fast
chmod +x /usr/local/sbin/apt-fast

# Configure apt-fast
core_cnt=$(nproc)

if [ $core_cnt -lt 5 ]; then
    core_cnt=5
fi

exec sed "s/core_cnts/$(nproc)/" /tmp/apt-fast/apt-fast.conf | tee /etc/apt-fast.conf
