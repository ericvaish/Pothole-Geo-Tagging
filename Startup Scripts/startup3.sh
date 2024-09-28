#!/bin/bash

SCRIPT_DIR="/home/ericvaish/Pothole"
SSD_MOUNT_POINT=$(lsblk -o NAME,MOUNTPOINT | grep -E "/media|/mnt" | awk '{print $2}' | head -n 1)

if [ -z "$SSD_MOUNT_POINT" ]; then
    echo "No SSD found."
    exit 1
fi

OUTPUT_DIR="$SSD_MOUNT_POINT/Eric_V/Pothole_Recordings"

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating output directory at $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Script directory $SCRIPT_DIR does not exist."
    exit 1
fi

cd "$SCRIPT_DIR" || { echo "Failed to change directory to $SCRIPT_DIR"; exit 1; }

if [ ! -f "fan.py" ]; then
    echo "fan.py not found in $SCRIPT_DIR."
    exit 1
fi

if [ ! -f "record2.py" ]; then
    echo "record2.py not found in $SCRIPT_DIR."
    exit 1
fi

sudo python3 fan.py &
FAN_PID=$!
if ! ps -p $FAN_PID > /dev/null; then
    echo "fan.py failed to start."
    exit 1
fi
echo "fan.py running with PID $FAN_PID"

sudo python3 record2.py "$OUTPUT_DIR" &
RECORD_PID=$!
if ! ps -p $RECORD_PID > /dev/null; then
    echo "record2.py failed to start."
    exit 1
fi
echo "record2.py running with PID $RECORD_PID"
