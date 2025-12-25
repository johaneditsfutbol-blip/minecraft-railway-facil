#!/bin/bash

echo "--- INICIANDO SISTEMA ---"

# 1. Iniciar el Túnel Playit en segundo plano
# Si no hay clave secreta, generará un link para reclamar.
if [ -z "$PLAYIT_SECRET" ]; then
    echo "NO HAY CLAVE DE TÚNEL. BUSCA EL LINK EN LOS LOGS PARA RECLAMAR."
    playit &
else
    echo "USANDO CLAVE DE TÚNEL CONFIGURADA."
    playit --secret $PLAYIT_SECRET &
fi

# 2. Iniciar Servidor Minecraft
# Le damos 2GB de RAM (ajustable a Railway)
echo "--- INICIANDO MINECRAFT ---"
java -Xms1G -Xmx2G -jar server.jar nogui
