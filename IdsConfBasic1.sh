#!/bin/bash
#Enviar Tu Descripcion (3 campos por contribuidor)
#+++===+++===+++===+++Agradecimientos a los Contribuidores===+++===+++===+++
#NearCYS, Semilla de la idea, Estudiante de CiberSeguridad y Hacking (namorau De La Informatica)
#Perfil: http://onnifo55jjkkrcrzx2jonjh45y32qfh3iuffllksbtmp7tpi2lbefpyd.onion/user-57215.html
#Aportes: Configuracion de Dns Encriptado, Deshabilitacion de prtocolos inseguros(avahi demon, cups, multicast, autoreloj)

#============================== Colaboradores ==============================
# [Contacto]
# [Tor Link]  http://onnifo55jjkkrcrzx2jonjh45y32qfh3iuffllksbtmp7tpi2lbefpyd.onion/user-57215.html
# [Normal Link] https://www.onniforums.com/user-57215.html
# [+] Secopts es una herramienta deidcada a aplicar y automatizar buenas practicas a la hora de
# [+] configurar y modificar reglas a nivel de red predeterminadas en un entorno desde cero
# [+] por ejemplo: Me instale kali, pero por defecto NO viene con una configuracion de dns encriptado
# [+] otro ejemplo: Me instale lubuntu, pero por defecto tiene protocolos inseguros trabajando
#      a nivel de red (por defecto, avahi demon (IOT) escuchando en la 0.0.0.0, elijiendo al servidor dns mas cercano
#      haciendo suceptible a DNSSpoofing el sistema dns)
# [+] En mi preferencia, prefiero tener control a que servidores se hacen las consultas dns y de forma encriptada

# [++++++] Se aprecia el tiempo que se dedica a explicar la sintaxis :)

# [+] Su colaboracion con el script es fundamental para que demas usuarios tambien podamos disfrutar del potencial de esta herramienta
# [+] Contacto con el creador: onniforums usuario: NearCYS
# [+] Cualquier ayuda, recomendacion o critica es bien recivida
# [!] Reglas a seguir para aportar: El script no puede apuntar en ningun momento a direcciones externas 
# [!] (Que no son de confianza, como repositorios de X user)
# [!] Cadenas Obfuscada y Comportamientos Maliciosos no seran tomados enserio y no se le atribuiran reconocimientos 
# [!] en el caso de ser utilizados en el script, se los comunico ahora para no hacerles perder tiempo!. 
# [!] en el caso de detectar comportamientos maliciosos en el repositorio Secopts  reporteselos a: NearCYS

# [#] Bom Proveito!

###########################################################
#    Script Principalmente desarroyado en kali rolling    #
###########################################################
#        Sistemas Operativos Compatibles        #
#################################################
#  Kali linux rolling / purple  |    x32 x64    #
#  Debian                       |    x32 x64    #
#  Ubuntu, Lubutu, Xubuntu      |    x32 x64    #
#################################################
#    Si existe otra distro compatible, avisar   #
#################################################

function ColoresLogica(){
#Seguramente duratnte la modulacion del script tuve faltas ortograficas, tambien con respecto a los estados de repuesta
#esto fue por que me di cuenta tarde de agregar la descripcion del significado de los simbolos de estado de respuesta impresa
echo -e "${verde}[*]${amarillo}<- Respuestas Exitosas, la funcionalidad funciona correctamente${reset}"
echo -e "${verde}[i]${amarillo}<- informacion sobre X Software (Tips) \n    o sobre para que sirve cierta accion ${reset}"
echo -e "${verde[!]${amarillo}<- Algo Fallo: $? ${reset}"

}


rojo='\033[0;31m'      # Rojo
verde='\033[0;32m'     # Verde
amarillo='\033[1;33m'  # Amarillo
azul='\033[0;34m'      # Azul
magenta='\033[0;35m'   # Magenta
cyan='\033[0;36m'      # Cyan
blanco='\033[1;37m'    # Blanco
reset='\033[0m'        # Resetear color

