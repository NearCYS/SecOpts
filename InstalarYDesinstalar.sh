#!/bin/bash

rojo='\033[0;31m'      # Rojo
verde='\033[0;32m'     # Verde
amarillo='\033[1;33m'  # Amarillo
azul='\033[0;34m'      # Azul
magenta='\033[0;35m'   # Magenta
cyan='\033[0;36m'      # Cyan
blanco='\033[1;37m'    # Blanco
reset='\033[0m'        # Resetear color


function Desinstalar (){
    local Programa=$1
    while true; do
        if [[ $Programa == "avahi-daemon" ]]; then
            echo -e "${amarillo}Avahi Demon es un demonio que se encarga de las resoluciones DNS MDNS. Se reemplazará por DnsCrypt proxy.\nEs un plugin del tipo IOT, en simples palabras, busca constantemente que un dispositivo externo se comunique con el servicio.${reset}"
        elif [[ $Programa == "cups" ]]; then
            echo -e "${amarillo}Cups es una aplicación amigable con el usuario enfatizada en el manejo de impresoras. No desinstalar en el caso de necesitarlo.${reset}"
        else 
            echo -e "${rojo}[!]${blanco} No hay información indexada sobre ${Programa}, indexela de ser posible.\nComparta la configuración con https://github.com/Misuario/Repo${reset}"
        fi

        echo -e "${amarillo}¿Desinstalar ${Programa}?${reset}"
        read -p "[y/n]: " OpcionDesinstalar
        if [[ $OpcionDesinstalar == "y" || $OpcionDesinstalar == "Y" || $OpcionDesinstalar == "s" || $OpcionDesinstalar == "S" ]]; then
            echo -e "${verde}[+]${blanco} Entendido, se desinstalará ${Programa}.${reset}"
            if apt purge -y $Programa; then
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

Desinstalar cups


function Instalar() {
    local InstPrograma=$1

    if [[ $InstPrograma == "dnscrypt-proxy" ]]; then
        echo -e "${amarillo}[${verde}i${amarillo}]${blanco} ${InstPrograma} es una herramienta especializada en la securización de las consultas DNS \n     ${reset}" 
    else 
        echo -e "${amarillo}[${rojo}i${amarillo}]${blanco} No hay información indexada sobre ${InstPrograma}, indexela en el script. de ser posible \n Comparta la configuración con https://github.com/Misuario/Repo"
        #esto con la finalidad de que el tool reciba actualizaciones con respecto a mejoras de seguridad y buenas prácticas 
        #(Como la Asignación de un DNS encriptado)
    fi

    while true; do
        if command -v $InstPrograma &> /dev/null; then
            echo -e "${verde}[+]${blanco} ${InstPrograma} ya está instalado en su sistema, Procediendo a Aplicar Configuraciones ${reset}"
            #if [[ $ConfigProgramFunction == StatusOk ]]; then
            #    echo -e "${verde}[+]${blanco} Se aplicaron correctamente las configuraciones"
            #elif [[ $ConfigProgramFunction == StatusNo ]]; then
            #    echo -e "${rojo}[!]${blanco} No se aplicaron correctamente las configuraciones ERROR: \$?"
            #
            #else
            #    echo -e "${rojo}[!]${blanco} Error: \$?"
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

# Instalar <Tool>
Instalar ping

# function ConfigSecDns () {}

