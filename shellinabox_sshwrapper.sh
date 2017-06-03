#!/bin/bash
#
set -ex
# 
read -p "SSH remote host (hostname or ip address) [localhost] : " host;
[[ -z "${host}" ]] && host=localhost;
#
read -p "If a puplic_key authentification?: [y/N] : " puplic;
#
read -p "SSH remote port [22] : " port;
[[ -z "${port}" ]] && port=22;
#
read -p "SSH remote username [pi] : " username;
[[ -z "${username}" ]] && username=pi;
#
if [ "$puplic" == "y" ];
  then
    read -p "How is your public_key?: " key;
    echo $key > ~/.ssh/id_rsa.pub;

    rm ~/.ssh/id_rsa;
    echo "Enter your private id here and press the enter key for a new line !!!";
    id=null
    while [ "$id" != "" ];
      do
      read -p "How is your id_rsa key?: " id;
      echo $id >> ~/.ssh/id_rsa;
    done
    exec ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $port $username@$host;
  else
    exec ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $port $username@$host;
fi