function StartConfig (){
echo -e "${amarillo}ADVERTENCIA:${blanco} El Script Trabaja Mejor Con Sudo${reset}"
echo -e "${amarillo}ADVERTENCIA:${blanco} El Script Cambiara configuraciones de red en su dispositivo${reset}"
echo -e "${blanco} Esto puede afectar la forma en la que se monitoriza la red${reset}"
echo -e "${blanco} Su dispositivo tendra configuraciones que lo hacen menos suceptibles a revevrs shells, pero no podra ver todo el trafico de red${reset}"

echo -e "${blanco}=========================================================${reset}"

echo -e "${rojo}[${verde}*${rojo}]${amarillo} Detener la Sincronizacion automatica del Tiempo? ${reset}"
#agregaselo aca
read -p "[y/n]: " TimeSettings
if [[ $TimeSettings == "y" || $TimeSettings == "Y" ||$TimeSettings == "S" ||$TimeSettings == "s" ]] ;then
    if systemctl stop systemd-timesyncd.service && systemctl disable systemd-timesyncd.service ; then
        echo -e "${verde}[*]${amarillo} La Desabilitacion de la Sincronizacion del Tiempo fue exitosa ${reset}"
    else
        echo -e "${rojo}[${rojo}*${rojo}]${amarillo} no se a podido apagar la sincronizacion automatica, \n   revise el nombre del proceso en su ordenador \n     y agreguelo al script ${reset}"
    fi 
elif [[ $TimeSettings == "n" || $TimeSettings == "N" ]]; then
    echo -e "${rojo}[${cyan}*${rojo}]${amarillo} No se detuvo la sicronizacion automatica${reset}"
fi
}
###############################################################

# Función para mostrar conexiones válidas
function mostrar_conexiones {
    echo -e "${blanco}Configuracion DNS, Migracion a Quad9${reset}"
    echo -e "${rojo}[${verde}*${rojo}]${amarillo}Conexiones disponibles:"
    nmcli con show   # Muestra solo los nombres de las conexiones
}

# Bucle para solicitar una conexión válida
function ConfigQuad9Dns () {
while true; do
    mostrar_conexiones
    read -p "Selecciona la conexión que desea configurar: " Inter

    # Verificar si la conexión es válida
    if nmcli con show | grep -q "$Inter"; then
        # Intentar cambiar la configuración de DNS
        if nmcli con mod "$Inter" ipv4.dns '9.9.9.9,149.112.112.112' && nmcli con mod "$Inter" ipv6.dns '2620:fe::fe,2620:fe::9'&& nmcli con mod "$Inter" ipv4.ignore-auto-dns yes && nmcli con mod "$Inter" ipv6.ignore-auto-dns yes; then
            echo -e "${rojo}[${verde}*${rojo}]${amarillo} Configuración DNS cambiada en la conexión ${azul}'${Inter}'${amarillo}, Proveedor:${azul} Quad9*${reset}"
            echo -e "${cyan}DNS ipv6:${verde} 2620:fe::fe y 2620:fe::9 ${reset}"
            echo -e "${cyan}DNS ipv4:${verde} 9.9.9.9 y 149.112.112.112${reset}"
            break  # Salir del bucle si el cambio fue exitoso
        else
            echo -e "${rojo}Error al cambiar la configuración de DNS. inténtalo de nuevo.${reset}"
            systemctl restart NetworkManager
        fi
    else
        echo -e "${rojo}Conexión inválida. inténtalo de nuevo.${reset}"
        systemctl restart NetworkManager
        echo -e '${magenta}Resetando NetworkManager, Aguarde un momento... ${reset}'
        sleep 3
    fi
done
echo -e "${blanco}=========================================================${reset}"
echo -e "${blanco}Se Deshabilitara la configuracion Multicast, haciendo que ipv6 ya no trabaje${reset}"
echo "Como desactivar ipv6 desde un script para bash y zsh... etc? Queda de tarea... "
}
##################################################################
# Función para mostrar interfaces de red existentes
function mostrar_interfaces {
    echo -e "${rojo}[${verde}*${rojo}]${amarillo}Interfaces de red disponibles:"
    ip link show | awk -F ': ' '/^[0-9]+: / {print $2}'  # Muestra solo los nombres de las interfaces
}

