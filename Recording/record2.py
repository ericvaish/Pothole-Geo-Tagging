import time
import cv2
import csv
from datetime import datetime
from picamera2 import MappedArray, Picamera2
from picamera2.encoders import H264Encoder
from picamera2.outputs import FfmpegOutput
from gpiozero import Button
import gpiod
import os
import sys

BUTTON_GPIO = 23  # GPIO pin where the button is connected
LED_PIN = 16  # GPIO pin for the LED
DURATION = 70  # Duration in seconds for each recording segment (10 minutes)

# Initialize the GPIO chip and LED line
chip = gpiod.Chip('gpiochip4')
led_line = chip.get_line(LED_PIN)
led_line.request(consumer='LED', type=gpiod.LINE_REQ_DIR_OUT)

def create_directory(directory_path):
    if not os.path.exists(directory_path):
        os.makedirs(directory_path)

def log_timestamp_to_csv(timestamp, csv_output):
    with open(csv_output, mode='a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow([timestamp])

def stop_recording_and_shutdown(picam2):
    print("Stopping video recording...")
    picam2.stop_recording()
    print("Video recording stopped.")
    led_line.set_value(0)
    print("Shutting down...")
    os.system("sudo shutdown now")

def button_pressed():
    print("Button Pressed! Stopping recording and shutting down.")
    stop_recording_and_shutdown(picam2)
    sys.exit()

def camera_operation(output_directory):
    global picam2

    picam2 = Picamera2()

    def apply_timestamp(request):
        now = datetime.now()
        timestamp = now.strftime("%H:%M:%S.") + now.strftime("%f")[:3]
        log_timestamp_to_csv(timestamp, csv_output)
        with MappedArray(request, "main") as m:
            cv2.rectangle(m.array, (0, 0), (200, 30), (0, 0, 0), -1)
            cv2.putText(m.array, timestamp, (5, 22), cv2.FONT_HERSHEY_SIMPLEX, 2, (255, 255, 255), 1)

    picam2.pre_callback = apply_timestamp
    camera_config = picam2.create_video_configuration(
        main={"size": (1920, 1080), "format": "RGB888"},
        controls={"FrameRate": 80},
        buffer_count=6
    )

    picam2.configure(camera_config)
    encoder = H264Encoder(bitrate=10e6)

    button = Button(BUTTON_GPIO)
    button.when_pressed = button_pressed

    while True:
        now = time.strftime("%d_%m_%y__%H_%M_%S")
        folder_name = now
        folder_path = os.path.join(output_directory, folder_name)

        create_directory(folder_path)

        mkv_output = os.path.join(folder_path, f"video_{now}.mkv")
        csv_output = os.path.join(folder_path, f"timestamp_{now}.csv")

        with open(csv_output, mode='w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['Timestamp'])

        output = FfmpegOutput(mkv_output, ["-r", "70"])

        print(f"Starting video recording: {mkv_output}")
        led_line.set_value(1)

        picam2.start_recording(encoder, output)
        time.sleep(DURATION)

        print(f"Stopping video recording: {mkv_output}")
        picam2.stop_recording()

        led_line.set_value(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python record.py <output_directory>")
        sys.exit(1)

    output_directory = sys.argv[1]

    try:
        camera_operation(output_directory)
    except KeyboardInterrupt:
        print("Program interrupted by user. Exiting...")
        led_line.set_value(0)
        chip.close()
        sys.exit()
