SHELL := /bin/bash
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

clean:
	sudo rm /tmp/minecraft-server.jar /etc/systemd/system/minecraft-server.service
	sudo userdel $(MINECRAFT_SERVER_LINUX_USER)
	rm -rf cache libraries

lint:
	shellcheck -x *.sh

read_env:
	set -o allexport; source .env; set +o allexport

setup:
	cp .env.example .env

install:
	./install.sh

run-installed: read_env
	cd /opt/minecraft-server
	/usr/bin/java \
		-Xmn$(MINIMUM_MEMORY_LIMIT) \
		-XX:SoftMaxHeapSize=$(SOFT_MAXIMUM_MEMORY_LIMIT) \
		-Xmx$(MAXIMUM_MEMORY_LIMIT) \
		-jar /opt/minecraft-server/minecraft-server.jar \
		--nogui

uninstall:
	sudo rm -rf /opt/minecraft-server
	sudo systemctl disable minecraft-server