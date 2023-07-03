#!/usr/bin/env bash

if [ -f .env ]; then
    # shellcheck source=.env
    set -o allexport; source .env; set +o allexport
fi

function downloadMinecraftServerFromURLToFile {
    if [ ! -f "$2" ]; then
        if ! curl -L "$1" -o "$2"; then
            echo Error in downloading error: code $?.
            exit 255
        fi
    return
    fi
    echo A downloaded Minecraft server is found. Let\'s use that instead.
}

function installServiceToSystemd {
    sudo /bin/bash <<EOF
        mkdir -p /opt/minecraft-server
        cp -t /opt/minecraft-server assets/minecraft-server.service /tmp/minecraft-server.jar
        chmod -R 644 /opt/minecraft-server
        ln -s /opt/minecraft-server/minecraft-server.service /etc/systemd/system/minecraft-server.service
EOF
}

function createServerUser {
    if ! grep -q "$1" /etc/passwd; then
        echo User "$1" not found, creating.
        sudo useradd "$1"
        return
    fi
    echo User "$1" is found in passwd, skipping.
}

function main {
    echo Getting Minecraft server from "$MINECRAFT_SERVER_URL"...
    downloadMinecraftServerFromURLToFile "$MINECRAFT_SERVER_URL" /tmp/minecraft-server.jar

    echo Requiring root access...
    installServiceToSystemd

    echo Creating a minecraft server user "$MINECRAFT_SERVER_LINUX_USER"...
    createServerUser "$MINECRAFT_SERVER_LINUX_USER"

    echo Registering a systemd service
    sudo systemctl enable minecraft-server

    echo Donezo.
}

main

