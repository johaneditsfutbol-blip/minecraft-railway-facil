#!/bin/bash

echo "--- FASE 1: LIMPIEZA DE CONFIGURACIÓN ---"
# Borramos la configuración vieja para evitar conflictos
rm -f server.properties

echo "--- FASE 2: CREANDO CONFIGURACIÓN MAESTRA ---"
# Creamos el archivo de propiedades línea por línea
echo "motd=Server de Railway" >> server.properties
echo "server-port=25565" >> server.properties
# ESTO ES LO MÁS IMPORTANTE:
echo "online-mode=false" >> server.properties
echo "allow-flight=true" >> server.properties
echo "enable-status=true" >> server.properties
echo "enforce-secure-profile=false" >> server.properties
echo "white-list=false" >> server.properties

echo "--- FASE 3: EULA Y DESCARGA ---"
echo "eula=true" > eula.txt

if [ ! -f server.jar ]; then
    echo "--- DESCARGANDO PAPERMC ---"
    curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21/builds/130/downloads/paper-1.21-130.jar
fi

echo "--- FASE 4: INICIANDO TÚNEL PLAYIT ---"
if [ -z "$PLAYIT_SECRET" ]; then
    echo "ADVERTENCIA: No hay clave secreta. Revisa logs para link de claim."
    playit &
else
    echo "Playit iniciando con clave..."
    playit --secret $PLAYIT_SECRET &
fi

# Esperamos a que el túnel se estabilice
sleep 10

echo "--- FASE 5: LANZANDO MINECRAFT ---"
# Iniciamos
java -Xms1G -Xmx2G -jar server.jar nogui
