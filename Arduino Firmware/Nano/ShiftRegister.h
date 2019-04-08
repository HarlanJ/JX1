#ifndef ShiftRegister_h
#define ShiftRegister_h

#include "Arduino.h"

class ShiftRegister{
public:
  ShiftRegister(uint8_t numOut, uint8_t ser, uint8_t clock, uint8_t clear, uint8_t push);
  int setPin(uint8_t pin, bool val);
  void update();

private:
  uint8_t numPins, _ser, _clk, _cls, _rck;
  uint8_t* _val;
};

#endif
