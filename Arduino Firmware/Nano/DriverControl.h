#ifndef DriverControl_h
#define DriverControl_h

#include "Arduino.h"
#include "ShiftRegister.h"

class DriverControl{
public:
  DriverControl();
  DriverControl(ShiftRegister* reg, uint8_t chipSelect, uint8_t enable, uint8_t stepPin, uint8_t dirPin);
  uint8_t writeRegister(uint8_t reg, uint32_t data);
  uint8_t readRegister(uint8_t reg, uint32_t *data);
  void setEnabled(bool enabled);
  bool setRate(double theRate, uint16_t steps);
  bool makeStep();
  bool getDir();
  uint8_t getStepPin();
  uint8_t getDirPin();

private:
  double _rate;
  double _stepProgress;
  uint16_t _stepsToDo;

  ShiftRegister* _reg;
  uint8_t _cs;
  uint8_t _en;
  uint8_t _stepPin;
  uint8_t _dirPin;
};

#endif
