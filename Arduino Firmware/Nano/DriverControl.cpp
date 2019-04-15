#include "SPI.h"
#include "Arduino.h"
#include "DriverControl.h"

DriverControl::DriverControl(){}

DriverControl::DriverControl(ShiftRegister* reg, uint8_t chipSelect, uint8_t enable, uint8_t stepPin, uint8_t dirPin){
  this->_reg = reg;
  this->_cs = chipSelect;
  this->_en = enable;
  this->_stepPin = stepPin;
  this->_dirPin = dirPin;
}

uint8_t DriverControl::writeRegister(uint8_t reg, uint32_t data){
  uint8_t s;

  //digitalWrite(_cs, LOW);
  _reg->setPin(_cs, LOW);
  _reg->update();

  s = SPI.transfer(reg);
  SPI.transfer((data>>24UL)&0xFF)&0xFF;
  SPI.transfer((data>>16UL)&0xFF)&0xFF;
  SPI.transfer((data>> 8UL)&0xFF)&0xFF;
  SPI.transfer((data>> 0UL)&0xFF)&0xFF;

  //digitalWrite(_cs, HIGH);
  _reg->setPin(_cs, HIGH);
  _reg->update();

  return s;
}

uint8_t DriverControl::readRegister(uint8_t reg, uint32_t *data){
  uint8_t s;

  this->writeRegister(reg, 0UL);

  _reg->setPin(_cs, LOW);
  _reg->update();

  s = SPI.transfer(reg);
  *data  = SPI.transfer(0x00)&0xFF;
  *data <<=8;
  *data |= SPI.transfer(0x00)&0xFF;
  *data <<=8;
  *data |= SPI.transfer(0x00)&0xFF;
  *data <<=8;
  *data |= SPI.transfer(0x00)&0xFF;

  _reg->setPin(_cs, HIGH);
  _reg->update();

  return s;
}

void DriverControl::setEnabled(bool enabled){
  _reg->setPin(_en, !enabled);
  _reg->update();
}

bool DriverControl::setRate(double theRate, uint16_t steps){
  this->_rate = theRate;
  this->_stepsToDo = steps;
  this->_stepProgress = 0;
  return theRate < 0;
}

bool DriverControl::makeStep(){
  if(this->_stepsToDo < 1){
    return false;
  } else {
    this->_stepProgress += this->_rate;

    if(_stepProgress >= 1){
      _stepsToDo --;
      _stepProgress -= 1;
    } else if (_stepProgress <= -1){
      _stepsToDo --;
      _stepProgress += 1;
    }

    return true;
  }
}

bool DriverControl::getDir(){
  return this->_rate < 0;
}

uint8_t DriverControl::getStepPin(){
  return this->_stepPin;
}

uint8_t DriverControl::getDirPin(){
  return this->_dirPin;
}
