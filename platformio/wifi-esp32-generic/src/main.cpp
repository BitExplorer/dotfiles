#include <Arduino.h>
#include <WiFi.h>
#include <time.h>
#include <ArduinoJson.h>
#include "config.h"

/*
serial connection, programming mode
ESP32 | FTDI
============
VCC -> 3.3V
GND -> GND
IO0 -> GND
TXD -> TX (RX usually, but this board is wierd)
RXD -> RX (TX usually, but this board is wierd)

serial connection, regular mode
ESP32 | FTDI
============
VCC -> 3.3V
GND -> GND
TXD -> TX (RX usually, but this board is wierd)
RXD -> RX (TX usually, but this board is wierd)

1000uf cap to smooth the power between 3.3V and ground on the FTDI

GPIO18 = SCK
GPIO19 = MISO
GPIO23 = MOSI
GPIO5 = CS
VCC = 5V
GND = GND
 */

const char ntpServer[] = "pool.ntp.org";
const long gmtOffset = -21600; //Central time -6
const int daylightOffset = 3600;

void setup() {
  Serial.begin(115200);
  while (!Serial);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  configTime(gmtOffset, daylightOffset, ntpServer);
  struct tm timeinfo = {0};
  getLocalTime(&timeinfo);

  WiFi.mode(WIFI_STA);
  /* WiFi.mode(WIFI_OFF); */
  /* WiFi.disconnect(true); */
  delay(100);

  Serial.println("setup completed.");
}

String translateEncryptionType(wifi_auth_mode_t encryptionType) {
  switch (encryptionType) {
    case (0):
      return "Open";
    case (1):
      return "WEP";
    case (2):
      return "WPA_PSK";
    case (3):
      return "WPA2_PSK";
    case (4):
      return "WPA_WPA2_PSK";
    case (5):
      return "WPA2_ENTERPRISE";
    default:
      return "UNKOWN";
    }
}

void loop() {
  Serial.println(WiFi.localIP());
  delay(1000);
}
