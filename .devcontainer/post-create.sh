#!/usr/bin/env bash
# Installation unique à la création du codespace : arduino-cli + cœur AVR (Uno, Nano, Mega).
set -euo pipefail

mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR="$HOME/.local/bin" sh
export PATH="$HOME/.local/bin:$PATH"

arduino-cli config init --overwrite
arduino-cli core update-index
arduino-cli core install arduino:avr

# Bibliothèques citées par les sketchs, si un fichier de liste existe
if [ -f .devcontainer/arduino-libs.txt ]; then
	grep -vE '^\s*(#|$)' .devcontainer/arduino-libs.txt | while read -r lib; do
		arduino-cli lib install "$lib" || echo "Bibliothèque introuvable : $lib"
	done
fi
