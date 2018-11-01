#include "SPI.h"
#include "DriverControl.h"

int pins[4][4] = {
  {A1, A0, A2, 2}, //driver 3, STEP, DIR, CS, EN
  {4, 3, 7, 8},    //driver 4, STEP, DIR, CS, EN
  {6, 5, 9, 10},   //driver 1, STEP, DIR, CS, EN
  {A5, A6, A4, A3} //driver 2, STEP, DIR, CS, EN
};

#define EN_PIN    3 //enable (CFG6)
#define DIR_PIN   1 //direction
#define STEP_PIN  0 //step
#define CS_PIN    2 //chip select


#define MOSI_PIN 11 //SDI/MOSI (ICSP: 4, Uno: 11, Mega: 51)
#define MISO_PIN 12 //SDO/MISO (ICSP: 1, Uno: 12, Mega: 50)
#define SCK_PIN  13 //CLK/SCK  (ICSP: 3, Uno: 13, Mega: 52)

//TMC2130 registers
#define WRITE_FLAG     (1<<7) //write flag
#define READ_FLAG      (0<<7) //read flag
#define REG_GCONF      0x00
#define REG_GSTAT      0x01
#define REG_IHOLD_IRUN 0x10
#define REG_CHOPCONF   0x6C
#define REG_COOLCONF   0x6D
#define REG_DCCTRL     0x6E
#define REG_DRVSTATUS  0x6F

DriverControl drivers[4] = {DriverControl(pins[0][0], pins[0][1], pins[0][2], pins[0][3]),
                           DriverControl(pins[1][0], pins[1][1], pins[1][2], pins[1][3]),
                           DriverControl(pins[2][0], pins[2][1], pins[2][2], pins[2][3]),
                           DriverControl(pins[3][0], pins[3][1], pins[3][2], pins[3][3])
                          };

struct RegisterSettings{
  uint8_t reg;
  uint32_t value;
};

void setup(){
  Serial.begin(11520);
  
  pinMode(MOSI_PIN, OUTPUT);
  digitalWrite(MOSI_PIN, LOW);
  pinMode(MISO_PIN, INPUT);
  digitalWrite(MISO_PIN, HIGH);
  pinMode(SCK_PIN, OUTPUT);
  digitalWrite(SCK_PIN, LOW);

  //init SPI
  SPI.begin();
  //SPI.setDataMode(SPI_MODE3); //SPI Mode 3
  //SPI.setBitOrder(MSBFIRST); //MSB first
  //SPI.setClockDivider(SPI_CLOCK_DIV128); //clk=Fcpu/128
  SPI.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE3));

  RegisterSettings gconf;
  gconf.reg = WRITE_FLAG|REG_GCONF;
  gconf.value = 0x00000005UL;
  
  RegisterSettings iHold_iRun;
  iHold_iRun.reg = WRITE_FLAG|REG_IHOLD_IRUN;
  iHold_iRun.value = 0x00001010UL;
  
  RegisterSettings chopConf;
  chopConf.reg = WRITE_FLAG|REG_CHOPCONF;
  chopConf.value = 0x08008008UL;

  for(int i = 0; i < 4; i ++){
    drivers[i].writeRegister(gconf.reg, gconf.value);
    drivers[i].writeRegister(iHold_iRun.reg, iHold_iRun.value);
    drivers[i].writeRegister(chopConf.reg, chopConf.value);
  }

  for(int i = 0; i < 4; i ++){
    drivers[i].setEnabled(true);
  }

  drivers[0].setRate(0);
  drivers[1].setRate(0);
  drivers[2].setRate(0);
}

void loop(){
  static unsigned long lastSteps = -1;
  static unsigned long currentTime = 0;

  if(Serial.available() > 0){
    Serial.read();
    drivers[0].setRate(1);
    drivers[1].setRate(1);
    drivers[2].setRate(1);
  }
  
  currentTime = micros();
  if(currentTime - lastSteps >= 1200){
    for(int i = 0; i < 3; i ++){
      drivers[i].makeStep();
    }
    lastSteps = micros();
  }
}