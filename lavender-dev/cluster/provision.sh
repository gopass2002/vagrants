#!/bin/bash

# add user (lavender)
addgroup lavender
useradd -g lavender -d /home/lavender -s /bin/bash -m lavender
echo -e "lavender\nlavender" | (passwd lavender)

# add sudo privilege to lavender
chmod u+w /etc/sudoers
echo "lavender   ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
chmod u-w /etc/sudoers

sed -i -e"s/archive.ubuntu.com/ftp.daum.net/g" /etc/apt/sources.list
sudo apt-get install language-pack-ko
sudo locale-gen ko_KR.UTF-8
