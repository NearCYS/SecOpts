# Que Es SecOpts?

SecOpts es un repositorio dedicado a la seguridad informática en el ámbito más personal que tiene el usuario: su computadora.

Esta herramienta está enfocada en modificar o eliminar los protocolos inseguros que vienen configurados por defecto en sistemas operativos Linux como Kali, Debian, Lubuntu, Ubuntu, entre otros. Estos protocolos, que en un principio fueron creados y configurados para funcionar, no están diseñados para ser seguros, por lo que carecen de una configuración de seguridad robusta.

¿Qué es lo que hace SecOpts? Inspecciona las configuraciones y deshabilita los protocolos inseguros, cambiándolos por protocolos de seguridad robusta. Un ejemplo de esto es cuando detecta que systemd se está encargando de las consultas DNS, que por defecto se conecta al primer servidor DNS que le aparece.

Cuando SecOpts detecta que systemd está trabajando, lo deshabilita y lo reemplaza por un programa con una seguridad más robusta, como DNSCrypt-Proxy, el cual establece un servidor DNS que utiliza certificados para encriptar las peticiones, evitando así ataques MITM y la vigilancia masiva. Tal vez también ofrece otros beneficios.

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

# Con respecto a las implementaciones nuevas que se vayan haciendo:

El proyecto está comentado; es como el mapa del proyecto, que explica qué es lo que está sucediendo en los scripts y las acciones que se están realizando. 
Esta iniciativa de documentar el proyecto a medida que avanza tiene el propósito de que cada desarrollador entienda lo más fácilmente posible la arquitectura del proyecto, facilitando las implementaciones de seguridad.

Por eso es importantes decirles que se compromentan en agregar la documentacion correspondiente a los cambios contribuidos/aplicados por ustedes.



