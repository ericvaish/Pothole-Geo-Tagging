# Updated shell script by GPT-4o. Creating defined mount points. Stil encountering same issue with this script.
#!/bin/bash

# Define mount point and device (use a variable for device name)
MOUNT_POINT="/home/ericvaish/Pothole_SSD"
DEVICE=$(lsblk -o NAME,MOUNTPOINT | grep "/media/ericvaish/" | awk '{print $1}' | head -n 1)

# Check if the device is connected
if [ -z "$DEVICE" ]; then
    echo "No SSD found. Please connect the SSD and try again."
    exit 1
fi

DEVICE="/dev/$DEVICE"

# Create the mount point if it does not exist
if [ ! -d "$MOUNT_POINT" ]; then
    mkdir -p "$MOUNT_POINT"
fi

# Check if the device is already mounted
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
