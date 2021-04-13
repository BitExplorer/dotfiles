#include <ESP8266WiFi.h>
/*
  Hardware
  ========
  ESP01 programmer (modified)
  to program ensure the connection
  unplug after programming
*/

void setup() {
  Serial.begin(115200);
  while (!Serial);
  pinMode(LED_BUILTIN, OUTPUT);
  WiFi.mode(WIFI_STA);
}

void loop() {
  Serial.println("Hello from Wemos d1 Mini");
  Serial.print("LED_BUILTIN: ");
  Serial.println(LED_BUILTIN);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}
