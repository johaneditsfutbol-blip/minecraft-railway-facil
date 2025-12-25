#!/bin/bash

echo "--- ACEPTANDO EULA ---"
# Esto crea el archivo de licencia automáticamente para que no se apague
echo "eula=true" > eula.txt

echo "--- VERIFICANDO ARCHIVOS DEL SERVIDOR ---"
# Si el archivo server.jar no existe, lo descargamos
if [ ! -f server.jar ]; then
    echo "--- DESCARGANDO PAPERMC ---"
    curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21/builds/130/downloads/paper-1.21-130.jar
fi

echo "--- INICIANDO SISTEMA DE TÚNEL ---"
# Iniciamos Playit en segundo plano
if [ -z "$PLAYIT_SECRET" ]; then
    echo "NO HAY CLAVE. BUSCA EL LINK EN LOS LOGS."
    playit &
else
    echo "USANDO CLAVE DE TÚNEL CONFIGURADA."
    playit --secret $PLAYIT_SECRET &
fi

# Esperamos 5 segundos
sleep 5

echo "--- INICIANDO MINECRAFT ---"
# Iniciamos el servidor con 2GB de RAM
java -Xms1G -Xmx2G -jar server.jar nogui
