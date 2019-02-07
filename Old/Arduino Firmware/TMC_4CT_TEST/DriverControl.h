#ifndef DriverControl_h
#define DriverControl_h

#include "Arduino.h"

class DriverControl{
  public:
    DriverControl(uint8_t stepPin, uint8_t dirPin, uint8_t csPin, uint8_t enPin);
    uint8_t writeRegister(uint8_t reg, uint32_t data);
    uint8_t readRegister(uint8_t reg, uint32_t *data);
    void setEnabled(bool enabled);
    void setRate(double theRate, uint16_t steps);
    bool makeStep();

  private:
    double _rate;
    double _stepProgress;
    uint8_t _step, _dir, _cs, _en;
    uint16_t _stepsToDo;
    void doStep();
};

#endif
