# Pothole-Geo-Tagging
Software for our device which automatically provides geo tagged data along with images for all Potholes captured.

# Usage

sudo apt install libcap-dev
sudo apt install libcamera-dev

# Demo

[![Watch the video](http://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg)](https://youtu.be/xSB7NpzPcoU)

[![Watch the video](http://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg)](https://youtu.be/4v8xGmHocmw)

[![Watch the video](http://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg)](https://youtu.be/xzIqhlwG57M)

[![Watch the video](http://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg)](https://youtu.be/1VXNcupkF2w)


# Our Setup:

### 1. Recording
We are using a Camera, Raspberry Pi 5 and a GPS Module for this setup.
We are using a Pi Camera 3 Module which has a 12MP camera, the Raspberry Pi 5 has great recording capabilities which will help us record 120 FPS video at 1080p and even 4K. We keep a separate time synced log of the GPS data, which can later be integrated with the Camera Detection.

### 2. Logging GPS Data
We are using [GPS DEVICE]'s GPS Module to Log the GPS Location along with the Potholes. We record Geodetic Latitude and Longitude, which can also be processed into ECEF if required.

### 3. Storage
We are using  Sandisk 1TB SSD to record all the Camera recordings as well as the GPS Log.

### 4. Control
We have 2 buttons for turning the log on and off. The 'on' Button is connected to the Power Button of the Raspberry Pi 5, and the 'off' button is sampled through the python video recording script.

### 4. Model 
We are using 2 models, for different applications :
- We have fine tuned the YOLO model to detect and Segment Potholes. The model also gives a classification to the type of pothole found. It has various classes like - loose gravel, speed breaker, Circular Pothole, Uneven manhole cover etc.
- We are applying the above model over another Fine Tuned Model which segments the road area in the entire recording. This helps us avoid false positives and only detects potholes over the road surface.

### 5. Processing
Although the Raspberry Pi 5 is very capable of running real time inference using the new AI module, we have opted for a post processing approach to ensure stability, robustness and reliability.

### 6. Output
We provide all Potholes found in the survey, along with a number, score, and geo-tagged images of the Potholes. This process is automated by just installing our device on your car.

### 7. Scripts
    - Automatically Start Recording
    - Stoping the recording, saving it, and turning the Raspberry Pi off.
    - Starting the GPS Log, and saving it when the survey ends.

### 8. Considerations / Tests

1. Make sure time is getting updated(as the output video files save time as their name). We need to make sure time is getting updated to ensure no override of content. 
2. Turn on hotspot automatically when raspi reboots.Source : https://www.raspberrypi.com/tutorials/host-a-hotel-wifi-hotspot/
3. Make sure the recordings are getting saved in the SSD.

# Known Issues

## - Raspberry Pi OS Lite
1. Running the record2.py normally results in permission error.
2. Running the record2.py through crontab shell results in "No Such process" error.

## - Raspberry Pi OS
1. Running the record2.py through GUI works fine.
2. Running the shell script through GUI works fine.
3. Running the shell script through crontab after reboot results in "No Such process" error.

    Resources:
    1. https://forums.raspberrypi.com/viewtopic.php?t=361758

## - Ubuntu Server
1. Unable to install Picamera2 library.
- Followed the steps mentioned in the documentation of Picamera2, however multiple sudo apt installations showed 

    Resources:
    1. https://github.com/raspberrypi/picamera2/issues/563
    2. https://github.com/raspberrypi/picamera2/issues/383
    3. https://forums.raspberrypi.com/viewtopic.php?t=347172
    4. https://stackoverflow.com/questions/52394543/e-unable-to-locate-package-python3-pip
    


## Potential Source for Solution
- Github Issues Page on Picamera2
1. https://github.com/search?q=repo%3Araspberrypi%2Fpicamera2+crontab&type=issues

2. https://github.com/raspberrypi/picamera2/issues/816 (**)


