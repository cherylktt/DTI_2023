# ESP8266 Code

Code written for Firebase integration with ESP8266 NodeMCU V3 WiFi Module and WS2812B LED light strips

## Setting up ESP8266 board
1. In Arduino IDE, go to File > Preferences and key in `http://arduino.esp8266.com/stable/package_esp8266com_index.json` into the “Additional Boards Manager URLs” field.
2. Go to Tools > Boards > Boards Manager, search for ESP8266 and press install button for the “esp8266 by ESP8266 Community" board.
Board chosen to upload code: NodeMCU 1.0 (ESP-12E Module)

## Libraries used
The code uses the following libraries:
1. ESP8266Wifi
2. FirebaseESP8266 by Mobizt (Version 4.3.9) 
3. FastLED by Daniel Garcia (Version 3.5.0)
