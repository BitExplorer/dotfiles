//Interfacing ESP8266 Wi-Fi with STM32F103C8
/*
FTDI | stm32f103
RX   | TX1 (PC9)
TX   | RX1 (PC10)
GND  | GND
3.3V | 3.3V

stm32f103 | ESP01
GND       | GND
3.3V      | 3.3V
3.3V      | CH-PD
PC3 (RX2) | TX
PC2 (TX2) | RX

1000uF capacitor between power and ground (to prevent power issues)

Connect to DHT22 to 3.3V or 5V rail and Pin PA1 of the stm32f103

*/

#include <DHT.h>
#include <ArduinoJson.h>

#define DEBUG 1

DHT dht(PA1, DHT22);

char incomingByte = 0;
char message[100] = {0};
char temperatureHumidityString[20] = {0};
char temperatureString[10] = {0};
char humidityString[10] = {0};
int idx = 0;
int serialWaitCounrt = 0;


String readInput() {
  String inData = "";
  while (Serial.available() > 0) {
    char received = Serial.read();
    inData += received;

        // Process message when new line character is received
    if (received == '\n') {
      Serial.print("Received data from esp01: ");
      inData.trim();
      Serial.println(inData);

      if( strncmp(message, "start", 5) == 0 ) {
        Serial2.println(temperatureHumidityString);
      }

      return inData;
    }
  }
}

void setup() {
  Serial.begin(9600);
  while (!Serial);
#ifdef DEBUG
  Serial.println("setup stm32f103 started...");
#endif
  Serial2.begin(9600);   //begins serial communication with esp8266 with baud rate 9600 (Change according to your esp8266 module)
  while (!Serial2);
  dht.begin();
  delay(3000);          // Wait 3 seconds for it to stabilize the dht22
#ifdef DEBUG
  Serial.println("setup stm32f103 completed...");
#endif
}

void loop() {
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature(true);

  if (isnan(humidity) || isnan(temperature)) {
#ifdef DEBUG
    Serial.println("Failed to read from DHT sensor!");
#endif
    return;
  }

  StaticJsonDocument<100> jsonStructure;
  jsonStructure["location"] = "garage";
  jsonStructure["timestamp"] = "empty";
  jsonStructure["temperature"] = temperature;
  jsonStructure["humidity"] = humidity;

  String payload;
  serializeJson(jsonStructure, payload);
  Serial.print("Payload: ");
  Serial.println(payload);
  delay(5000);

  if ( Serial2.available() ) {
      Serial2.println(payload);
      return;
  }
  /* serialWaitCounrt++; */
  /* if( serialWaitCounrt > 1000 ) { */
  /*   Serial.println("Waiting for ESP01 [Serial2] to produce data."); */
  /*   serialWaitCounrt = 0; */
  /* } */
}
