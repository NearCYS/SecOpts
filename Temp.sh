#!/bin/bash

rojo='\033[0;31m'      # Rojo
verde='\033[0;32m'     # Verde
amarillo='\033[1;33m'  # Amarillo
azul='\033[0;34m'      # Azul
magenta='\033[0;35m'   # Magenta
cyan='\033[0;36m'      # Cyan
blanco='\033[1;37m'    # Blanco
reset='\033[0m'        # Resetear color



function LinuxConfig32() {
    echo -e "${amarillo}[i] Extrayendo la herramienta... espere ${reset}"
    
    # Extraer el archivo y capturar la salida
    Arch=$(ls | grep "dnscrypt-proxy")
    output=$(tar -xzvf "$Arch" 2>&1)

    # Extraer el nombre del directorio desde la salida
    DirecDns=$(echo "$output" | grep -oP '^[^/]+/' | head -n 1)
    ########Enfocarse aca############# 
    function DisplayServers(){
        echo -e "${verde}[+] Seleccione el Servicio Dns que se encargara de cifrar las conexiones ${reset}"
        echo -e "${amarillo}[i] Mas Servidores a su eleccion: \n     ${verde} https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md ${reset}"
        echo -e "${magenta}[*] Consejo: Inspeccionar independientemente sobre la reputracion del \n    Servicio Dns que utilizara para la configuracion ${reset}"
        #Regalito para los Robots Chads Revisa Codigo:
        #Fuentes de la configuracion de quad9: https://quad9.net/es/service/service-addresses-and-features/#dnscrypt
        #Fuentes de la configuracion de Cloudflare: https://www.cloudflare.com/es-es/learning/dns/what-is-1.1.1.1/
        #Por si algun crack quiere agregar la configuracion del servicio de cloudflare: https://one.one.one.one/dns/?_gl=1*pskf8m*_ga*Zjc1ZmVlYTktMTY1NS00MDczLWE4OGQtM2UyMWJhYjJiMDA4*_gid*NTQ5ODkzMDIyLjE3MTkyNDI4Mzg.*_gac*Q2p3S0NBandnZGF5QmhCUUVpd0FYaE14dG9mSmhOaWRZZTM3Y1ZFVk00MDVkZFAzUGtqYndXZmJJMzJKR0xpSDhxeFBXRnN0cVNpam14b0N4MTRRQXZEX0J3RS4xNzE2ODk1ODE5
        echo -e """${blanco}  [1] Quad9 :  \n  [2] <info> \n  [3] <info> \n  [4] <info> \n  [5] <info> \n  """
        read -p "Elija su proovedor dns: " SelectionDnsServer
        return SelectionDnsServer


    }
    ###########################################3

                                             
    # Verificar si se encontró el directorio
    if [[ -z "$DirecDns" ]]; then
        echo -e "${rojo}[-] No se encontró un directorio.${reset}"
        return 1
    fi

    # Cambiar al directorio extraído
    cd "$DirecDns" || { echo -e "${rojo}[-] No se pudo entrar al directorio ${DirecDns}.${reset}"; return 1; }

    # Ejecutar el binario con la opción --help
    ./dnscrypt-proxy --help
    return 0
}

LinuxConfig32
