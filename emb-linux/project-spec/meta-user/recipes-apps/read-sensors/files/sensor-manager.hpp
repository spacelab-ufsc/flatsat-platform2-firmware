#ifndef READ_SENSORS_HPP_
#define READ_SENSORS_HPP_

#include <filesystem>
#include <memory>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>
#include <mutex>
#include <cstdint>

#include "sensor.hpp"

namespace fs = std::filesystem;

class CSensorManager {
    using fileIter   = std::filesystem::directory_entry;
    using sensorPtr  = std::shared_ptr<CSensor>;
    using sensorPair = std::pair<std::string, sensorPtr>;

  public:
    CSensorManager(std::string hwmonPath) : m_szBaseHwmonPath{hwmonPath} {}
    void    runManager(void);
    void    registerSensors(std::vector<std::string>&& searchList);
    void    registerSingleSensor(const std::string& sensorName);
    void    unregisterSingleSensor(const std::string& sensorName);
    void    trackRegisteredDevices(void);
    void    setMeasurementPeriod(const uint64_t time_ms);
    int32_t startTracking(std::string& sensorName);
    int32_t stopTracking(std::string& sensorName);

  private:
    void                                       matchForDeviceNames(std::vector<std::string>& devs, std::string name, fs::path it);
    void                                       readTrackedSensors(void);
    std::unordered_map<std::string, sensorPtr> m_mSensorMap;
    std::vector<sensorPair>                    m_vTrackingSensors;
    std::string                                m_szBaseHwmonPath;
    std::mutex                                 m_lock;
    uint64_t                                   m_MeasurementPeriodMS{1000ULL};
};

#endif
