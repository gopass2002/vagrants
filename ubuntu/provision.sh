#!/bin/bash

# add user (ubuntu-dev)
addgroup ubuntu-dev
useradd -g ubuntu-dev -d /home/ubuntu-dev -s /bin/bash -m ubuntu-dev
echo -e "root\nroot" | (passwd ubuntu-dev)

# add sudo privilege to ubuntu-dev
chmod u+w /etc/sudoers
echo "ubuntu-dev   ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
chmod u-w /etc/sudoers

# modify apt-get repository url
sed -i -e"s/archive.ubuntu.com/ftp.daum.net/g" /etc/apt/sources.list

# install docker
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
apt-get update
apt-get install -y lxc-docker

# given non-root access to docker
gpasswd -a ubuntu-dev docker

#update docker daemon
sed -i -e 's/DOCKER_OPTS=/DOCKER_OPTS="-H unix:\/\/\/var\/run\/docker.sock -H tcp:\/\/0.0.0.0:2375 --insecure-registry 0.0.0.0:5000"/g' /etc/init/docker.conf

# enable docker swap memory
sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/g' /etc/default/grub
update-grub

# restart docker daemon
service docker restart
