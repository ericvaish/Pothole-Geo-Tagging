#!/bin/bash

# Define mount point
MOUNT_POINT="/home/ericvaish/Pothole_SSD"

# Debug: Print current state of devices
echo "Listing current block devices:"
lsblk

# Get the UUID of the SSD by checking its mount point (assuming it appears under /media/ericvaish/)
DEVICE_UUID=$(lsblk -o NAME,UUID,MOUNTPOINT | grep "/media/ericvaish/" | awk '{print $2}' | head -n 1)

# Debug: Print the found UUID
echo "Detected UUID: $DEVICE_UUID"

# Check if the SSD was found by checking the UUID
if [ -z "$DEVICE_UUID" ]; then
    echo "No SSD found. Please connect the SSD and try again."
    exit 1
fi

# Get the device corresponding to the UUID
DEVICE=$(blkid -U "$DEVICE_UUID")

# Debug: Print the found device
echo "Device corresponding to UUID: $DEVICE"

# Check if blkid returned a valid device
if [ -z "$DEVICE" ]; then
    echo "Device not found for UUID $DEVICE_UUID."
    exit 1
fi

# Create mount point if none
if [ ! -d "$MOUNT_POINT" ]; then
    echo "Creating mount point $MOUNT_POINT"
    mkdir -p "$MOUNT_POINT"
fi

# Check if the device is already mounted at the mount point
if ! mountpoint -q "$MOUNT_POINT"; then
    # Unmount the device if it's already mounted elsewhere
    echo "Unmounting $DEVICE from other mount points, if any"
    sudo umount "$DEVICE" 2>/dev/null

    # Mount the device
    echo "Mounting $DEVICE at $MOUNT_POINT"
    sudo mount "$DEVICE" "$MOUNT_POINT"

    if [ $? -eq 0 ]; then
        echo "Successfully mounted $DEVICE at $MOUNT_POINT"
    else
        echo "Failed to mount $DEVICE at $MOUNT_POINT"
        exit 1
    fi
else
    echo "$DEVICE is already mounted at $MOUNT_POINT"
fi

# Change permissions (if needed)
echo "Changing permissions for $MOUNT_POINT/Eric_V/Pothole_Recordings"
sudo chmod u+w "$MOUNT_POINT/Eric_V/Pothole_Recordings"

# check python if scripts exist
if [ ! -f /home/ericvaish/Pothole/fan.py ]; then
    echo "fan.py not found in /home/ericvaish/Pothole"
    exit 1
fi

if [ ! -f /home/ericvaish/Pothole/record.py ]; then
    echo "record.py not found in /home/ericvaish/Pothole"
    exit 1
fi

# Run Python scripts
cd /home/ericvaish/Pothole || { echo "Failed to change directory to /home/ericvaish/Pothole"; exit 1; }
echo "Starting Python scripts"
sudo python fan.py &
sudo python record.py &

echo "Scripts running in the background"

