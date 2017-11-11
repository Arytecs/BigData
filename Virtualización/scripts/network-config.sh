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

if [ ! $1 ] #Comprobamos si se pasa el parámetro nombre_host y en caso de que no exista salimos con error
then
	echo "Error: nombre_host no introducido."
	exit 11
else        #Comprobamos que no haya caracteres de tipo no alphanumérico ni espacios en blanco en nombre_host, en caso contrario salimos con error 
	echo $1 | egrep '([[:space:]]|[[:punct:]])'
	if [ "$?" = "0" ]
	then
		echo "Error: nombre_host no debe contener espacios ni carácteres no alphanuméricos."
		exit 12			
	fi
fi

if [ ! $1 ]  #Comprobamos si se pasa el parámetro IP_host y en caso de que no exista salimos con error
then
	echo "Error: IP_host no introducida."  
	exit 21
fi

function es_ip () {  #Función para comprobar que la entrada sea una ip de la forma xxx.xxx.xxx.xxx donde las x son números enteros en el intervalo [0-255]

	ip=$1

	echo $ip | egrep "\." 2>/dev/null 1>/dev/null

	if [[ "$?" != 0 ]]
	then
		echo "Error: la IP_host es de la forma xxx.xxx.xxx.xxx donde las x son números enteros en el intervalo [0-255]."
		exit 22
	fi

	aux=${ip%%.*}
	aux1=${ip#*.}

	echo $aux | egrep '([[:space:]]|[[:punct:]]|[[:alpha:]])' 2>/dev/null 1>/dev/null
	if [[ "$?" = 0 || $aux -gt 255 ]]
	then
		echo "Error: la IP_host es de la forma xxx.xxx.xxx.xxx donde las x son números enteros en el intervalo [0-255]."
		exit 23
	fi

	echo $aux1 | egrep "\." 2>/dev/null 1>/dev/null

	if [[ "$?" != 0 ]]
	then
		echo "Error: la IP_host es de la forma xxx.xxx.xxx.xxx donde las x son números enteros en el intervalo [0-255]."
		exit 24		
	fi
		
	aux=${aux1%%.*}
	aux1=${aux1#*.}

	echo $aux | egrep '([[:space:]]|[[:punct:]]|[[:alpha:]])' 2>/dev/null 1>/dev/null
	if [[ "$?" = 0 || $aux -gt 255 ]]
	then
		echo "Error: la IP_host es de la forma xxx.xxx.xxx.xxx donde las x son números enteros en el intervalo [0-255]."
		exit 25
	fi
	
	echo $aux1 | egrep "\." 2>/dev/null 1>/dev/null

	if [[ "$?" != 0 ]]
	then
		echo "Error: la IP_host es de la forma xxx.xxx.xxx.xxx donde las x son números enteros en el intervalo [0-255]."
		exit 26		
	fi		

	aux=${aux1%.*}
	aux1=${aux1#*.}
	
	echo $aux | egrep '([[:space:]]|[[:punct:]]|[[:alpha:]])' 2>/dev/null 1>/dev/null
	if [[ "$?" = 0 || $aux -gt 255 ]]
	then
		echo "Error: la IP_host es de la forma xxx.xxx.xxx.xxx donde las x son números enteros en el intervalo [0-255]."
		exit 27
	fi
	
	echo $aux1 | egrep '([[:space:]]|[[:punct:]]|[[:alpha:]])' 2>/dev/null 1>/dev/null

	if [[ "$?" = 0 || $aux1 -gt 255 ]]
	then
		echo "Error: la IP_host es de la forma xxx.xxx.xxx.xxx donde las x son números enteros en el intervalo [0-255]."
		exit 28
	fi
}

es_ip $2  #Aplicamos la función es_ip para comprobar que la ip pasada por parámetro, es una ip correcta

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

if [ $3 ]
then
	es_ip $3
	IP_DNS=$3
	sudo nmcli con mod "System eth0" ipv4.ignore-auto-dns yes
	sudo nmcli con mod "System eth0" ipv4.dns ${IP_DNS}
	sudo nmcli con mod "System eth0" ipv4.dns-search ${DOMINIO}
fi

# 4) Restablecer la red para reflejar los cambios, y parar el cortafuegos
sudo systemctl restart network
sudo systemctl stop firewalld
sudo systemctl disable firewalld


