#!/bin/bash

DESTINATION=$1
PORT=$2
CHAT=$3

# Clonar el repositorio de Flectra
git clone --depth=1 https://gitlab.com/flectra-hq/flectra.git $DESTINATION
rm -rf $DESTINATION/.git

# Establecer permisos
mkdir -p $DESTINATION/postgresql
sudo chmod -R 777 $DESTINATION

# Configuración del sistema para inotify
if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then 
    echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf)
else 
    echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf
fi
sudo sysctl -p

# Crear el archivo docker-compose.yml en el directorio de destino
cat <<EOL > $DESTINATION/docker-compose.yml
version: '3.8'

services:
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: flectra
      POSTGRES_USER: flectra
      POSTGRES_PASSWORD: flectra
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - flectra-net

  flectra:
    image: flectrahq/flectra:2.0
    depends_on:
      - db
    environment:
      DB_HOST: db
      DB_PORT: 5432
      DB_USER: flectra
      DB_PASSWORD: flectra
      DB_NAME: flectra
    ports:
      - "$PORT:7073"
      - "$CHAT:$CHAT"
    volumes:
      - flectra_data:/var/lib/flectra
    networks:
      - flectra-net

volumes:
  postgres_data:
  flectra_data:

networks:
  flectra-net:
EOL

# Ejecutar Flectra con Docker Compose
docker-compose -f $DESTINATION/docker-compose.yml up -d

echo "Started Flectra @ http://localhost:$PORT | Live chat port: $CHAT"
