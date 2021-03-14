/*
  ESP01 programmer (modified)
  to program ensure the connection
  unplug after programming
*/

void setup() {
  Serial.begin(9600);
  while (!Serial);
  pinMode(BUILTIN_LED, OUTPUT);
}

void loop() {
  Serial.println("Hello from ESP01");
  digitalWrite(BUILTIN_LED, HIGH);
  delay(1000);
  digitalWrite(BUILTIN_LED, LOW);
  delay(1000);
  Serial.println(millis() / 1000);
}