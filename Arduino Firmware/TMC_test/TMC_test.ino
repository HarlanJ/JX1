#include <TMC2130Stepper.h>
#include <TMC2130Stepper_REGDEFS.h>
#include <TMC2130Stepper_UTILITY.h>

#define EN_PIN   7
#define DIR_PIN  9
#define STEP_PIN 8
#define CS_PIN   7

TMC2130Stepper TMC2130 = TMC2130Stepper(EN_PIN, DIR_PIN, STEP_PIN, CS_PIN);

void setup() {
  TMC2130.begin();
  TMC2130.SilentStepStick2130(600);
  TMC2130.stealthChop(1);

  digitalWrite(EN_PIN, LOW);
}

void loop() {
  static bool dir = false;
  static int last = 0;

  if(millis() - last >= 1000){
    dir = !dir;
    TMC2130.shaft_dir(dir);
  }
  
  digitalWrite(STEP_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(STEP_PIN, LOW);
  delayMicroseconds(250);
}