#define FASTLED_ESP8266_RAW_PIN_ORDER
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <FastLED.h>
#include <FirebaseESP8266.h>

#define LED_TYPE WS2812B
#define COLOR_ORDER GRB
#define LED_PIN D4
#define NUM_LEDS 300

#define WIFI_SSID "" // WiFi network name
#define WIFI_PASSWORD "" // WiFi network password

#define FIREBASE_HOST "dtiapp-team10-default-rtdb.asia-southeast1.firebasedatabase.app"
#define FIREBASE_AUTH "" // Firebase secret key

FirebaseData fbdo_status;
FirebaseData fbdo_color;
FirebaseData fbdo_pattern;

CRGB leds[NUM_LEDS];

// Define variables
int led_status = 0; // 0 for off, 1 for on
String led_color = "Cool"; // Blue
String led_pattern = "None";
int current_status = 0;
String current_color = "Cool"; // Blue
String current_pattern = "None";
int hue = 0;

void setup() {
  
  Serial.begin(115200);
  delay(10);

  // Set up WiFi connection
  Serial.print("Connecting to ");
  Serial.println(WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println("WiFi connected");

  // Set up Firebase connection
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Serial.println("Firebase connected");

  // Set up LED connection
  FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS);

}

// Default pattern
void led_no_pattern(int r, int g, int b) {
  Serial.println("Running no pattern logic");
  for (int i = NUM_LEDS - 1; i >= 0; i--) {
    leds[i] = CRGB(r,g,b);
    FastLED.show();
    delay(10);
  }
}

// LEDs will fade in and out
void led_fade_pattern(int red, int green, int blue) {
  Serial.println("Running fade pattern logic");
  float r, g, b;
  
  // FADE IN
  for(int i = 0; i <= 255; i++) {
    r = (i/256.0)*red;
    g = (i/256.0)*green;
    b = (i/256.0)*blue;
    fill_solid(leds, NUM_LEDS, CRGB(r,g,b));
    FastLED.show();
    delay(2);
  }

  // FADE OUT
  for(int i = 255; i >= 0; i--) {
    r = (i/256.0)*red;
    g = (i/256.0)*green;
    b = (i/256.0)*blue;
    fill_solid(leds, NUM_LEDS, CRGB(r,g,b));
    FastLED.show();
    delay(2);
  }
  
  delay(200);
}

// Update LED colors and patterns
void update_leds(int changed_status, String changed_color, String changed_pattern) {

  // If lights are not toggled on
  if (changed_status == 0) {
    for (int i = NUM_LEDS - 1; i >= 0; i--) {
      leds[i] = CRGB(0, 0, 0);
      FastLED.show();
      delay(10);
    }
  }

  // If lights are toggled on
  else if (changed_status == 1) {
    
    if (changed_color == "Passion") {
      if (changed_pattern == "None") {
        led_no_pattern(255,0,0);
      }
      else if (changed_pattern == "Fade") {
        led_fade_pattern(255,0,0);
      }
    }
    
    else if (changed_color == "Sunrise") {
      if (changed_pattern == "None") {
        led_no_pattern(255,128,0);
      }
      else if (changed_pattern == "Fade") {
        led_fade_pattern(255,128,0);
      }
    }
    
    else if (changed_color == "Sunset") {
      if (changed_pattern == "None") {
        led_no_pattern(255,255,0);
      }
      else if (changed_pattern == "Fade") {
        led_fade_pattern(255,255,0);
      }
    }
    
    else if (changed_color == "Nature") {
      if (changed_pattern == "None") {
        led_no_pattern(0,255,0);
      }
      else if (changed_pattern == "Fade") {
        led_fade_pattern(0,255,0);
      }
    }
    
    else if (changed_color == "Cool") {
      if (changed_pattern == "None") {
        led_no_pattern(0,0,255);
      }
      else if (changed_pattern == "Fade") {
        led_fade_pattern(0,0,255);
      }
    }
    
    else if (changed_color == "Punky") {
      if (changed_pattern == "None") {
        led_no_pattern(128,0,255);
      }
      else if (changed_pattern == "Fade") {
        led_fade_pattern(128,0,255);
      }
    }
    
    else if (changed_color == "Coral") {
      if (changed_pattern == "None") {
        led_no_pattern(255,10,255);
      }
      else if (changed_pattern == "Fade") {
        led_fade_pattern(255,10,255);
      }
    }
    
    else if (changed_color == "Fission") {
      if (changed_pattern == "None") {
        led_no_pattern(255,200,0);
      }
      else if (changed_pattern == "Fade") {
        led_fade_pattern(255,200,0);
      }
    }
    
    else if (changed_color == "Rainbow") {
      if (changed_pattern == "None") {
        for (int i = 299; i >= 0; i++) {
          fill_rainbow(leds, 300, 112);
          FastLED.show();
        }
      }
      else if (changed_pattern == "Fade") {
        // Fade animation through all the colors, cannot be interrupted
        led_fade_pattern(255,0,0);
        led_fade_pattern(255,128,0);
        led_fade_pattern(255,255,0);
        led_fade_pattern(0,255,0);
        led_fade_pattern(0,0,255);
        led_fade_pattern(128,0,255);
        led_fade_pattern(255,128,128);
      }
    }
    
  }
  
}

void loop() {

  if (Firebase.ready()) {
    Firebase.getInt(fbdo_status, "/DOME1/LED_STATUS/value");
    Firebase.getString(fbdo_color, "/DOME1/LED_COLOR_PRESET/color");
    Firebase.getString(fbdo_pattern, "/DOME1/LED_PATTERN_PRESET/pattern");
    
    // Check if current value is same as previous value, if not, update new value
    if (fbdo_status.to<int>() != current_status) {
      current_status = fbdo_status.to<int>();
    }
    
    if ((fbdo_color.to<String>() != current_color) && (fbdo_pattern.to<String>() != current_pattern)) {
      current_color = fbdo_color.to<String>();
      current_pattern = fbdo_pattern.to<String>();
    }
    
    else if ((fbdo_color.to<String>() == current_color) && (fbdo_pattern.to<String>() != current_pattern)) {
      current_pattern = fbdo_pattern.to<String>();
    }
    
    else if ((fbdo_color.to<String>() != current_color) && (fbdo_pattern.to<String>() == current_pattern)) {
      current_color = fbdo_color.to<String>();
    } 

    update_leds(current_status, current_color, current_pattern);
  }
  
}
