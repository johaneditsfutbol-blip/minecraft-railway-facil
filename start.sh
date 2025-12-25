#!/bin/bash

echo "--- FASE 1: LIMPIEZA Y PREPARACIÓN ---"
rm -f server.properties
# Aceptamos EULA
echo "eula=true" > eula.txt

echo "--- FASE 2: CONFIGURACIÓN JAVA (SERVER.PROPERTIES) ---"
echo "motd=Server Railway" >> server.properties
echo "server-port=25565" >> server.properties
echo "online-mode=false" >> server.properties
echo "allow-flight=true" >> server.properties
echo "enforce-secure-profile=false" >> server.properties
echo "white-list=false" >> server.properties

echo "--- FASE 2.5: FORZANDO CONFIGURACIÓN GEYSER (BEDROCK) ---"
# Creamos la carpeta si no existe
mkdir -p plugins/Geyser-Spigot
# Creamos un config.yml básico para Geyser forzando el puerto 19132 y Floodgate
cat <<EOF > plugins/Geyser-Spigot/config.yml
bedrock:
  address: 0.0.0.0
  port: 19132
  clone-remote-port: false
  motd1: "Railway Server"
  motd2: "Geyser"
remote:
  address: 127.0.0.1
  port: 25565
  auth-type: floodgate
floodgate-key-file: key.pem
saved-user-logins:
  - "null"
pending-authentication-wait: 0
debug-mode: false
allow-third-party-capes: true
passthrough-motd: true
passthrough-player-counts: true
legacy-ping-passthrough: true
ping-passthrough-interval: 3
EOF

echo "--- FASE 3: DESCARGA DE ARCHIVOS ---"
if [ ! -f server.jar ]; then
    echo "--- DESCARGANDO PAPERMC ---"
    curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21/builds/130/downloads/paper-1.21-130.jar
fi

echo "--- FASE 4: INICIANDO TÚNEL PLAYIT ---"
if [ -z "$PLAYIT_SECRET" ]; then
    echo "ADVERTENCIA: No hay clave secreta. Revisa logs."
    playit &
else
    echo "Playit iniciando..."
    playit --secret $PLAYIT_SECRET &
fi

sleep 10

echo "--- FASE 5: LANZANDO MINECRAFT ---"
java -Xms1G -Xmx2G -jar server.jar nogui
