#include <Arduino.h>
#include <LiquidCrystal_I2C.h>
#include <TinyWireM.h>
#include "config.h"

/*
I2C

PCF8574 | digispark
==================
SDA     | Pin PB0
SCL     | Pin PB2
5V      | 5V
GND     | GND

Note: no need for external power on the lcd display
*/

#define uploadTimestamp "2021-04-14 05:27:58"

int isPrime( int );

LiquidCrystal_I2C lcd(0x3f, 16, 2);
/* LiquidCrystal_I2C lcd(0x27, 16, 2); */

int idx = 0;

void setup() {
  TinyWireM.begin();
  /* Serial.begin(9600); */
  /* while (!Serial); */
  /* Serial.println("setup started..."); */
  /* pinMode(ledPin,OUTPUT); */
  lcd.init();
  delay(500);
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.clear();
  delay(2000);
  /* Serial.println("setup completed..."); */
}

void loop() {
  idx++;
  /* lcd.backlight(); */
  String message = String(idx);
  lcd.setCursor(0, 0);

  if( isPrime(idx) == 1 ) {
    message.concat(" is prime");
    lcd.clear();
    /* lcd.backlight(); */
    lcd.print(message);
    /* Serial.println(message); */
  } else {
    message.concat(" NOT prime");
    lcd.clear();
    lcd.print(message);
    /* Serial.println(message); */
  }
  /* lcd.noBacklight(); */
  /* digitalWrite(ledPin, HIGH); */
  delay(2000);
  /* digitalWrite(ledPin, LOW); */
  delay(2000);
}

int isPrime(int number) {
  int idx;
  for (idx=2; idx<number; idx++) {
    if (number % idx == 0 && idx != number) {
      return 0;
    }
  }
  return 1;
}
