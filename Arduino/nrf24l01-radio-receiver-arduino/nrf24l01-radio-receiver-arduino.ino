/*
  YL-105 Breakoutboard to Arduino
  GND -> GND
  VCC -> 5v
  CE -> pin 7
  CS -> pin 8
  SCK -> pin 13
  MISO -> pin 12
  MOSI -> pin 11
*/

#include <SPI.h>
#include <RF24.h>

RF24 radio(7, 8); // using pin 7 for the CE pin, and pin 8 for the CSN pin

int ReceivedMessage[1] = {0}; // Used to store value received by the NRF24L01

const uint64_t pipe = 0xE6E6E6E6E6E6; // Needs to be the same for communicating between 2 NRF24L01
char buffer[50] = {0};
int length = 0;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
  while (!Serial) {
    // some boards need to wait to ensure access to serial over USB
  }

  // initialize the transceiver on the SPI bus
  if (!radio.begin()) {
    Serial.println(F("Receiving radio hardware is not responding."));
    while (1) {} // hold in infinite loop
  }

  Serial.println(F("RF24 example receiver."));
  radio.openReadingPipe(1, pipe); // Get NRF24L01 ready to receive
  /* radio.setPALevel(RF24_PA_MIN); */
  /* SPI.setClockDivider(SPI_CLOCK_DIV8) ; */
  radio.startListening(); // Listen to see if information received
}

/*
void loop(){
bool done=false;
if(radio.available()){
  while(!done){
    radio.read(ReceivedMessage, 1);

    if(ReceivedMessage==111) {
      Serial.println(F("Got message"));
    }
    done = true;
    delay(1000);
  }
} else {
  Serial.println("No Radio Available");
}
}
*/


void loop() {
  while (radio.available()) {
    Serial.println("radio is available");
    length = radio.getDynamicPayloadSize();  //# or radio.getPayloadSize() for static payload sizes¬
    //received_payload = radio.read(length)
    radio.read(ReceivedMessage, sizeof(int));
    sprintf(buffer, "received message = '%d'", ReceivedMessage[0]);
    Serial.println(buffer);
    delay(1000);
  }
}
