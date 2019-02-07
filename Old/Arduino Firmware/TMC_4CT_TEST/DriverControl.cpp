#include "Arduino.h"
#include "DriverControl.h"
#include "SPI.h"

DriverControl::DriverControl(uint8_t stepPin, uint8_t dirPin, uint8_t csPin, uint8_t enPin){
  _step = stepPin;
  _dir = dirPin;
  _cs = csPin;
  _en = enPin;

  pinMode(_en, OUTPUT);
  digitalWrite(_en, HIGH);

  pinMode(_step, OUTPUT);
  digitalWrite(_step, LOW);

  pinMode(_dir, OUTPUT);
  digitalWrite(_dir, LOW);

  pinMode(_cs, OUTPUT);
  digitalWrite(_cs, HIGH);
}

uint8_t DriverControl::writeRegister(uint8_t reg, uint32_t data){
  uint8_t s;

  digitalWrite(_cs, LOW);

  s = SPI.transfer(reg);
  SPI.transfer((data>>24UL)&0xFF)&0xFF;
  SPI.transfer((data>>16UL)&0xFF)&0xFF;
  SPI.transfer((data>> 8UL)&0xFF)&0xFF;
  SPI.transfer((data>> 0UL)&0xFF)&0xFF;

  digitalWrite(_cs, HIGH);

  return s;
}

uint8_t DriverControl::readRegister(uint8_t reg, uint32_t *data){
  uint8_t s;

  this->writeRegister(reg, 0UL);

  digitalWrite(_cs, LOW);

  s = SPI.transfer(reg);
  *data  = SPI.transfer(0x00)&0xFF;
  *data <<=8;
  *data |= SPI.transfer(0x00)&0xFF;
  *data <<=8;
  *data |= SPI.transfer(0x00)&0xFF;
  *data <<=8;
  *data |= SPI.transfer(0x00)&0xFF;

  digitalWrite(_cs, HIGH);

  return s;
}

void DriverControl::setEnabled(bool enabled){
  digitalWrite(_en, !enabled);
}

void DriverControl::setRate(double theRate, uint16_t steps){
  _rate = theRate;
  _stepsToDo = steps;
  digitalWrite(_dir, _rate < 0);
}

bool DriverControl::makeStep(){
  if(_stepsToDo == 0){
    return false;
  } else {
    _stepsToDo --;
  }
  _stepProgress += _rate;

  if(round(_stepProgress) >= 1){
    _stepProgress -= 1;
    this->doStep();
  } else if(round(_stepProgress) <= -1){
    _stepProgress += 1;
    this->doStep();
  }

  return true;
}

void DriverControl::doStep(){
  digitalWrite(_step, HIGH);
  delayMicroseconds(10);
  digitalWrite(_step, LOW);
}
