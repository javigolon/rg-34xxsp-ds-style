#!/bin/sh
# The launch.sh script edited for detecting the device.
# In theory it should be possible to add different devices in the future but that's out of my goal.
set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 1
BOARD=$(head -n 1 /mnt/vendor/oem/board.ini 2>/dev/null || true)

case "$BOARD" in
    RG34xxSP)
        exec "$SCRIPT_DIR/launch_34xxsp.sh" "$@"
        ;;
    *)
        exec "$SCRIPT_DIR/launch_stock.sh" "$@"
        ;;
esac
