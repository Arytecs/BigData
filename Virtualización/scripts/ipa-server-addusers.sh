#!/bin/bash
# ipa-server-addusers.sh

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
# - fich_usuarios (fichero): nombre de fichero CSV que contiene los 
#                            usuarios a crear.
#                            Parámetro obligatorio.
#
#       En el fichero, hay una línea por cada usuario, y sus datos son los
#       siguientes, en orden y separados por comas:
#
#       login_name,contraseña,Nombre,Apellidos
#


# 0) Comprobación previa de parámetros de entrada obligatorios

if [[ ! $1 ]]
then
	echo "Error: fich_usuarios no introducido."
	exit 1
fi

# 1) Comprobamos la existencia del fichero de usuarios (relativo al directorio
#    actual "./scripts/") y en caso contrario salimos con error.

cd ..
cd ..
cd vagrant/scripts/

if [[ ! -a $1 ]]
then
	echo "Error: el fich_usuarios no existe o no ha sido introducido en 'carpeta del proyecto'/scripts/."
	exit 1
fi

# 2) Comprobamos la existencia del dominio IPA (solicitando un tique Kerberos
#    para admin@ADMON.LAB) y en caso contrario salimos con error.

echo ${PASSWD_ADMIN} | kinit "admin@${DOMINIO_KERBEROS}" 2>/dev/null 1>/dev/null

if [[ "$?" != "0" ]]
then
   	echo "Error: No existe el dominio IPA."
	exit 1
fi

# 3) Procesamos el fichero CSV:
#
# Para cada línea:
#  Comprobamos si el usuario ya existe, mediante la orden
#     ipa user-show ${login_name} 
#  y en caso contradio lo creamos, mediante la orden
#     ipa user-add ${login_name} --first ${Nombre} --last $ {Apellidos} --password 

oldIFS=$IFS     # conserva el separador de campo
IFS=$'\n'     # nuevo separador de campo, el caracter fin de línea

for linea in $(cat $1)
do
	login_name=${linea%%,*}
	aux=${linea#"$login_name,"}
	password=${aux%%,*}
	aux=${aux#"$password,"}
	Nombre=${aux%,*}
	Apellidos=${aux#*,}

	ipa user-show ${login_name}

	if [[ "$?" != "0" ]]
	then
		echo ${password} | ipa user-add ${login_name} --first ${Nombre} --last ${Apellidos} --password
	fi
	
done

IFS=$old_IFS

