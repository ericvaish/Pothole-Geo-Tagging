# This is the min requirement. However encountering isue while recording, due to insufficient permission assigned to the External SSD.
cd /
sudo chmod u+w /media/ericvaish/Pothole_SSD/Eric_V/Pothole_Recordings
sudo chmod 777 /dev/sda2
sudo chmod +x /dev/sda2
cd home/ericvaish/Pothole
sudo python fan.py &
sudo python record.py &
cd /
