#!/bin/bash
#Archivo utilizado para volver a la configuracion anterior, todo lo que se modifique al
#configurar el nuevo servicio dns, tendra que tener la devolucion a su estado anterior
#Es el proposito de este Archivo, restaurar la configuracion dns (Aveces suele dar errores)

# Colores para la salida
COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_RESET='\033[0m'

# Directorio de backup
BACKUP_DIR="/etc/dnscrypt-proxy/backup"

# Restaurar resolv.conf
if [ -f "$BACKUP_DIR/resolv.conf.bak" ]; then
    echo -e "${COLOR_GREEN}Restaurando /etc/resolv.conf...${COLOR_RESET}"
    sudo cp "$BACKUP_DIR/resolv.conf.bak" /etc/resolv.conf
else
    echo -e "${COLOR_RED}No se encontró el backup de /etc/resolv.conf.${COLOR_RESET}"
fi

# Restaurar la configuración de dnscrypt-proxy
if [ -f "$BACKUP_DIR/dnscrypt-proxy.toml.bak" ]; then
    echo -e "${COLOR_GREEN}Restaurando /etc/dnscrypt-proxy/dnscrypt-proxy.toml...${COLOR_RESET}"
    sudo cp "$BACKUP_DIR/dnscrypt-proxy.toml.bak" /etc/dnscrypt-proxy/dnscrypt-proxy.toml
elif [ -f "$BACKUP_DIR/dnscrypt-proxy.conf.bak" ]; then
    echo -e "${COLOR_GREEN}Restaurando /etc/dnscrypt-proxy/dnscrypt-proxy.conf...${COLOR_RESET}"
    sudo cp "$BACKUP_DIR/dnscrypt-proxy.conf.bak" /etc/dnscrypt-proxy/dnscrypt-proxy.conf
else
    echo -e "${COLOR_RED}No se encontró el backup de la configuración de dnscrypt-proxy.${COLOR_RESET}"
fi

# Reiniciar systemd-resolved
echo -e "${COLOR_GREEN}Reiniciando systemd-resolved...${COLOR_RESET}"
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved

echo -e "${COLOR_GREEN}Restauración completada. Las configuraciones originales han sido restauradas.${COLOR_RESET}"
