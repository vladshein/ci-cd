#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
	echo "Error: run with sudo"
	echo "sudo ./install_dev_tools.sh"
	exit 1
fi

. /etc/os-release

echo "System $PRETTY_NAME"

install_docker () {
	if command -v docker &>/dev/null; then 
		echo "[Docker] is already installed"
		return
	fi
	
	echo "Docker is installing..."

	apt-get update -qq
	apt-get install -y ca-certificates curl gnupg

	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL "https://download.docker.com/linux/${ID}/gpg" \
		| gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	chmod a+r /etc/apt/keyrings/docker.gpg

	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	
	apt-get update -qq
	apt-get install -y docker-ce docker-cli containerd.io docker-buildx-plugin docker-compose-plugin

	echo "[Docker] Installed: $(docker --version)"
}

install_docker_compose () {
	if docker compose --version  &>/dev/null; then 
		echo "[Docker compose] is already installed $(docker compose version)"
		return
	fi
	
	echo "Docker compose is installing..."
	apt-get install -y docker-compose-plugin

	echo "[Docker compose] installed: $(docker compose version)"
}

install_python() {
	if command -v python3 &>/dev/null \
		&& python3 -c "import sys; sys.exit(0 if sys.version_info >= (3.9) else 1)" 2>/dev/null; then	
		echo "[Python] is already installed: $(python3 --version)"
		return
	else
		echo "[Python] Installing..."
		apt-get update -qq
		apt-get install -y python3 python3-pip python3-venv
		echo "[Python] installed: $(python3 --version)"
	fi

	if ! python3 -m pip --version &>/dev/null; then
		echo "[pip] Installing..."
		apt-get install -y python3-pip
	fi
	echo "[pip] $(python3 -m pip --version)"
}

install_django() {
	if python3 -c "import django" 2>/dev/null; then
		echo "[Django] already installed: $(python3 -c 'import django; print(django.get_version())')"
		return
	fi

	echo "[Django] Installing..."

	python3 -m pip install django 

	echo "[Django] Installed: $(python3 -c 'import django; print(django.get_version())')"
}

main() {
	echo "Start"
	install_docker
	install_docker_compose
	install_python
	install_django

	echo "All packages installed"
}

main
