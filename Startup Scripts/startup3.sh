#!/bin/bash
SCRIPT_DIR="/home/ericvaish/Pothole"
SSD_MOUNT_POINT=$(lsblk -o NAME,MOUNTPOINT | grep -E "/media|/mnt" | awk '{print $2}' | head -n 1)

if [ -z "$SSD_MOUNT_POINT" ]; then
    echo "No SSD found. Please make sure the SSD is connected and mounted."
    exit 1
fi

OUTPUT_DIR="$SSD_MOUNT_POINT/Eric_V/Pothole_Recordings"

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating output directory at $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

cd "$SCRIPT_DIR" || { echo "Failed to change directory to $SCRIPT_DIR"; exit 1; }

# Run the Python scripts
sudo python3 fan.py &
sudo python3 record2.py "$OUTPUT_DIR" &
