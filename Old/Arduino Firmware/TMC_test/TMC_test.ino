/*
  This is a test of the TMC2130 in standalone mode, functioning like a TMC2100.
*/

#define EN_PIN   7
#define DIR_PIN  9
#define STEP_PIN 8
#define CS_PIN   2

#define CFG1 12
#define CFG2 13

void setup() {
  pinMode(EN_PIN, OUTPUT);
  digitalWrite(EN_PIN, HIGH);
  
  pinMode(DIR_PIN, OUTPUT);
  pinMode(STEP_PIN, OUTPUT);
  pinMode(CFG1, OUTPUT);
  pinMode(CFG2, OUTPUT);

  digitalWrite(CFG1, LOW);
  digitalWrite(CFG2, LOW);
  
  digitalWrite(EN_PIN, LOW);
}

void loop() {
  static boolean dir = false;
  digitalWrite(DIR_PIN, dir);
  
  tStep(200*2);
  
  delay(1000);
  dir = !dir;
}

void tStep(int howMany){
  for(int i = 0; i < howMany; i ++){
    digitalWrite(STEP_PIN, HIGH);
    //delayMicroseconds(15);
    delayMicroseconds(50);
    digitalWrite(STEP_PIN, LOW);
    //delayMicroseconds(700);
    delayMicroseconds(1000);
  }
}
