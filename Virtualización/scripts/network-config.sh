#!/bin/bash
# network-config.sh

source /vagrant/scripts/common.sh

#
# NOTA PREVIA GENERAL:
# 
#       En este script se han omitido expresamente algunas comprobaciones
#       previas a cada acción, y en general todas las comprobaciones de error.
#       Se deja al alumno que las implemente como desee, así como algunas acciones
#       que se comentan pero no se resuelven.
#

# PARAMETROS DE ENTRADA (desde Vagrantfile):
#
#  - nombre_host (string): nombre del sistema invitado (sin sufijo DNS).
#                          Parámetro obligatorio.
#  - IP_host (dirección IP): dirección IP del sistema en la red privada.
#                          Parámetro obligatorio.
#  - IP_DNS (dirección IP): dirección IP del servidor DNS, en caso de que haya 
#                          que cambiarlo.
#                          Parámetro opcional.
#

# 0) Comprobación previa de parámetros de entrada obligatorios
if [ ! $1 ]
then
	echo "Error: nombre_host no introducido."
	exit 1
fi
if [ ! $2 ]
then
	echo "Error: IP_host no introducida."
	exit 2
fi

nombre_host=$1
IP_host=$2

# 1) Establecer nombre de host 
fqdn="${nombre_host}.${DOMINIO}"
sudo hostname $fqdn

# 2) Modificar el /etc/hosts para incluir (al principio) el nombre del host y 
#    la IP en la red privada (si no están ya)
echo "${IP_host}  ${fqdn}  ${nombre_host}" > /tmp/nuevo-hosts 
cat  /etc/hosts >> /tmp/nuevo-hosts
sudo cp /tmp/nuevo-hosts /etc/hosts

# 3) Si se ha especificado un servidor DNS en los parámetros de entrada (IP_DNS), 
#    entonces reconfigurar el cliente DNS:
# NOTA: Sólo falta la comprobación

if [ $3 ]
then
	IP_DNS=$3
	sudo nmcli con mod "System eth0" ipv4.ignore-auto-dns yes
	sudo nmcli con mod "System eth0" ipv4.dns ${IP_DNS}
	sudo nmcli con mod "System eth0" ipv4.dns-search ${DOMINIO}
fi

# 4) Restablecer la red para reflejar los cambios, y parar el cortafuegos
sudo systemctl restart network
sudo systemctl stop firewalld
sudo systemctl disable firewalld