# Bucle para solicitar una nterfaz de red válida
function ShowIfaces(){
while true; do
    mostrar_interfaces
    read -p "Provea una interfaz de red: " InterfazRed
    echo -e "${reset}"
    # Verificar si la interfaz es válida
    if ip link show "$InterfazRed" > /dev/null 2>&1; then
        echo -e "${rojo}[${verde}*${rojo}]${amarillo} Interfaz válida: ${InterfazRed}${reset}"
        break  # Salir del bucle si la interfaz es válida
    else
        echo -e "${rojo}Interfaz inválida. Por favor, inténtalo de nuevo.${reset}"
    fi
done
}

##################################################################
# Remove las antiguas librerias descargadas con la configuracion dns anterior
# habria que mejorar la logica para que valide bien la ejecucion del comando
function RemoveAPT(){
if [ $(rm -rf /var/lib/apt/lists/* && apt clean || apt autoclean && echo 0 ) -eq 0 ]; then
    echo -e "${rojo}[${verde}*${rojo}]${amarillo} Se eliminaron los paquetes de instalacion APT \n vuelvalos a descargar con la configuracion segura de DNS ${reset}"
else
    echo -e "${rojo}[${rojo}*${rojo}]${rojo} Path a la carpeta apt/list es invalido: ${rojo}line:128 ${reset}"
fi
}
###################################################################
# Función (IpLink) para aplicar configuraciones a la interfaz
# Desactiva el protocolo Multicast, esto desactiva el protocolo ipv6, pero esto es temporal.
# Lo ideal seria encontrar una configuracion mas eficiente, para denegar el protocolo multicast
#
function IpLink {

    echo -e "${rojo}[${verde}*${rojo}]${blanco} Desactivando la configuración multicast*${reset}"
    ip link set "$InterfazRed" allmulticast off
    ip link set "$InterfazRed" multicast off
    echo -e "${rojo}[${verde}*${rojo}]${amarillo} Configuración Multicast Deshabilitada${reset}"
    
    ip link set "$InterfazRed" arp off
    echo -e "${rojo}[${verde}*${rojo}]${amarillo} Configuración ARP Deshabilitada ${reset}"
    
    ip link set "$InterfazRed" down
    echo -e "${rojo}[${verde}*${rojo}]${amarillo} Aplicando Cambios${reset}"
    
    ip link set "$InterfazRed" up
    echo -e "${rojo}[${verde}*${rojo}]${amarillo} Configuración ARP Habilitada${reset}"
    ip link set "$InterfazRed" arp on

	echo -e "${blanco}=========================================================${reset}"

	echo -e " ${rojo}[${verde}*${rojo}]${amarillo}Reiniciando Interfaz, aplicando cambios...${reset}"
	echo '' > /etc/resolv.conf
	systemctl stop NetworkManager.service
	sleep 5 
	systemctl start NetworkManager.service
	sleep  5
	echo -e " ${rojo}[${verde}*${rojo}]${amarillo}Cambios aplicados${reset}"
	echo -e "${amarillo}ATENCION:${blanco}A continuacion, usted deveria solo ver las direcciones dns de quad9${reset}"
	echo -e "${blanco} Si usted ve que hay otro dns que no sea el de quad9${reset}"
	echo -e "${blanco} Significa que no se aplico correctamente el cambio de dns${reset}"
	    echo -e "${blanco} Puede resolver esto modficando la linea n°42${reset}"
	    cat /etc/resolv.conf

}

function Desinstalar (){
    echo -e "${blanco}=========================================================${reset}"
    echo -e "${verde}[i] ${amarillo}Se procedera a eliminar Software inecesario e inseguro ${reset}"
    local Programa=$1
    while true; do
        ############ MESSAGE BOX INFO ############
        #Aqui con la misma logica se indexa la descripcion de la herramienta que se quiere desinstalar
        # $Programa es el primer argumento que se le pasa a la funcion
        #Es para que el usuario sepa que es lo que va a desintalar/ cual es el cambio que se va a aplicar
        if [[ $Programa == "avahi-daemon" ]]; then
            echo -e "${amarillo}Avahi Demon es un demonio que se encarga de las resoluciones DNS MDNS. Se reemplazará por DnsCrypt proxy.\nEs un plugin del tipo IOT, en simples palabras, busca constantemente que un dispositivo externo se comunique con el servicio.${reset}"
            systemctl stop avahi-daemon
            systemctl disable avahi-daemon

        elif [[ $Programa == "cups" ]]; then
            echo -e "${amarillo}Cups es una aplicación amigable con el usuario enfatizada en el manejo de impresoras. No desinstalar en el caso de necesitarlo.${reset}"
        else 
            echo -e "${rojo}[!]${blanco} No hay información indexada sobre ${Programa}, indexela de ser posible.\nComparta la configuración con https://github.com/Misuario/Repo${reset}"
        fi

        ##########################################

        echo -e "${amarillo}¿Desinstalar ${Programa}?${reset}"
        read -p "[y/n]: " OpcionDesinstalar
        if [[ $OpcionDesinstalar == "y" || $OpcionDesinstalar == "Y" || $OpcionDesinstalar == "s" || $OpcionDesinstalar == "S" ]]; then
            echo -e "${verde}[+]${blanco} Entendido, se desinstalará ${Programa}.${reset}"
            if sudo systemctl stop $Programa && sudo systemctl disable $Programa ; then
                echo -e "${verde}[+]${blanco} Se Desactivo ${Programa} con éxito.${reset}"
            else
                echo -e "${rojo}[!]${blanco} No se pudo detener el proceso ${Programa}, Fijese si es que tiene otro nombre \n    y desactivelo manualmente ( Shell$> systemctl status )${reset}"

            fi
            if apt purge -y $Programa == 0; then
                echo -e "${verde}[+]${blanco} Se desinstaló ${Programa} con éxito.${reset}"
                break
            else
                echo -e "${rojo}[!]${blanco} ${Programa} no está instalado... Continuando con la configuración.${reset}"
                break
            fi
        elif [[ $OpcionDesinstalar == "n" || $OpcionDesinstalar == "N" ]]; then
            echo -e "${amarillo}No se desinstalará ${Programa}.${reset}"
            break
        else
            echo -e "${rojo}[!]${blanco} Opción no válida. Por favor, elija 'y' o 'n'.${reset}"
        fi
    done
}
#Uso:
#Desinstalar <tool>


function Instalar() {
    echo -e "${blanco}=========================================================${reset}"
    echo -e "${verde}[i] ${amarillo}Se procedera a Instalar Software para las configuraciones de seguridad ${reset}"
    local InstPrograma=$1


    ############ MESSAGE BOX INFO ############                
    #Aqui con la misma logica se indexa la descripcion de la herramienta que se quiere desinstalar
    # $InstPrograma es el primer argumento que se le pasa a la funcion
    #Es para que el usuario sepa que es lo que va a desintalar/ cual es el cambio que se va a aplicar 


    if [[ $InstPrograma == "dnscrypt-proxy" ]]; then
        echo -e "${amarillo}[${verde}i${amarillo}]${blanco} ${InstPrograma} es una herramienta especializada en la securización de las consultas DNS \n     ${reset}" 

    elif [[ $InstPrograma == "Otro Software" ]]; then
        echo "${amarillo}[${verde}i${amarillo}]${blanco} Informacion De Otro Programa que quiere agregar: ${Programa} (En conjunto con la configuracion del mismo)"
        
    else 
        echo -e "${amarillo}[${rojo}i${amarillo}]${blanco} No hay información indexada sobre ${InstPrograma}, indexela en el script. De ser posible \n Comparta la configuración con https://github.com/Misuario/Repo"
        #esto con la finalidad de que el tool reciba actualizaciones con respecto a mejoras de seguridad y buenas prácticas 
        #(Como la Asignación de un DNS encriptado)
    fi
    ##########################################
    while true; do
        #Esta seccion configura las herramientas y elementos de seguridad recien intalados, lo ideal, para no hacer un codigo tan confuso y largo en el script principal
        # es crear un script aparte y ejecutarlo como ./SecoptExtensionScript.sh/.py/.etc.... (Scripts auditados sin cadenas obfuscadas o redireccionamientos)
        # asi hacer el codigo mas legible, los comentarios son importante para que el usuario entienda correctamente el uso y objetivo de el script, mejorando la colaboracion
        # y facilitando el proceso de implementacion ()
        if command -v $InstPrograma &> /dev/null; then
            echo -e "${verde}[+]${blanco} ${InstPrograma} ya está instalado en su sistema, Procediendo a Aplicar Configuraciones ${reset}"
            #if [[ $ConfigProgramFunction == StatusOk ]]; then
            #    echo -e "${verde}[+]${blanco} Se aplicaron correctamente las configuraciones"
            #elif [[ $ConfigProgramFunction == StatusNo ]]; then
            #    echo -e "${rojo}[!]${blanco} No se aplicaron correctamente las configuraciones ERROR: \n $?"
            #
            #else
            #    echo -e "${rojo}[!]${blanco} Error: \n $?"
            #
            #
            #
            #
            #
            #fi
            break
        else
            echo -e "${verde}[${rojo}+${verde}] ${InstPrograma} no está instalado, ¿Quiere instalar y configurar $InstPrograma? ${reset}"
            read -p "[y/n]: " DesicionInstalar
            if [[ $DesicionInstalar == "y" || $DesicionInstalar == "Y" || $DesicionInstalar == "S" || $DesicionInstalar == "s" ]]; then
                echo -e "${amarillo}Intentando instalar ${InstPrograma} ${reset}"
                if apt install $InstPrograma; then
                    echo -e "${verde}[+]${blanco} ${InstPrograma} fue instalado con éxito${reset}"
                    echo -e "${amarillo}Se intentará aplicar las configuraciones${reset}"
                    #try: ConfigProgramFunction 
                    break
                else
                    echo -e "${rojo}[!]${blanco} No se encontro el repositorio de ${InstPrograma}... Actualizando repositorios ${reset}"
                    sudo apt full-upgrade -y
                fi 

            elif [[ $DesicionInstalar == "n" || $DesicionInstalar == "N" ]]; then
                 echo -e "${verde}[+]${blanco} No se instalará, ni se configurará ${InstPrograma}${reset}"
                 break
            else
                echo -e "${rojo}[!]${blanco} Opción no válida. Elija Nuevamente${reset}"
            fi
        fi
    done
}
# Uso:
# Instalar <Tool/1er argumento>

                          

# function ConfigSecDns () {}


                          
##########################
#          init          #
##########################
# Las funciones que estan con un numeral, es por que son futuras implementaciones de seguridad
# Quien quiera colaborar, aportando configuraciones robustas de seguridad, ayudando con las mejoras faltantes
# se agradece y valora el tiempo en comunidad para que tengamos un sistema mas seguro
StartConfig
ConfigQuad9Dns
ShowIfaces
RemoveAPT #Elimininacion de repositorios antigutos
IpLink #Configuracion Desctivacion del protocolo MultiCast (Creo que esta configuracion no es 100% efectiva, Revisar... )
#===========
#SystemdOutConfig #Si systemd esta trabajando, cambiarlo por un protocolo seguro como dnscrypt-proxy

Desinstalar cups #Desinstalador de X Software
Desinstalar avahi-daemon
Instalar dnscrypt-proxy #Encripta todas las consultas dns
#ConfigSecDnsCrypt #falta configurar dnscrypt de forma correcta
#sudo systemctl stop systemd-resolved
#

                          
