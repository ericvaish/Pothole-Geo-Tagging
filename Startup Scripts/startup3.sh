#!/bin/bash

# Define mount point
MOUNT_POINT="/home/ericvaish/Pothole_SSD"

# Get the UUID of the SSD by checking its mount point (assuming it appears under /media/ericvaish/)
DEVICE_UUID=$(lsblk -o NAME,UUID,MOUNTPOINT | grep "/media/ericvaish/" | awk '{print $2}' | head -n 1)

# Check if the SSD was found by checking the UUID
if [ -z "$DEVICE_UUID" ]; then
    echo "No SSD found."
    exit 1
fi

# Get the device corresponding to the UUID
DEVICE=$(blkid -U "$DEVICE_UUID")

# Check if blkid returned a valid device
if [ -z "$DEVICE" ]; then
    echo "Device not found for UUID $DEVICE_UUID."
    exit 1
fi

# Create the mount point if it does not exist
if [ ! -d "$MOUNT_POINT" ]; then
    mkdir -p "$MOUNT_POINT"
fi

# Check if the device is already mounted at the mount point
if ! mountpoint -q "$MOUNT_POINT"; then
    # Unmount the device if it's already mounted elsewhere
    sudo umount "$DEVICE" 2>/dev/null

    # Mount the device
    sudo mount "$DEVICE" "$MOUNT_POINT"
    echo "Mounted $DEVICE at $MOUNT_POINT"
else
    echo "$DEVICE is already mounted at $MOUNT_POINT"
fi

# Change permissions (if needed)
sudo chmod u+w "$MOUNT_POINT/Eric_V/Pothole_Recordings"

# Run Python scripts
cd /home/ericvaish/Pothole
sudo python fan.py &
sudo python record.py &
