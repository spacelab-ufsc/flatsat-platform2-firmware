#include "sensor.hpp"

#include <cstdint>
#include <exception>
#include <fstream>
#include <optional>
#include <string>

#include "log.hpp"

static std::optional<int32_t> readDriverFile(const std::string& file) {
    std::string   reading;
    std::ifstream ifs;
    ifs.open(file, std::ios::in);

    if (!ifs.is_open()) {
        const std::string errMsg = "Could not open : " + file;
        logs::log(ERR, errMsg);
        return {};
    }

    std::getline(ifs, reading);
    ifs.close();

    int32_t rawValue;
    try {
        rawValue = std::stoi(reading);
    } catch (std::exception& e) {
        logs::log(ERR, "Could not parse file reading");
        return {};
    }

    return std::optional<int32_t>{rawValue};
}

std::optional<double> CSensor::read(const eMeasureType type) const {
    std::optional<int32_t> rawValue;
    std::optional<double>  reading;
    std::string            readPath = m_szDriverFile;
    eSensorType            ic;

    switch (type) {
        case TEMP:
            readPath += "/temp1_input";
            ic = TMP112;
            break;
        case BUS_VOLT:
            readPath += "/in1_input";
            ic = INA219;
            break;
        case SHUNT_VOLT:
            readPath += "/in0_input";
            ic = INA219;
            break;
        case CURRENT:
            readPath += "/curr1_input";
            ic = INA219;
            break;
        case POWER:
            readPath += "/power1_input";
            ic = INA219;
            break;
        default:
            logs::log(ERR, "Invalid option for reading. Please check the options again");
            logs::log(ERR, "Terminating...");
            exit(1);
    }

    if (ic != m_eIC) {
        logs::log(ERR, "Invalid option for selected sensor");
        return {};
    }

    rawValue = readDriverFile(readPath);

    if (!rawValue) {
        logs::log(ERR, "Could not read the driver file");
        return {};
    }

    switch (type) {
        case TEMP:
            reading = std::optional<double>{static_cast<double>(*rawValue) / 1000}; /* Temp in Celsius */
            break;
        case BUS_VOLT:
            reading = std::optional<double>{static_cast<double>(*rawValue)}; /* Voltage in mV */
            break;
        case SHUNT_VOLT:
            reading = std::optional<double>{static_cast<double>(*rawValue)}; /* Voltage in mV */
            break;
        case CURRENT:
            reading = std::optional<double>{static_cast<double>(*rawValue)}; /* Current in mA */
            break;
        case POWER:
            reading = std::optional<double>{static_cast<double>(*rawValue) / 1000}; /* Power in mW */
            break;
    }

    return reading;
}
