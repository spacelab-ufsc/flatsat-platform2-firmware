#include "sensor-manager.hpp"

#include <algorithm>
#include <array>
#include <chrono>
#include <cstdio>
#include <cstring>
#include <exception>
#include <filesystem>
#include <fstream>
#include <ios>
#include <iostream>
#include <memory>
#include <mutex>
#include <sstream>
#include <thread>
#include <utility>
#include <vector>

#include "log.hpp"
#include "sensor.hpp"

namespace fs = std::filesystem;

static void readAllInaTypes(const std::pair<std::string, std::shared_ptr<CSensor> >& ina) {
    const std::array<eMeasureType, 4> types = {BUS_VOLT, SHUNT_VOLT, CURRENT, POWER};

    for (const auto& type : types) {
        std::optional<double> value = ina.second->read(type);

        if (value)
            logs::logSensorData(ina.first, type, *value);
    }
}

void CSensorManager::matchForDeviceNames(std::vector<std::string>& searchList, std::string name, fs::path it) {
    for (auto dev = searchList.begin(); dev != searchList.end(); ++dev) {
        if (*dev == name) {
            std::string hwmonPath = it.parent_path();

            auto        sensor = std::make_shared<CSensor>(hwmonPath, (name == std::string("tmp102")) ? TMP112 : INA219);
            auto        pair   = std::make_pair(name, sensor);

            for (auto it = m_mSensorMap.begin(); it != m_mSensorMap.end(); ++it) {
                if (it->first == name) {
                    logs::log(WARN, "Device is already registered!!!");
                    return;
                }
            }

            /* Save path+dev pair on the internal map */
            m_mSensorMap.insert(pair);

            logs::log(INFO, "Found device |" + *dev + "| in path: " + hwmonPath);

            /* Remove device of the search list */
            searchList.erase(dev);

            return;
        }
    }
}

void CSensorManager::registerSensors(std::vector<std::string>&& searchList) {
    const std::string        targetName = "uevent";
    std::vector<std::string> list       = std::move(searchList);

    if (!fs::exists(m_szBaseHwmonPath) || !fs::is_directory(m_szBaseHwmonPath)) {
        logs::log(ERR, "Base path provided is not valid!");
        logs::log(ERR, "Terminating...");

        exit(1);
    }

    try {
        for (const auto& file : fs::directory_iterator(m_szBaseHwmonPath, fs::directory_options::follow_directory_symlink)) {
            fs::path ufile = file.path() / targetName;
            if (fs::exists(ufile)) {
                std::ifstream ifs;
                std::string   deviceName;
                std::string   input;

                ifs.open(ufile, std::ios::in);
                std::getline(ifs, input);

                if (input.rfind("OF_NAME=", 0) == 0)
                    deviceName = input.substr(strlen("OF_NAME="));
                else
                    continue;

                this->matchForDeviceNames(list, deviceName, ufile);
            }
        }
    } catch (std::exception& e) {
        std::stringstream ss;
        ss << "Exception occurred: " << e.what() << "\n";
        logs::log(ERR, ss.str());

        return;
    }

    for (const auto& unreg : searchList)
        logs::log(WARN, "Could not register device: " + std::string(unreg));
}

void CSensorManager::readTrackedSensors(void) {
    for (const auto& sensorPair : m_vTrackingSensors) {
        if (sensorPair.second->m_eIC == TMP112) {
            std::optional<double> read = sensorPair.second->read(TEMP);

            if (read)
                logs::logSensorData(sensorPair.first, TEMP, *read);

        } else {
            readAllInaTypes(sensorPair);
        }
    }
}

void CSensorManager::runManager(void) {
    while (true) {
        if (!m_vTrackingSensors.empty()) {
            this->readTrackedSensors();
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(m_MeasurementPeriodMS));
    }
}

void CSensorManager::registerSingleSensor(const std::string& sensorName) {
    const std::string        targetName = "uevent";
    std::vector<std::string> list{sensorName};

    if (!fs::exists(m_szBaseHwmonPath) || !fs::is_directory(m_szBaseHwmonPath)) {
        logs::log(ERR, "Base path provided is not valid!");
        logs::log(ERR, "Terminating...");

        exit(1);
    }

    try {
        for (const auto& file : fs::directory_iterator(m_szBaseHwmonPath, fs::directory_options::follow_directory_symlink)) {
            fs::path ufile = file.path() / targetName;
            if (fs::exists(ufile)) {
                std::ifstream ifs;
                std::string   deviceName;
                std::string   input;

                ifs.open(ufile, std::ios::in);
                std::getline(ifs, input);

                if (input.rfind("OF_NAME=", 0) == 0)
                    deviceName = input.substr(strlen("OF_NAME="));
                else
                    continue;

                this->matchForDeviceNames(list, deviceName, ufile);
            }
        }
    } catch (std::exception& e) {
        std::stringstream ss;
        ss << "Exception occurred: " << e.what() << "\n";
        logs::log(ERR, ss.str());

        return;
    }

    for (const auto& unreg : list)
        logs::log(WARN, "Could not register device: " + std::string(unreg));
}

void CSensorManager::trackRegisteredDevices(void) {
    logs::log(INFO, "Start tracking register devices...");

    for (const auto& pair : m_mSensorMap)
        m_vTrackingSensors.push_back(pair);
}

int32_t CSensorManager::startTracking(std::string& sensorName) {
    auto found = m_mSensorMap.find(sensorName);

    if (found == m_mSensorMap.end()) {
        logs::log(WARN, "Device was not properly registered! Can't track it!");
        return -1;
    }

    for (auto it = m_vTrackingSensors.begin(); it != m_vTrackingSensors.end(); ++it) {
        if (it->first == found->first) {
            logs::log(WARN, "Device is already being tracked!!!");
            return -1;
        }
    }

    logs::log(INFO, "Now tracking |" + sensorName + "| sensor");

    std::lock_guard<std::mutex> lock{this->m_lock};

    m_vTrackingSensors.push_back(*found);

    return 0;
}

void CSensorManager::unregisterSingleSensor(const std::string& sensorName) {
    auto found = m_mSensorMap.erase(sensorName);

    if (found == 0) {
        logs::log(ERR, "Sensor requested was not registered previously!");
    }
}

int32_t CSensorManager::stopTracking(std::string& sensorName) {
    std::lock_guard<std::mutex> lock{this->m_lock};

    auto                        deleted = std::remove_if(m_vTrackingSensors.begin(), m_vTrackingSensors.end(), [sensorName](sensorPair p) { return p.first == sensorName; });

    if (deleted == m_vTrackingSensors.end()) {
        logs::log(ERR, "Sensor requested was not being tracked!");
        return -1;
    }

    m_vTrackingSensors.erase(deleted, m_vTrackingSensors.end());

    return 0;
}

void CSensorManager::setMeasurementPeriod(uint64_t period_ms) {
    std::lock_guard<std::mutex> lock{this->m_lock};

    m_MeasurementPeriodMS = period_ms;
}
