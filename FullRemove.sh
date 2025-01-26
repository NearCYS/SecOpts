#!/bin/bash

function PurgePrograma() {
	local Program=$1
	# Buscar archivos que coincidan con avahi-daemon
	archivos=$(locate $1 | grep "avahi-daemon")

	# Comprobar si se encontraron archivos
	if [ -z "$archivos" ]; then
	    echo "No se encontraron archivos que eliminar."
	    exit 0
	fi

	# Mostrar los archivos que se van a eliminar
	echo "Se eliminarán los siguientes archivos y directorios:"
	echo "$archivos"

	# Confirmar la eliminación
	read -p "¿Estás seguro de que deseas eliminar estos archivos y directorios? (s/n): " confirmacion

	if [[ "$confirmacion" == "s" || "$confirmacion" == "S" ]]; then
	    # Eliminar los archivos y directorios
	    echo "$archivos" | xargs rm -rf
	    echo "Archivos y directorios eliminados."
	else
	    echo "Operación cancelada."
	fi

}

PurgePrograma avahi-daemon 
