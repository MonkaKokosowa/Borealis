#!/bin/bash
set -eo pipefail

# Download and extract directly into the image's /usr
curl -sL https://github.com/loft-sh/devpod/releases/latest/download/DevPod_linux_x86_64.tar.gz \
  | sudo tar -xzvf - -C / --no-overwrite-dir --no-same-owner

# Verify critical files exist
sudo test -f /usr/bin/dev-pod-desktop || { echo "DevPod binary missing!" >&2; exit 1; }
sudo test -f /usr/share/applications/DevPod.desktop || { echo ".desktop file missing!" >&2; exit 1; }

# Update system databases
sudo update-desktop-database /usr/share/applications
sudo gtk-update-icon-cache /usr/share/icons/hicolor

echo "DevPod system integration complete"