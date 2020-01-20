#!/bin/bash

user_name=$1

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast
sudo yum install -y docker-ce
sudo usermod -aG docker ${user_name}
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo service docker start
sudo docker --version