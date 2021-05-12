#!/usr/bin/env bash   
CONTENEDOR="web2"
IP=192.168.100.4

echo $CONTENEDOR
echo $IP

echo "Creando la maquina $CONTENEDOR"
sudo lxc launch ubuntu:18.04 $CONTENEDOR < /dev/null

echo "Actualizando repositorios"
lxc exec $CONTENEDOR -- apt update -y

lxc exec $CONTENEDOR -- apt upgrade -y

echo "Instalando apache2"
lxc exec $CONTENEDOR -- apt install apache2 -y

echo "Habilitando apache2"
lxc exec $CONTENEDOR -- systemctl enable apache2 

echo "Reiniciando estatus Apache2"
lxc exec $CONTENEDOR -- systemctl restart apache2

echo "Validando estatus Apache2"
lxc exec $CONTENEDOR -- systemctl status apache2

echo "Configurando paginas personalizadas"
cat <<TEST > index.html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <!--
    Modified from the Debian original for Ubuntu
    Last updated: 2016-11-16
    See: https://launchpad.net/bugs/1288690
  -->
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Se encuentra en el servidor web2</title>
    <style type="text/css" media="screen">
  * {
    margin: 0px 0px 0px 0px;
    padding: 0px 0px 0px 0px;
  }

  body, html {
    padding: 3px 3px 3px 3px;

    background-color: #D8DBE2;

    font-family: Verdana, sans-serif;
    font-size: 11pt;
    text-align: center;
  }

  div.main_page {
    position: relative;
    display: table;

    width: 800px;

    margin-bottom: 3px;
    margin-left: auto;
    margin-right: auto;
    padding: 0px 0px 0px 0px;

    border-width: 2px;
    border-color: #212738;
    border-style: solid;

    background-color: #FFFFFF;

    text-align: center;
  }

  div.page_header {
    height: 99px;
    width: 100%;

    background-color: #F5F6F7;
  }

  div.page_header span {
    margin: 15px 0px 0px 50px;

    font-size: 180%;
    font-weight: bold;
  }
    </style>
  </head>
  <body>
    <div class="main_page">
      <div class="page_header floating_element">
        <span class="floating_element">
          ! Ingresos desde el servidor web2 !
        </span>
      </div>
  </body>
</html>
TEST

echo "Se transmite el archivo al contenedor"
lxc file push index.html $CONTENEDOR/var/www/html/

echo "Se inicia el servicio Apache2"
lxc exec $CONTENEDOR -- systemctl start apache2 

echo "Se inicia el servicio Apache2"
lxc exec $CONTENEDOR -- systemctl restart apache2 

echo "Se configura el reenvie del puerto de la maquina al contenedor"
lxc config device add $CONTENEDOR http proxy listen=tcp:$IP:80 connect=tcp:127.0.0.1:80

echo "##################Finaliza script##############"
