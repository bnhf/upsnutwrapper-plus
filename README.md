# upsnutwrapper-plus - This Docker implementation of upsnutwrapper is oriented towards use with Portainer via a Docker Compose YAML

Installation can typically be done using only env vars. The excellent original work by Martin Lang has been refactored, optimized, with variable rationalization. It's been enhanced to include multiple parameter additions and overrides for compatibility with popular NUT-based tools like nut-cgi-plus, WinNUT and PeaNUT.

upsnutwrapper is designed to work with apcupsd, and present a NUT-compatible server on an alternate port (typically 3493). This allows users to run both an apcupsd server (typically on 3551), and a NUT server simultaneously for the same UPS.

Here's an example showing one UPS running NUT server natively, and six others running upsnutwrapper-plus:

<img width="1348" height="303" alt="screencapture-raspberrypi5-2025-08-30-06_38_15-edit" src="https://github.com/user-attachments/assets/bec430e4-ba80-4444-bb6f-910141232e15" />

And the same in PeaNUT:

<img width="1685" height="836" alt="screenshot-raspberrypi5-2025-08-22-07-46-22" src="https://github.com/user-attachments/assets/9ea9ff36-4c81-40c5-b8f1-7817b5e5ea38" />

WinNUT:

<img width="706" height="413" alt="Screenshot 2025-08-18 150504" src="https://github.com/user-attachments/assets/6392e026-bafd-4708-a8a7-b0326cf61177" />

The YAML below is intended to be self-documenting, and typically requires no editing. The Environment variables section of Portainer should be used for all of your installation-specific values:
```yaml
services:
  upsnutwrapper-plus: # This docker-compose typically requires no editing. Use the Environment variables section of Portainer to set your values.
    # 2025.08.19
    # GitHub home for this project: https://github.com/bnhf/upsnutwrapper-plus.
    # Docker container home for this project with setup instructions: https://hub.docker.com/r/bnhf/upsnutwrapper-plus.
    image: bnhf/upsnutwrapper-plus:${TAG:-latest} # Add the tag like latest or test to the environment variables below. 
    container_name: upsnutwrapper-plus
    hostname: ${HOSTNAME} # Required. A hostname to use for your Docker container to help identify the system to which your UPS is attached.
    ports:
      - ${HOST_PORT:-3493}:3493 # Use the standard NUT port number of 3493, or optionally change it, if it's in use on your Docker host. Default=3493.
    environment: # This Docker compose is best used with Portainer. Any env vars you'd like to change should be added in the Environment variables section of the Portainer-Stacks editor.
      - APCUPSD_SERVER=${APCUPSD_SERVER:-localhost} # Set the hostname or IP to reach your apcupsd server. Add port if not 3551 in the form hostname:port or ip:port. Default=localhost.
      - UPS_NAMES=${UPSNAME} # Required. Set a name for the UPS (1 to 8 chars) that will be used by System Tray notifications, nut-cgi and Grafana dashboards.
      - BATTERY_DATE=${BATTERY_DATE} # If you can't update the battery installation date in your UPS, you can override it here. In the form YYYY/MM/DD.
      - BATTERY_TYPE=${BATTERY_TYPE:-PbAc} # Set this to match your UPS battery type. Li-ion=Lithium-ion, PbAc=Lead Acid. Default=PbAc.
      - DEVICE_DESCRIPTION=${DEVICE_DESCRIPTION:-UPS NUT Apcupsd Wrapper}
      - INPUT_FREQUENCY_NOMINAL=${INPUT_FREQUENCY_NOMINAL:-50} # Set this to match your local nominal line frequency. 50=50Hz, 60=60Hz. Default=50.
      - INPUT_SENSITIVITY=${INPUT_SENSITIVITY:-low} # Set this to match the input sensitivity in use on your UPS. Typically low, medium or high. Default=low.
      - INPUT_TRANSFER_HIGH=${INPUT_TRANSFER_HIGH:-285} # Set this to match the high voltage transfer value for the sensitivity selected. Default=285.
      - INPUT_TRANSFER_LOW=${INPUT_TRANSFER_LOW:-196} # Set this to match the low voltage transfer value for the sensitivity selected. Default=196.
      - INPUT_VOLTAGE_NOMINAL=${INPUT_VOLTAGE_NOMINAL:-240} # Set this to match your local nominal line voltage. 240=240V, 120=120V. Default=240.
      - INPUT_POWER_SUPPORTED=${INPUT_POWER_SUPPORTED:-true} # Set this to false if apcupsd does not report your UPS input power voltage. Default=true.
      - OUTPUT_POWER_SUPPORTED=${OUTPUT_POWER_SUPPORTED:-true} # Set this to false if apcupsd does not report your UPS output power voltage. Default=true.
      - UPS_BEEPER_STATUS=${UPS_BEEPER_STATUS:-enabled} # Set this to disabled if you've turned off your UPS beeper (alarm).
      - LOGGING=${LOGGING:-true} # Docker users should leave this set to true. Standalone script users should generally set this to false. Default=true.
      - DEBUG=${DEBUG:-false} # When set to true Bash debugging will be sent to a file, /tmp/upsnutwrapper.debug. Set to true only for short-term debugging. Default=false.
    restart: unless-stopped
```
And here's a set of sample env vars, which can be copy-and-pasted into Portainer in Advanced mode. In that mode, it's quick-and-easy to modify those values for your use. Refer to the comments in the compose for clarification on how a given variable is used:
```yaml
TAG=latest
HOSTNAME=RPi6_nut
HOST_PORT=3493
APCUPSD_SERVER=RaspberryPi6
UPSNAME=Loft
BATTERY_DATE=
BATTERY_TYPE=PbAc
DEVICE_DESCRIPTION=UPS NUT Apcupsd Wrapper
INPUT_FREQUENCY_NOMINAL=60
INPUT_SENSITIVITY=Low
INPUT_TRANSFER_HIGH=150
INPUT_TRANSFER_LOW=78
INPUT_VOLTAGE_NOMINAL=120
INPUT_POWER_SUPPORTED=true
OUTPUT_POWER_SUPPORTED=false
UPS_BEEPER_STATUS=disabled
LOGGING=true
DEBUG=false
```
