/*
   NRF24L01(YL-105)   Arduino_ Uno    Arduino_Mega    Blue_Pill(stm32f01C)
  __________________________________________________________________________
  VCC        |       5v        |     5v        |     5v
  GND        |       GND       |     GND       |     GND
  CSN        |   Pin10 SPI/SS  | Pin10 SPI/SS  |     A4 NSS1 (PA4) 3.3v
  CE         |   Pin9          | Pin9          |     B0 digital (PB0) 3.3v
  SCK        |   Pin13         | Pin52         |     A5 SCK1   (PA5) 3.3v
  MISO       |   Pin11 (MOSI)  | Pin50         |     A7 MISI1  (PA7) 3.3v
  MOSI       |   Pin12 (MOS0)  | Pin51         |     A6 MOSO1  (PA6) 3.3v
*/

#include <SPI.h>
#include <RF24.h>

struct tempDataType {
    signed int temperature; // 2 bytes, -32,768 to 32,767, same as short
    unsigned maxTemp;       // 2 bytes, 0 to 65,535
    double humidity;        // 4 bytes 32-bit floating point (Due=8 bytes, 64-bit)
    float dewPoint;         // 4 bytes 32-bit floating point, same as double
    byte ID;                // 1 byte
    // Total 13, you can have max 32 bytes here
};

RF24 radio(7, 8); // using pin 7 for the CE pin, and pin 8 for the CSN pin

/* char receivedPayload[100] = {}; */
tempDataType myDataRx;

const uint64_t readerPipe = 0xE6E6E6E6E6E6;
const uint64_t writerPipe = 0xB3B4B5B601;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
  while (!Serial) {
    // some boards need to wait to ensure access to serial over USB
  }
  Serial.println("RF24 example receiver.");

  // initialize the transceiver on the SPI bus
  if (!radio.begin()) {
    Serial.println("Receiving radio hardware is not responding.");
    while (1) {
      Serial.println("hardware issues");
      delay(1000);
    } // hold in infinite loop
  }

  radio.setPALevel(RF24_PA_LOW);     // RF24_PA_MAX is default.

  // to use ACK payloads, we need to enable dynamic payload lengths (for all nodes)
  //radio.enableDynamicPayloads();    // ACK payloads are dynamically sized

  // Acknowledgement packets have no payloads by default. We need to enable
  // this feature for all nodes (TX & RX) to use ACK payloads.
  //radio.enableAckPayload();

  radio.openReadingPipe(1, readerPipe); // Get NRF24L01 ready to receive
  radio.openWritingPipe(writerPipe);
  /* radio.setPALevel(RF24_PA_MIN); */
  /* SPI.setClockDivider(SPI_CLOCK_DIV8) ; */
  radio.setAutoAck(true);
  radio.startListening(); // Listen to see if information received
  /* radio.printDetails(); */
}

void loop() {
  while (radio.available()) {
    radio.read(&myDataRx, sizeof(myDataRx));
    Serial.println("Receiving data ......");
    Serial.print("  PALevel (1 == RF24_PA_LOW): ");
    Serial.println(radio.getPALevel());
    Serial.print("  Channel: ");
    Serial.println(radio.getChannel());
    Serial.print("  ID         : ");
    Serial.println(myDataRx.ID);
    Serial.print("  Temperature: ");
    Serial.println(myDataRx.temperature);
    Serial.print("  Max Temp.  : ");
    Serial.println(myDataRx.maxTemp);
    Serial.print("  Humidity   : ");
    Serial.println(myDataRx.humidity);
    Serial.print("  Dew Point  : ");
    Serial.println(myDataRx.dewPoint);
    delay(10);
    radio.stopListening();

    if (!radio.write(&myDataRx, sizeof(myDataRx))) {
      Serial.println("  RX: No ACK");
    } else {
      Serial.println("  RX: ACK");
    }

    radio.startListening();
  }
}
