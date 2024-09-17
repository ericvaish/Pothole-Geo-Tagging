# Pothole-Geo-Tagging
Software for our device which automatically provides geo tagged data along with images for all Potholes captured.

# Our Setup:

### 1. Recording
We are using a Camera, Raspberry Pi 5 and a GPS Module for this setup.
We are using a Pi Camera 3 Module which has a 12MP camera, the Raspberry Pi 5 has great recording capabilities which will help us record 120 FPS video at 1080p and even 4K. We keep a separate time synced log of the GPS data, which can later be integrated with the Camera Detection.

### 2. Model 
We have fine tuned the YOLO model to detect and Segment Potholes. The model also gives a classification to the type of pothole found. It has various classes like - loose gravel, speed breaker, Circular Pothole, Uneven manhole cover etc.

### 3. Processing
Although the Raspberry Pi 5 is very capable of running real time inference using the new AI module, we have opted for a post processing approach to ensure stability, robustness and reliability.

### 4. Output
We provide all Potholes found in the survey, along with a number, score, and geo-tagged images of the Potholes. This process is automated by just installing our device on your car.



### 5. Scripts
    - Automatically Start Recording
    - Stoping the recording, saving it, and turning the Raspberry Pi off.
    - Starting the GPS Log, and saving it when the survey ends.



### 6. Considerations / Tests

1. Make sure time is getting updated(as the output video files save time as their name). We need to make sure time is getting updated to ensure no override of content. 
2. Turn on hotspot automatically when raspi reboots. Source : https://www.raspberrypi.com/tutorials/host-a-hotel-wifi-hotspot/
3. Make sure the recordings are getting saved in the SSD.
