#!/bin/bash

# Colores para la salida
COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_RESET='\033[0m'

# Directorio de backups
BACKUP_DIR="/opt/dnscrypt-backups"
mkdir -p "$BACKUP_DIR"

# Archivos a hacer backup
FILES_TO_BACKUP=(
    "/etc/resolv.conf"
    "/opt/encrypted-dns/encrypted-dns.toml"
    "/etc/systemd/system/encrypted-dns.service"
    "/etc/systemd/system/dnscrypt-proxy.service"
)

# Función para hacer backups
backup_config() {
    for FILE in "${FILES_TO_BACKUP[@]}"; do
        if [ -f "$FILE" ]; then
            FILENAME=$(basename "$FILE")
            echo -e "${COLOR_GREEN}Haciendo backup de $FILE...${COLOR_RESET}"
            sudo cp "$FILE" "$BACKUP_DIR/${FILENAME}_backup_$(date +"%Y-%m-%d_%H-%M-%S")"
        else
            echo -e "${COLOR_RED}No se encontró el archivo $FILE. No se puede hacer backup.${COLOR_RESET}"
        fi
    done
}

# 1. Hacer backup de las configuraciones originales
echo -e "${COLOR_GREEN}Creando backups de las configuraciones...${COLOR_RESET}"
backup_config

# 2. Variables para la instalación
DOWNLOAD_URL="https://github.com/DNSCrypt/encrypted-dns-server/releases/download/0.9.16/encrypted-dns_0.9.16_amd64.deb"
DIR="/opt/encrypted-dns"
CONFIG_FILE="/opt/encrypted-dns/encrypted-dns.toml"
SYSTEMD_SERVICE="/etc/systemd/system/encrypted-dns.service"

# 3. Crear directorio y descargar el paquete de DNSCrypt
echo -e "${COLOR_GREEN}Creando directorio y descargando el paquete de DNSCrypt...${COLOR_RESET}"
sudo mkdir -p $DIR
wget -O /tmp/encrypted-dns.deb $DOWNLOAD_URL

# 4. Instalar el paquete
echo -e "${COLOR_GREEN}Instalando el servidor DNSCrypt...${COLOR_RESET}"
sudo apt install -y /tmp/encrypted-dns.deb
sudo apt install -f -y

# 5. Copiar archivo de configuración de ejemplo
echo -e "${COLOR_GREEN}Copiando el archivo de configuración...${COLOR_RESET}"
sudo cp /usr/share/doc/encrypted-dns/example-encrypted-dns.toml $CONFIG_FILE

# 6. Editar archivo de configuración
echo -e "${COLOR_GREEN}Editando archivo de configuración...${COLOR_RESET}"
sudo sed -i 's/^listen_addrs =.*/listen_addrs = [{ local = "0.0.0.0:443", external = "0.0.0.0:443" }]/' $CONFIG_FILE
sudo sed -i 's/^upstream_addr =.*/upstream_addr = "9.9.9.9:53"/' $CONFIG_FILE  # Usando los servidores DNS de Quad9
sudo sed -i 's/^provider_name =.*/provider_name = ""/' $CONFIG_FILE
sudo sed -i 's/^dnssec =.*/dnssec = true/' $CONFIG_FILE
sudo sed -i 's/^no_filters =.*/no_filters = true/' $CONFIG_FILE
sudo sed -i 's/^no_logs =.*/no_logs = true/' $CONFIG_FILE

# 7. Crear servicio systemd
echo -e "${COLOR_GREEN}Creando archivo de servicio systemd para DNSCrypt...${COLOR_RESET}"
sudo bash -c 'cat << EOF > $SYSTEMD_SERVICE
[Unit]
Description=DNSCrypt v2 server
ConditionFileIsExecutable=/usr/bin/encrypted-dns
After=syslog.target network-online.target

[Service]
StartLimitInterval=5
StartLimitBurst=10
ExecStart=/usr/bin/encrypted-dns -c $CONFIG_FILE
WorkingDirectory=$DIR
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF'

