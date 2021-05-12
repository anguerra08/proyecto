#!/usr/bin/env bash   

apt-get update 

echo "Instalando lxd"
sudo snap install lxd

echo "Inicio en el nuevo grupo LXC"
newgrp lxd 

echo "Iniciando LXD"
lxd init --auto

