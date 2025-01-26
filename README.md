# Que Es SecOpts?

SecOpts Es un repositorio dedicado a la seguridad informatica en el ambito mas personal que tiene el usuario, su computador. 

Esta Herramienta  esta enfatizada en Modificar u eliminar los protocolos inseguros que vienen configurados por defecto en sistemas operativos linux como kali, debian, lubuntu, ubuntu, entre otros... Protocolos que en un principio fueron creados y configurados para funcionar, mas no para ser seguros, por lo que carecen de una configuracion de seguridad robusta. 
Que es lo hace SecOpts? inspecciona las configuraciones y deshabilita los protocolos inseguros, cambiandolos por protocolos de seguridad robusta
un ejemplo de esto es cuando detecta que systemd esta encargandose se las consultas DNS, que por defecto, se conecta al primer servidor dns que le aparezca
SecOpts cuando detecta que esta SISTEMD esta trabajando, lo deshabilita y cambia de programa por uno con una seguridad mas robusta como con DNSCRYPT-PROXY, el cual establece un servidor dns el cual utiliza certificados para encriptar las peticiones, Evitando asi, atauques MITM y la Vigilacia masiva. talvez tambien otros veneficios


# Cambios
SecOpts no esta completo, tiene varias opciones de seguridad implemetadas y otras en proceso de implementacion

# Configuraciones implementadas
| Configuraciones                        | Descripción                                                                                      |
|:---------------------------------------|:-------------------------------------------------------------------------------------------------|
| Desactivación zona horaria             | Se desactiva la sincronización horaria automática (opcional)                                    |
| Configuración de Quad9                 | Configura el servicio de Quad9 como predeterminado, evitando el desvío de consultas DNS        |
| Desactivación de protocolos inútiles    | Desactiva protocolos inútiles que vienen activados por defecto, como CUPS o Avahi daemon       |
| Desactivación de MultiCast             | Se desactiva Multicast, evitando que se comunique innecesariamente con otras computadoras en la misma red |
| Desactivación de protocolo IPv6        | +En proceso de implementación+     Obliga a Reducir El Trafico (si funciona ipv4, no hace falta ipv6)       |
| Configuración de DNSCrypt              | DNSCrypt es útil para combatir la vigilancia masiva y ataques MITM  +En proceso de implementación+          |

# A tener en cuenta

SecOpts esta pensado para computadores personales, por lo cual hay varias consideraciones a tener en cuenta.

[+] Lectura De Trafico Reducida: SecOpts Desactiva Protocolos, evitando el trafico de esos protocolos, por lo cual, con herramientas como wireshark, muchas de las peticiones/trafico de red no sera mostrado.

<div style="border: 1px solid #f39c12; background-color: #f9e79f; padding: 10px; border-radius: 5px;">
  <strong>Nota:</strong> Diseñado para computadores personales, no para sistemas IDS.
</div>
