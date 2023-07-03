#!/usr/bin/env bash

if [ ! -f .env ]; then
    export $(cat .env | xargs)
fi

function downloadMinecraftServerFromURLToFile {
    curl -L $1 -o $2
}

function main {
    echo Getting Minecraft server...
    downloadMinecraftServer $MINECRAFT_SERVER_URL minecraft-server.jar

    echo Requiring root access...
    sudo /bin/bash <<EOF
        cp minecraft-server.service /etc/systemd/systemd
        sudo chmod 755 /etc/systemd/system/minecraft-server.service
EOF

    echo Donezo.
}

main

