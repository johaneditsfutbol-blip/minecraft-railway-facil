#!/bin/bash

echo "--- 1. ACEPTANDO EULA ---"
echo "eula=true" > eula.txt

echo "--- 2. VERIFICANDO ARCHIVOS ---"
if [ ! -f server.jar ]; then
    echo "--- DESCARGANDO PAPERMC ---"
    curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21/builds/130/downloads/paper-1.21-130.jar
fi

echo "--- 3. APLICANDO PARCHES DE BEDROCK ---"
# Esto es vital. Si no existe server.properties, lo creamos vacío para poder editarlo
if [ ! -f server.properties ]; then
    touch server.properties
fi

# AQUI ESTA LA MAGIA: Forzamos la configuración compatible con Bedrock
# Desactivamos el modo online (para que Geyser pase sin pedir cuenta Java)
sed -i 's/online-mode=true/online-mode=false/g' server.properties || echo "online-mode=false" >> server.properties
# Permitimos vuelo (Bedrock a veces parece que vuela por lag y el server lo expulsa si esto no está activo)
sed -i 's/allow-flight=false/allow-flight=true/g' server.properties || echo "allow-flight=true" >> server.properties
# Desactivamos seguridad estricta de chat que da problemas
sed -i 's/enforce-secure-profile=true/enforce-secure-profile=false/g' server.properties || echo "enforce-secure-profile=false" >> server.properties

echo "--- 4. INICIANDO TÚNEL PLAYIT ---"
if [ -z "$PLAYIT_SECRET" ]; then
    echo "NO HAY CLAVE. REVISA LOS LOGS."
    playit &
else
    echo "USANDO CLAVE CONFIGURADA."
    playit --secret $PLAYIT_SECRET &
fi

sleep 5

echo "--- 5. INICIANDO MINECRAFT ---"
java -Xms1G -Xmx2G -jar server.jar nogui
