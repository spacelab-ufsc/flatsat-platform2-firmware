#ifndef SENSOR_HPP_
#define SENSOR_HPP_

#include <optional>
#include <string>

enum eMeasureType {
    TEMP,
    CURRENT,
    SHUNT_VOLT,
    BUS_VOLT,
    POWER,
};

enum eSensorType : int32_t {
    INA219 = 0,
    TMP112,
};

class CSensor {
  public:
    CSensor(std::string path, eSensorType sensor_type) : m_eIC{sensor_type}, m_szDriverFile{path} {}
    std::optional<double> read(const eMeasureType type) const;
    const eSensorType     m_eIC;

  private:
    const std::string m_szDriverFile;
};

#endif
