/*
   git@github.com:jaretburkett/RF24-STM.git

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
//#include <RF24.h>
#include <RF24-STM.h>

struct tempDataType {
    signed int temperature; // 2 bytes, -32,768 to 32,767, same as short
    unsigned maxTemp;       // 2 bytes, 0 to 65,535
    float humidity;        // 4 bytes 32-bit floating point (Due=8 bytes, 64-bit)
    float dewPoint;         // 4 bytes 32-bit floating point, same as double
    byte ID;                // 1 byte
    // Total 13, you can have max 32 bytes here
};

// instantiate an object for the nRF24L01 transceiver
RF24 radio(PB0, PA4); // using pin PB0 for the CE pin, and pin PA4 for the CSN pin

tempDataType myDataTx;

const uint64_t writePipe = 0xE6E6E6E6E6E6;
const uint64_t readPipe = 0xB3B4B5B601;

void setup() {
  pinMode(PC13, OUTPUT);
  Serial.begin(9600);
  while (!Serial) {
    // some boards need to wait to ensure access to serial over USB
  }
  Serial.println("RF24 example transmitter.");

  // initialize the transceiver on the SPI bus
  /* if ( !radio.begin() ) { */
  /*   Serial.println(F("Transmitting radio hardware is not responding.")); */
  /*   while (1) {} // hold in infinite loop */
  /* } */
  radio.begin();
  delay(500);

  // Use a channel unlikely to be used by Wifi, Microwave ovens etc
  radio.setChannel(76);
  // Give receiver a chance
  radio.setRetries(200, 50);

  radio.setAutoAck(true);
  radio.setPALevel(RF24_PA_LOW);     // RF24_PA_MAX is default.
  radio.openReadingPipe(1, readPipe);
  radio.openWritingPipe(writePipe); // Get NRF24L01 ready to transmit
}

void loop() {
    radio.stopListening();
    myDataTx.ID = 'B';
    myDataTx.temperature = 73;
    myDataTx.maxTemp = 93;
    myDataTx.humidity = 50.37;
    myDataTx.dewPoint = 69.4;
   if( !radio.write(&myDataTx, sizeof(myDataTx)) ) {
     /* radio.printDetails(); */
     Serial.println("radio write failed, the receiver is not online or responding.");
     Serial.print("  PALevel (1 == RF24_PA_LOW): ");
     Serial.println(radio.getPALevel());
     Serial.print("  DataRate: ");
     Serial.println(radio.getDataRate());
     radio.print_status(radio.get_status());
     /* Serial.print("  Status: "); */
     /* Serial.println(radio.get_status()); */
   } else {
     Serial.println("Transmitting data below......");
     radio.printDetails();
     radio.print_status(radio.get_status());
     Serial.print("  PALevel (1 == RF24_PA_LOW): ");
     Serial.println(radio.getPALevel());
     /* Serial.print("  Channel: "); */
     /* Serial.println(radio.getChannel()); */
     Serial.print("  ID         : ");
     Serial.println(myDataTx.ID);
     Serial.print("  Temperature: ");
     Serial.println(myDataTx.temperature);
     Serial.print("  Max Temp.  : ");
     Serial.println(myDataTx.maxTemp);
     Serial.print("  Humidity   : ");
     Serial.println(myDataTx.humidity);
     Serial.print("  Dew Point  : ");
     Serial.println(myDataTx.dewPoint);
     Serial.print("  sizeof(double): ");
     Serial.println(sizeof(double));
     Serial.print("  sizeof(float): ");
     Serial.println(sizeof(float));
     Serial.print("  sizeof(byte): ");
     Serial.println(sizeof(byte));
     Serial.print("  sizeof(signed int): ");
     Serial.println(sizeof(signed int));
   }
  /* delay(250); */
  /* digitalWrite(LED_BUILTIN, (millis() / 1000) % 2); */

      // Now listen for a response
    radio.startListening();

    // But we won't listen for long
    unsigned long started_waiting_at = millis();

    // Loop here until we get indication that some data is ready for us to read (or we time out)
    while (!radio.available()) {
        // Oh dear, no response received within our timescale
        if (millis() - started_waiting_at > 1000) {
            Serial.print("  TX: Got no reply ");
            delay(2000);
            return;
        }
    }
    radio.read(&myDataTx, sizeof(myDataTx));
    delay(250);
}
