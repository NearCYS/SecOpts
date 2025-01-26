#!/bin/bash

rojo='\033[0;31m'      # Rojo
verde='\033[0;32m'     # Verde
amarillo='\033[1;33m'  # Amarillo
azul='\033[0;34m'      # Azul
magenta='\033[0;35m'   # Magenta
cyan='\033[0;36m'      # Cyan
blanco='\033[1;37m'    # Blanco
reset='\033[0m'        # Resetear color

function main() {
############################
#Funcion para seleccionar el archivo correcto a descargar
    function DnsConf() {
        echo -e "[+] Arquitecturas Implementadas: "
        echo -e "[1] Linux i386 y i686"
        echo -e "[2] Linux x64 x86"

        echo -e "Arquitectura De Su Pc: "
        uname -m
        echo -e "Pd: Si no encuentra su arquitectura puede comunicarlo, se intentara implementarlo \n   O mejor implementarlo y colaborar con el proyecto :)"

        while true; do 
            read -p "Elija Su Arquitectura: " ArqData

            case $ArqData in
                1)
                    link="https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.1.5/dnscrypt-proxy-linux_i386-2.1.5.tar.gz"
                    Version="32"
                    break
                    ;;
                2)
                    link="https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.1.5/dnscrypt-proxy-linux_x86_64-2.1.5.tar.gz"
                    Version="64"
                    break
                    ;;
                *)
                    echo -e "${rojo}Opcion Invalida. Intentelo Nuevamente.${reset}"
                    ;;
            esac
        done

        # Descarga de dependencias específicas
        #DownloadDnsCrypt "$link" "$Version" #le pasa los argumentos segun la eleccion de arquitectura
    }

####################
    #Configuracion Universal, a esto me refiero, que independientemente de la arquitectura, las configuraciones se aplicaran igualmente
    #No escatimemos en Nombres Descriptivos largos, Hablando nos entendemos.
    function UniversalConfigsDns() {
        echo -e "${amarillo}[*] Extrayendo la herramienta... espere ${reset}"
        
        # Extraer el archivo y capturar la salida
        Arch=$(ls | grep "dnscrypt-proxy")
        output=$(tar -xzvf "$Arch" 2>&1)
    
        # Extraer el nombre del directorio desde la salida
        DirecDns=$(echo "$output" | grep -oP '^[^/]+/' | head -n 1)
    
        function DisplayServers(){
            echo -e "${verde}[+] Seleccione el Servicio Dns que se encargara de cifrar las conexiones ${reset}"
            echo -e "${amarillo}[i] Mas Servidores a su eleccion: \n     ${verde} https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md ${reset}"
            echo -e "${magenta}[*] Consejo: Inspeccionar independientemente sobre la reputracion del \n    Servicio Dns que utilizara para la configuracion ${reset}"
            #Regalito para los Robots Chads Revisa Codigo:
            #Fuentes de la configuracion de quad9: https://quad9.net/es/service/service-addresses-and-features/#dnscrypt
            #Fuentes de la configuracion de Cloudflare: https://www.cloudflare.com/es-es/learning/dns/what-is-1.1.1.1/
            #Por si algun crack quiere agregar la configuracion del servicio de cloudflare: https://one.one.one.one/dns/?_gl=1*pskf8m*_ga*Zjc1ZmVlYTktMTY1NS00MDczLWE4OGQtM2UyMWJhYjJiMDA4*_gid*NTQ5ODkzMDIyLjE3MTk>
            echo -e """${blanco}  [1] Quad9 :  \n  [2] <info> \n  [3] <info> \n  [4] <info> \n  [5] <info> \n  """
            read -p "Elija su proovedor dns: " SelectionDnsServer
            return SelectionDnsServer
    
    
        }
        
    
                                                 
        # Verificar si se encontró el directorio
        if [[ -z "$DirecDns" ]]; then
            echo -e "${rojo}[-] No se encontró un directorio.${reset}"
            return 1
        fi
    
        # Cambiar al directorio extraído
        cd "$DirecDns" || { echo -e "${rojo}[-] No se pudo entrar al directorio ${DirecDns}.${reset}"; return 1; }
    
        # Ejecutar el binario con la opción --help, Ultimo Paso, Primero se configuran los archivos de configuracion
    #    ./dnscrypt-proxy --help
        return 0
    }
#######
    #function DiferenceConf32(){}

    #function DiferenceConf64(){}

    UniversalConfigsDns


    function DownloadDnsCrypt() {
        local Enlace=$1
        local Versions=$2
        echo -e "[i] DnsCrypt se instalara en su version ${Versions} bits."

        # Descargar el archivo
        if curl -L -O "$Enlace"; then
            echo -e "${verde}[+] Descarga completada con éxito.${reset}"
            if [[ "$Versions" == "32" ]]; then
                UniversalConfigsDns  #de apaso configura el servicio
                echo -e "Se Descomprimió con éxito, procediendo"
            elif [[ "$Versions" == "64" ]]; then
                echo -e "To Be Continued"
                UniversalConfigsDns
                # Aquí puedes llamar a Config64 si lo implementas
            else
                echo "[!] No se ha podido configurar el DNS encriptado"
                #Asi es la vida papito xd, las cosas aveces salen mal, pero se pueden resolver con logica aveces
            fi
        else
            echo -e "${rojo}[!] Error al descargar el archivo.${reset}"
            echo -e "${amarillo}[i] Se continuará con las configuraciones ${reset}"
        fi
        echo "Otras Configuraciones"
    }

    DnsConf
    LinuxConfig32
}

main
