/**
 * Author Teemu Mäntykallio
 * Initializes the library and turns the motor in alternating directions.

 Slightly modified for my test from the TMC2130Stepper library examples.
*/

#define EN_PIN    7  // Nano v3:	16 Mega:	38	//enable (CFG6)
#define DIR_PIN   9  //			19			55	//direction
#define STEP_PIN  8  //			18			54	//step
#define CS_PIN    2   //			17			64	//chip select

bool dir = true;

#include <TMC2130Stepper.h>
TMC2130Stepper driver = TMC2130Stepper(EN_PIN, DIR_PIN, STEP_PIN, CS_PIN);

void setup() {
	Serial.begin(9600);
	while(!Serial);
	Serial.println("Start...");
	SPI.begin();
	//pinMode(MISO, INPUT_PULLUP);
	driver.begin(); 			// Initiate pins and registeries
	driver.rms_current(900); 	// Set stepper current to 600mA. The command is the same as command TMC2130.setCurrent(600, 0.11, 0.5);
	driver.stealthChop(1); 	// Enable extremely quiet stepping
  driver.microsteps(0);
  driver.interpolate(1);
	
	digitalWrite(EN_PIN, LOW);
}

void loop() {
  static float acc = 5;
  static float acc_amount = .005;
  static boolean up = true;
  static int upTimer = 0;
	digitalWrite(STEP_PIN, HIGH);
	delayMicroseconds(10);
	digitalWrite(STEP_PIN, LOW);
	delayMicroseconds((int) (1200.0 * acc));

  if(upTimer - (int)millis() <= 0){
    if(up && acc > 1){
      acc -= acc_amount;
    } else if(!up && acc < 5){
      acc += acc_amount;
    } else{
      upTimer = millis() + 1500;
      up = !up;
    }
  }
}
