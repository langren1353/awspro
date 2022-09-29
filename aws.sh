#!/bin/bash
#
# AWS流量阈值脚本
#
# Copyright (c) 2020.

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "Bash"; then
  echo "该脚本需要使用bash而不是sh运行"
  exit
fi

if [[ "$EUID" -ne 0 ]]; then
  echo "对不起你需要使用ROOT权限运行该脚本"
  exit
fi
beikong0_chushihua() {
  echo "开始安装依赖"
  echo "安装依赖"
  yum install wget -y
  yum install epel-release -y
  yum install wget vnstat -y
  apt-get install wget -y
  apt-get install epel-release -y
  apt-get install vnstat -y
  service vnstat start
  vnstat --create -i eth0
  chkconfig vnstat on
  vnstat -u -i eth0
  mkdir /root/.awsll/
  wget https://raw.githubusercontent.com/langren1353/awspro/master/vnstat.sh -O /root/.awsll/vnstat.sh
  chmod +x /root/.awsll/vnstat.sh
  wget https://raw.githubusercontent.com/langren1353/awspro/master/awsoff.sh -O /root/.awsll/awsoff.sh
  chmod +x /root/.awsll/awsoff.sh

  read -p "是否下载1T版本脚本[y/N]" down_files_1
  if [[ "$down_files_1" =~ ^[yY]$ ]]; then
    echo "正在下载1T版脚本"
    wget https://raw.githubusercontent.com/langren1353/awspro/master/aws1024.py -O /root/.awsll/aws1024.py
    chmod +x /root/.awsll/aws1024.py
    nohup python /root/.awsll/aws1024.py >>/dev/null 2>&1 &

  fi
  echo "正在添加定时任务"
    crontab -l >"$file_1/crontab.bak"
    sed -i "/vnstat -u -i eth0/d" "$file_1/crontab.bak"
    sed -i "/vnstat.sh/d" "$file_1/crontab.bak"
    echo -e "\n*/1 * * * *  /usr/bin$file_1/vnstat -u -i eth0" >>"$file_1/crontab.bak"
    echo -e "\n0 4 1 1 *  /root/.awsll$file_1/vnstat.sh" >>"$file_1/crontab.bak"
    crontab "$file_1/crontab.bak"
    rm -r "$file_1/crontab.bak"
    cron_config=$(crontab -l | grep "vnstat -u -i eth0")
    cron_config=$(crontab -l | grep "vnstat.sh")
  echo "正在添加自启任务"
    wget https://raw.githubusercontent.com/langren1353/awspro/master/aws1024-zq.sh -O /root/.awsll/aws1024-zq.sh
    chmod +x /root/.awsll/aws1024-zq.sh
    chmod +x /etc/rc.d/rc.local
    echo "/root/.awsll/aws1024-zq.sh >/root/.awsll/aws1024.py.log 2>&1" >>/etc/rc.d/rc.local
  echo "正在下载管理脚本"
    curl -o /usr/bin/aws -Ls https://raw.githubusercontent.com/langren1353/awspro/master/ll.sh
    chmod +x /usr/bin/aws
  echo "安装完成，请输入 aws 管理流量统计"
}

beikong0_chushihua
echo "当前配置为不限制流量方式，请在管理脚本中进行配置"

