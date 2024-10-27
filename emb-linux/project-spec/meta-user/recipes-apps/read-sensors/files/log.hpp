#ifndef LOG_HPP_
#define LOG_HPP_

#include <string>

#include "sensor.hpp"

enum LogLevel {
    NONE = -1,
    LOG  = 0,
    INFO,
    WARN,
    ERR,
};

namespace logs {
    inline std::string logFile;
    inline std::string dataFile;
    inline bool        disableTime         = false;
    inline bool        disableStdOut       = false;
    inline bool        disableSensorStdOut = false;
    inline bool        coloredLogs         = false;

    void               init(std::string logDir);
    void               log(const LogLevel level, std::string str);

    void               logSensorData(std::string sensorName, eMeasureType type, double data);
} // namespace logs

#endif
