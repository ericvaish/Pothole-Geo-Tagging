# This code is working perfectly. The code activated the relay and fan turns on each time. No changes required here.

import gpiod

RELAY_PIN = 14  # GPIO pin number connected to the relay

# Open GPIO chip
chip = gpiod.Chip('gpiochip4')

# Get the GPIO line for the relay
relay_line = chip.get_line(RELAY_PIN)

# Request exclusive access to the line and configure it as an output
relay_line.request(consumer="Relay", type=gpiod.LINE_REQ_DIR_OUT)

try:
    # Turn on the relay (which activates the fan)
    relay_line.set_value(1)  # Set to low to activate the relay (NC configuration)
    print("Relay is ON. Fan is activated.")

    # Keep the program running to maintain the relay state
    input("Press Enter to exit and keep the fan running...")

finally:
    # Release the GPIO line and clean up resources on program exit
    relay_line.release()
    chip.close()
