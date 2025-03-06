#!/bin/bash
set -eo pipefail

# Download and extract directly into the image's filesystem
curl -sL https://github.com/loft-sh/devpod/releases/latest/download/DevPod_linux_x86_64.tar.gz \
  | tar -xzvf - -C / --no-overwrite-dir

# Verify critical files
test -f /usr/bin/dev-pod-desktop || { echo "DevPod desktop binary missing!" >&2; exit 1; }
test -f /usr/bin/devpod-cli || { echo "DevPod CLI missing!" >&2; exit 1; }
test -f /usr/share/applications/DevPod.desktop || { echo ".desktop file missing!" >&2; exit 1; }

# Verify icons (check multiple sizes)
ICON_PATHS=(
  /usr/share/icons/hicolor/32x32/apps/dev-pod-desktop.png
  /usr/share/icons/hicolor/128x128/apps/dev-pod-desktop.png
  /usr/share/icons/hicolor/256x256@2/apps/dev-pod-desktop.png
)

found_icon=false
for path in "${ICON_PATHS[@]}"; do
  if test -f "$path"; then
    found_icon=true
    break
  fi
done

$found_icon || { echo "No icons found!" >&2; exit 1; }

# Update system databases
update-desktop-database /usr/share/applications
gtk-update-icon-cache /usr/share/icons/hicolor

echo "DevPod system integration complete"