# 8. Recargar systemd y habilitar el servicio
echo -e "${COLOR_GREEN}Recargando systemd y habilitando el servicio...${COLOR_RESET}"
sudo systemctl daemon-reload
sudo systemctl enable --now encrypted-dns

# 9. Verificar el estado del servicio
echo -e "${COLOR_GREEN}Verificando el estado del servicio...${COLOR_RESET}"
sudo systemctl status encrypted-dns

# 10. Permitir tráfico en los puertos necesarios
echo -e "${COLOR_GREEN}Permitiendo tráfico en los puertos 53 y 443...${COLOR_RESET}"
sudo ufw allow 443
sudo ufw allow 53

# 11. Instalación del cliente DNSCrypt
echo -e "${COLOR_GREEN}Instalando el cliente DNSCrypt...${COLOR_RESET}"
CLIENT_VERSION=$(curl -s https://api.github.com/repos/DNSCrypt/dnscrypt-proxy/releases/latest | grep tag_name | cut -d '"' -f 4)
CLIENT_DOWNLOAD_URL="https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/$CLIENT_VERSION/dnscrypt-proxy-linux_x86_64-${CLIENT_VERSION}.tar.gz"
wget -O /tmp/dnscrypt-proxy.tar.gz $CLIENT_DOWNLOAD_URL
tar -xvzf /tmp/dnscrypt-proxy.tar.gz -C /tmp/

# 12. Configuración del cliente DNSCrypt
echo -e "${COLOR_GREEN}Configurando el cliente DNSCrypt...${COLOR_RESET}"
cd /tmp/linux-x86_64
sudo cp example-dnscrypt-proxy.toml dnscrypt-proxy.toml

# Obtener el sello DNS del servidor
STAMP=$(sudo systemctl status encrypted-dns | grep "sdns://" | awk '{print $3}')
sudo sed -i "s|#static|[static]|" dnscrypt-proxy.toml
sudo sed -i "s|#static.'myserver'.stamp|static.'myserver'.stamp = \"$STAMP\"|" dnscrypt-proxy.toml

# 13. Iniciar el cliente DNSCrypt
echo -e "${COLOR_GREEN}Iniciando el cliente DNSCrypt...${COLOR_RESET}"
sudo ./dnscrypt-proxy --config dnscrypt-proxy.toml

# 14. Verificar que el cliente DNSCrypt está funcionando
echo -e "${COLOR_GREEN}Verificando si el cliente DNSCrypt está funcionando...${COLOR_RESET}"
nslookup example.com 127.0.0.1

# 15. Configurar DNS localmente (resolv.conf)
echo -e "${COLOR_GREEN}Configurando DNS localmente...${COLOR_RESET}"
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolv.conf'

# 16. Iniciar el cliente como servicio systemd
echo -e "${COLOR_GREEN}Creando servicio systemd para el cliente DNSCrypt...${COLOR_RESET}"
sudo bash -c 'cat << EOF > /etc/systemd/system/dnscrypt-proxy.service
[Unit]
Description=DNSCrypt v2 client
ConditionFileIsExecutable=/usr/local/bin/dnscrypt-proxy
After=syslog.target network-online.target

[Service]
StartLimitInterval=5
StartLimitBurst=10
ExecStart=/usr/local/bin/dnscrypt-proxy --config /opt/dnscrypt-proxy/dnscrypt-proxy.toml
WorkingDirectory=/opt/dnscrypt-proxy/
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF'

# 17. Habilitar e iniciar el servicio cliente DNSCrypt
echo -e "${COLOR_GREEN}Habilitando e iniciando el servicio cliente DNSCrypt...${COLOR_RESET}"
sudo systemctl daemon-reload
sudo systemctl enable --now dnscrypt-proxy

echo -e "${COLOR_GREEN}¡Todo listo! Tu servidor DNSCrypt debería estar funcionando correctamente.${COLOR_RESET}"

