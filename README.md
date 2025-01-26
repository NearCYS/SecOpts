# Que Es SecOpts?

SecOpts Es un repositorio dedicado a la seguridad informatica en el ambito mas personal que tiene el usuario, su computador. 

Esta Herramienta  esta enfatizada en Modificar u eliminar los protocolos inseguros que vienen configurados por defecto en sistemas operativos linux como kali, debian, lubuntu, ubuntu, entre otros... Protocolos que en un principio fueron creados y configurados para funcionar, mas no para ser seguros, por lo que carecen de una configuracion de seguridad robusta. 
Que es lo hace SecOpts? inspecciona las configuraciones y deshabilita los protocolos inseguros, cambiandolos por protocolos de seguridad robusta
un ejemplo de esto es cuando detecta que systemd esta encargandose se las consultas DNS, que por defecto, se conecta al primer servidor dns que le aparezca
SecOpts cuando detecta que esta SISTEMD esta trabajando, lo deshabilita y cambia de programa por uno con una seguridad mas robusta como con DNSCRYPT-PROXY, el cual establece un servidor dns el cual utiliza certificados para encriptar las peticiones, Evitando asi, atauques MITM y la Vigilacia masiva. talvez tambien otros veneficios


# Cambios
SecOpts no esta completo, tiene varias opciones de seguridad implemetadas y otras en proceso de implementacion

# Configuraciones implementadas

    | Configuraciones     | Descripción          |
|------------|----------------------|
| Desactivacion zona horaria | Se desactiva la sincronizacion horaria automatica(opcional) |
| Configuracion de Quad9 | Configura el servicio de quad9 como predeterminado, envitando el desvio de consultas dns |
| Desactivacion de protocolos inutiles | Desactiva protocolos inutiles que vienen activados por defecto, como lo son cups(servicio sincronizacion con impresoras) o avahi daemon (protocolo dns automatico, se conecta a cualquier servidor dns) |
| Desactivacion de MultiCast| Se Desactiva Multicast, evitando que se comunique inecesariamente con otras computadoras en la misma red |
| Desactivacion de protocolo ipv6 | +En Proceso de Implementacion+ |
| Configuracion de dnscrypt | dns crypt es util para combatir la vigilancia masiva y ataques MITM |

#
