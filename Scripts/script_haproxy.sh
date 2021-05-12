#!/usr/bin/env bash   
echo "Creando la maquina haproxy"
sudo lxc launch ubuntu:18.04 haproxy < /dev/null

echo "Actualizando repositorios"
lxc exec haproxy -- apt update -y

lxc exec haproxy -- apt upgrade -y

echo "Instalando haproxy"
lxc exec haproxy -- apt install haproxy -y

echo "Habilitando haproxy"
lxc exec haproxy -- systemctl enable haproxy 

echo "Reiniciando estatus haproxy"
lxc exec haproxy -- systemctl restart haproxy

echo "Validando estatus haproxy"
lxc exec haproxy -- systemctl status haproxy

echo "Configurando archivos haproxy.cfg"
cat <<TEST > haproxy.cfg
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http


backend web-backend
   balance roundrobin
   stats enable
   stats auth admin:admin
   stats uri /haproxy?stats

   server web1 192.168.100.3:80 check   
   server web2 192.168.100.4:80 check   
   server web1bck 192.168.100.5:80 check   
   server web2bck 192.168.100.6:80 check   

frontend http
  bind *:80
  default_backend web-backend


TEST

echo "Configurando pagina de error 503.html"
cat <<TEST > 503.http
HTTP/1.0 503 Service Unavailable
Cache-Control: no-cache
Connection: close
Content-Type: text/html

<html>
<head><title>No disponible</title></head>
<body><h1>Lo sentimos, el sitio no se encuentra disponible &#128534; </h1>
! Nuestros mejores ingenieros ya los estan validando! &#128170;
</body></html>
TEST


echo "Se transmite el archivo al contenedor"
lxc file push haproxy.cfg haproxy/etc/haproxy/
lxc file push 503.http haproxy/etc/haproxy/errors/


echo "Iniciando el servicios haproxy"
lxc exec haproxy -- systemctl start haproxy 

echo "Reiniciando el servicios haproxy"
lxc exec haproxy -- systemctl restart haproxy 

echo "Redireccionando los puertos"
lxc config device add haproxy http proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80

echo "##################Finaliza script##############"
