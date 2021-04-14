#include <Arduino.h>

/*
 Programming

 Arduino | attiny85
 ==================
 5V            | 5V
 GND           | GND
 Pin 13 (SCK)  | Pin 2
 Pin 12 (MISO) | Pin 1
 Pin 11 (MOSI) | Pin 0
 Pin 10 (SS)   | Reset

 LED from ground to pin 0
 load arduino programmer software on the arduino
note: 10uF cap, negative to ground and positive to reset on the arduino


0.1uF ceramic cap between vcc and gnd of the tiny 85 It is required for proper operation.


for serial monitor
 FTDI | attiny85
 ================
 5V   | VCC
 GND  | GND
 RX   | PB2
 */

#define uploadTimestamp "2021-04-14 05:27:58"
#define DEBUG 1

void setup() {
  Serial.begin(9600);
  while( !Serial);
#ifdef DEBUG
  Serial.print("upload timestamp: ");
  Serial.println(uploadTimestamp);
  Serial.println("setup started...");
#endif

  pinMode(1, OUTPUT);
  delay(1000);
  #ifdef DEBUG
  Serial.println("setup completed...");
#endif
}

void loop() {
  Serial.println("Hello from attiny85");
  digitalWrite(1, HIGH);
  delay(1000);
  digitalWrite(1, LOW);
  delay(1000);
}
