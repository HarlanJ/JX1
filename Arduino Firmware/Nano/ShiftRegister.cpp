#include "Arduino.h"
#include "ShiftRegister.h"

ShiftRegister::ShiftRegister(uint8_t numOut, uint8_t ser, uint8_t clock, uint8_t clear, uint8_t push){
  this->numPins = numOut;
  this->_ser = ser;
  this->_clk = clock;
  this->_cls = clear;
  this->_rck = push;

  pinMode(_ser, OUTPUT);
  pinMode(_clk, OUTPUT);
  pinMode(_cls, OUTPUT);
  pinMode(_rck, OUTPUT);

  digitalWrite(_cls, LOW);
  delayMicroseconds(10);
  digitalWrite(_cls, HIGH);

  uint8_t numReg = numOut / 8;
  numReg += (numReg*8<numOut ? 1 : 0);

  _val = (uint8_t *)malloc(sizeof(uint8_t) * numReg);
  this->update();
}

int ShiftRegister::setPin(uint8_t pin, bool val){
  if(pin >= numPins){
    return 1;
  }

  uint8_t mask = 0x01;
  mask = (mask << (pin%8));
  uint8_t* v = _val + (pin / 8);

  if(val){
    *v = (*v) | mask;
  } else {
    mask = ~mask;
    *v = (*v) & mask;
  }

  return 0;
}

void ShiftRegister::update(){
  digitalWrite(_rck, LOW);

  uint8_t pos = 0x80;
  uint8_t in = (numPins-1) / 8;

  for(int i = 0; i < numPins; i ++){
    if(pos == 0){
      pos = 0x80;
      in --;
    }

    digitalWrite(_ser, *(_val + in) & pos);
    digitalWrite(_clk, HIGH);
    delayMicroseconds(100);
    digitalWrite(_clk, LOW);

    pos = pos >> 1;
  }

  digitalWrite(_rck, HIGH);
  delayMicroseconds(100);
  digitalWrite(_rck, LOW);
}
