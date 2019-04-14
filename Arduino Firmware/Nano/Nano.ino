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

//    --END OF DEFINES--

ShiftRegister sReg(16, 5, 8, 9, 7);

DriverControl xDriver, yDriver, zDriver, eDriver;

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

  RegisterSettings gconf;
  gconf.reg = WRITE_FLAG|REG_GCONF;
  gconf.value = 0x00000005UL;

  RegisterSettings iHold_iRun;
  iHold_iRun.reg = WRITE_FLAG|REG_IHOLD_IRUN;
  iHold_iRun.value = 0x00001010UL;

  RegisterSettings chopConf;
  chopConf.reg = WRITE_FLAG|REG_CHOPCONF;
  chopConf.value = 0x08008008UL;

  xDriver = DriverControl(&sReg, 6, 7);
}

void loop(){

}
