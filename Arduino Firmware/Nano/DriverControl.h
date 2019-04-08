#ifndef DriverControl_h
#define DriverControl_h

#include "Arduino.h"

class DriverControl{
public:
    DriverControl();
    uint8_t writeRegister(uint8_t reg, uint32_t data);
    uint8_t readRegister(uint8_t reg, uint32_t *data);
    void setEnabled(bool enabled);
    void setRate(double theRate, uint16_t steps);
    bool makeStep();
    bool getDir();

  private:
    double _rate;
    double _stepProgress;
    uint16_t _stepsToDo;
};

#endif
