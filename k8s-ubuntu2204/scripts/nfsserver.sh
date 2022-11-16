#! /bin/bash

sudo apt-get -y install nfs-kernel-server

mkdir -p /tmp/nfs

cat <<EOF | sudo tee /etc/exports
/tmp/nfs 192.168.56.0/24(rw,sync,no_subtree_check,no_root_squash,insecure)
EOF

sudo exportfs -ra
sudo exportfs -v
sudo systemctl start nfs-server
sudo systemctl enable nfs-server
udo systemctl status nfs-server
