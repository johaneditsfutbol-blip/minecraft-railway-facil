# Usamos Java 21 (Necesario para las versiones nuevas de Minecraft)
FROM eclipse-temurin:21-jdk-jammy

# Instalamos herramientas básicas
RUN apt-get update && apt-get install -y curl jq

# Creamos la carpeta donde vivirá el servidor
WORKDIR /data

# Script para descargar automáticamente PaperMC (El servidor optimizado)
# Descarga la última versión disponible de la 1.21. Si quieres otra, cambia el numero abajo.
RUN curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21/builds/130/downloads/paper-1.21-130.jar

# Creamos la carpeta de plugins
RUN mkdir plugins

# Descargamos GEYSER (Para que entren celulares)
ADD https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot plugins/Geyser-Spigot.jar

# Descargamos FLOODGATE (Para entrar sin cuenta original de Java)
ADD https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot plugins/floodgate-spigot.jar

# Descargamos LUCKPERMS (Para los rangos que pediste)
ADD https://download.luckperms.net/v5.4.131/LuckPerms-Bukkit-5.4.131.jar plugins/LuckPerms.jar

# Descargamos el programa del TÚNEL (Playit.gg)
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit.list
RUN apt-get update && apt-get install -y playit

# Aceptamos el contrato de Minecraft (EULA)
RUN echo "eula=true" > eula.txt

# Copiamos el script de arranque (que crearemos en el paso B)
COPY start.sh /start.sh
RUN chmod +x /start.sh

# El comando que ejecuta todo
CMD ["/start.sh"]
