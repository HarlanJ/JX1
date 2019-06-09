#include "SPI.h"
#include "ShiftRegister.h"
#include "DriverControl.h"

//    Driver registers
#define WRITE_FLAG        (1<<7) //write flag
#define READ_FLAG         (0<<7) //read flag
#define REG_GCONF         0x00
#define REG_GSTAT         0x01
#define REG_IHOLD_IRUN    0x10
#define REG_CHOPCONF      0x6C
#define REG_COOLCONF      0x6D
#define REG_DCCTRL        0x6E
#define REG_DRVSTATUS     0x6F

//    SPI
#define MOSI_PIN 11 //SDI/MOSI (ICSP: 4, Uno: 11, Mega: 51)
#define MISO_PIN 12 //SDO/MISO (ICSP: 1, Uno: 12, Mega: 50)
#define SCK_PIN  13 //CLK/SCK  (ICSP: 3, Uno: 13, Mega: 52)

//    Driver Aliases
#define xDriver drivers[0]
#define yDriver drivers[1]
#define zDriver drivers[2]
#define eDriver drivers[3]

//    --END OF DEFINES--

ShiftRegister sReg(16, 5, 8, 9, 7);

//DriverControl xDriver, yDriver, zDriver, eDriver;
DriverControl drivers[4];

struct RegisterSettings{
  uint8_t reg;
  uint32_t value;
};

//Set up the global SPI pins for IO.
void setupSPI() {
    pinMode(MOSI_PIN, OUTPUT);
    digitalWrite(MOSI_PIN, LOW);
    pinMode(MISO_PIN, INPUT);
    digitalWrite(MISO_PIN, HIGH);
    pinMode(SCK_PIN, OUTPUT);
    digitalWrite(SCK_PIN, LOW);
}

void setup(){
  setupSPI();
  SPI.begin();
  SPI.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE3));

  //Settings for xyz(e) stepper drivers
  RegisterSettings gconf;
  gconf.reg = WRITE_FLAG|REG_GCONF;
  gconf.value = 0x00000005UL;

  RegisterSettings iHold_iRun;
  iHold_iRun.reg = WRITE_FLAG|REG_IHOLD_IRUN;
  iHold_iRun.value = 0x00001010UL;

  RegisterSettings chopConf;
  chopConf.reg = WRITE_FLAG|REG_CHOPCONF;
  chopConf.value = 0x08008008UL;


  //prepare stepper drivers
  for(int i = 0; i < 4; i ++){
    // cs, en, step, dir
    uint8_t offset = i*4;
    //Set pinsIds and shift register
    drivers[i] = DriverControl(&sReg, offset + 2, offset + 3, offset + 1, offset);

    //Set up registers
    drivers[i].writeRegister(gconf.reg, gconf.value);
    drivers[i].writeRegister(iHold_iRun.reg, iHold_iRun.value);
    drivers[i].writeRegister(chopConf.reg, chopConf.value);

    drivers[i].setEnabled(true);
  }
}

void loop(){
  static bool driverUse;
  static bool stepsMade;
  stepsMade = false;

  static unsigned long lastSteps = -1;
  static unsigned long currentTime = 0;

  //keeps the drivers slow enough for the motors to keep up
  currentTime = micros();
  if(currentTime - lastSteps >= 2500){
    for(int i = 0; i < 4; i ++){
      driverUse = drivers[i].makeStep();
      if(driverUse){
        sReg.setPin(drivers[i].getStepPin(), HIGH);
      }

      stepsMade = (stepsMade || driverUse);
    }
    lastSteps = micros();
  }
  //Update the shift register outputs
  sReg.update();

  //Handle serial communication
  if(!stepsMade && Serial.available() > 0){
    int cmd = Serial.read();
    byte buffer[32];
    switch(cmd){
      //move the steppers (g0/g1)
      case 0:
        {
          Serial.readBytes(buffer, 8);

          int16_t xMove = *reinterpret_cast<int16_t *>(&buffer[0]);
          int16_t yMove = *reinterpret_cast<int16_t *>(&buffer[2]);
          int16_t zMove = *reinterpret_cast<int16_t *>(&buffer[4]);
          int16_t eMove = *reinterpret_cast<int16_t *>(&buffer[6]);

          uint16_t largest = 0;
          largest = max(abs(xMove), largest);
          largest = max(abs(yMove), largest);
          largest = max(abs(zMove), largest);
          largest = max(abs(eMove), largest);

          drivers[0].setRate((float)xMove / largest, abs(xMove));
          drivers[1].setRate((float)yMove / largest, abs(yMove));
          drivers[2].setRate((float)zMove / largest, abs(zMove));
          drivers[3].setRate((float)eMove / largest, abs(eMove));
        }
      break;

      default:
        //Clear garbage that happens sometimes
        Serial.read();
      break;
    }
  }

  //Reset the step pins
  if(stepsMade){
    delayMicroseconds(10);
    for(int i = 0; i < 4; i ++){
      sReg.setPin(drivers[i].getStepPin(), LOW);
    }
    sReg.update();
  }
}
