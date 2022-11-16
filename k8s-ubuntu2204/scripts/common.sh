#! /bin/bash

# disable swap 
sudo swapoff -a
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
echo "Swap diasbled..."

# install dependencies
sudo apt-get update -y
sudo apt install -y git vim curl jq openssh-server
echo "Dependencies installed..."

# install and configure docker
sudo apt install -y docker.io
sudo service docker start         #启动docker服务
sudo usermod -aG docker ${USER}   #当前用户加入docker组

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# start docker
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
echo "Docker installed and configured..."

# iptables
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1 # better than modify /etc/sysctl.conf
EOF



# check
echo "please check these files:"
echo "/etc/docker/daemon.json"
echo "/etc/modules-load.d/k8s.conf"
echo "/etc/sysctl.d/k8s.conf"
echo "cat cat /etc/fstab"
