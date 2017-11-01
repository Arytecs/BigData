#!/bin/bash
# ipa-server-install.sh

source /vagrant/scripts/common.sh

#
# NOTA PREVIA GENERAL:
# 
#       En este script se han omitido expresamente algunas comprobaciones
#       previas a cada acción, y en general todas las comprobaciones de error.
#       Se deja al alumno que las implemente como desee, así como algunas acciones
#       que se comentan pero no se resuelven.
#

# DATOS DE ENTRADA (desde Vagrantfile):
#
# - nombre_host (string): nombre del servidor (sin sufijo DNS).
#                         Parámetro obligatorio.
#

# 0) Comprobación previa de parámetros de entrada obligatorios
if [ ! $1 ]
then
	echo "Error: nombre_host no introducido."
	exit 11
else
	echo $1 | egrep '([[:space:]]|[[:punct:]])'
	if [ "$?" = "0" ]
	then
		echo "Error: nombre_host no debe contener espacios ni carácteres no alphanuméricos."
		exit 12			
	fi
fi

nombre_host=$1

fqdn="${nombre_host}.${DOMINIO}"

# 1) Comprobamos si los paquetes necesarios están instalados, y en caso contrario los instalamos:

rpm -qa | grep -w ipa-server 2>/dev/null 1>/dev/null

if [[ "$?" != 0 ]]
then
	sudo yum -y install ipa-server
fi

rpm -qa | grep -w bind 2>/dev/null 1>/dev/null

if [[ "$?" != 0 ]]
then
	sudo yum -y install bind
fi

rpm -qa | grep -w bind-dyndb-ldap 2>/dev/null 1>/dev/null

if [[ "$?" != 0 ]]
then
	sudo yum -y install bind-dyndb-ldap
fi

rpm -qa | grep -w ipa-server-dns 2>/dev/null 1>/dev/null

if [[ "$?" != 0 ]]
then
	sudo yum -y install ipa-server-dns
fi

#packages="ipa-server bind bind-dyndb-ldap ipa-server-dns"

#sudo yum -y install $packages

# 2) Comprobamos si el dominio IPA está creado (solicitando un tique kerberos para
#    el administrador), y en caso contrario lo creamos:

echo ${PASSWD_ADMIN} | kinit "admin@${DOMINIO_KERBEROS}" 2>/dev/null 1>/dev/null

if [[ "$?" != "0" ]]
then
   	ipa-server-install -a ${PASSWD_ADMIN} -p ${PASSWD_ADMIN} --hostname=${fqdn} -r ${DOMINIO_KERBEROS} -n ${DOMINIO} --setup-dns --no-forwarders -U
fi


