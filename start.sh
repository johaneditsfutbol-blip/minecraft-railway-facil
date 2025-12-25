ç#!/bin/bash

echo "--- VERIFICANDO ARCHIVOS DEL SERVIDOR ---"

# ESTO ES LO NUEVO:
# Si el archivo server.jar no existe (porque el volumen está vacío), lo descargamos aquí.
if [ ! -f server.jar ]; then
    echo "--- DESCARGANDO PAPERMC (Primera vez) ---"
    curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21/builds/130/downloads/paper-1.21-130.jar
fi

echo "--- INICIANDO SISTEMA DE TÚNEL ---"

# Iniciar Playit
if [ -z "$PLAYIT_SECRET" ]; then
    echo "NO HAY CLAVE DE TÚNEL. BUSCA EL LINK EN LOS LOGS PARA RECLAMAR."
    playit &
else
    echo "USANDO CLAVE DE TÚNEL CONFIGURADA."
    playit --secret $PLAYIT_SECRET &
fi

# Esperamos un poquito para asegurar que Playit arranque
sleep 5

echo "--- INICIANDO MINECRAFT ---"
# Iniciamos el servidor
java -Xms1G -Xmx2G -jar server.jar nogui
