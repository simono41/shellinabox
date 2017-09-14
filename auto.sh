#!/bin/bash

set -ex

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
  echo "Als root Angemeldet"

if [ -f /usr/bin/apt ]; then
  apt update

  apt install git libssl-dev libpam0g-dev zlib1g-dev dh-autoreconf
fi

if [ -f /usr/bin/pacman ]; then
  pacman -Sy git openssl autoconf automake make gcc
fi

cd /opt/

git clone https://github.com/simono41/shellinabox.git

cd shellinabox

autoreconf -i

./configure && make

cp shellinabox.service /etc/systemd/system/

systemctl daemon-reload

systemctl enable shellinabox.service

# adduser

echo adduser webssh

useradd webssh

mkdir /home/webssh

cp shellinabox_sshwrapper.sh /home/webssh/

chmod 770 -R /home/webssh/

chown -cR webssh:webssh /home/webssh/

passwd webssh <<EOT
webssh
webssh
EOT

systemctl start shellinabox.service &
