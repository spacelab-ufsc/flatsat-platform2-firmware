#include "log.hpp"

#include <chrono>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>

#include "sensor.hpp"

void logs::init(std::string log_dir) {
    logFile  = log_dir + "/fsat-sens.log";
    dataFile = log_dir + "/read-sensors.log";

    if (!std::filesystem::exists(log_dir))
        std::filesystem::create_directories(log_dir);
}

void logs::logSensorData(std::string sensor_name, eMeasureType type, double data) {
    std::string logMsg = "";

    if (!disableTime) {
        auto              now     = std::chrono::system_clock::now();
        std::time_t       nowTime = std::chrono::system_clock::to_time_t(now);
        std::tm           nowTm   = *std::localtime(&nowTime);

        std::stringstream ss;
        ss << std::put_time(&nowTm, "%H:%M:%S");

        logMsg += "[" + ss.str() + "]";
    }

    logMsg += "|" + sensor_name + "|";

    switch (type) {
        case TEMP: logMsg += "TEMP|"; break;
        case BUS_VOLT: logMsg += "BUS_VOLT|"; break;
        case SHUNT_VOLT: logMsg += "SHUNT_VOLT|"; break;
        case CURRENT: logMsg += "CURRENT|"; break;
        case POWER: logMsg += "POWER|"; break;
        default:
            logs::log(WARN,
                      "Invalid option for measurement type. Please check the options "
                      "again");
            break;
    }

    std::stringstream ss;
    ss << std::fixed << std::setprecision(6) << data;
    logMsg += ss.str();

    std::ofstream ofs;
    ofs.open(dataFile, std::ios::out | std::ios::app);
    ofs << logMsg << "\n";
    ofs.close();

    if (!disableSensorStdOut)
        std::cout << logMsg << "\n";
}

void logs::log(const LogLevel level, std::string str) {
    std::string coloredStr = str;

    switch (level) {
        case LOG:
            str        = "[LOG] " + str;
            coloredStr = str;
            break;
        case WARN:
            str        = "[WARN] " + str;
            coloredStr = "\033[1;33m" + str + "\033[0m"; // yellow
            break;
        case ERR:
            str        = "[ERR] " + str;
            coloredStr = "\033[1;31m" + str + "\033[0m"; // red
            break;
        case INFO:
            str        = "[INFO] " + str;
            coloredStr = "\033[1;32m" + str + "\033[0m"; // green
            break;
        default: break;
    }

    std::string ts = "";

    if (!disableTime) {
        auto              now        = std::chrono::system_clock::now();
        std::time_t       now_time_t = std::chrono::system_clock::to_time_t(now);
        std::tm           now_tm     = *std::localtime(&now_time_t);

        std::stringstream ss;
        ss << std::put_time(&now_tm, "%H:%M:%S");

        ts += "[" + ss.str() + "]";

        str        = ts + str;
        coloredStr = ts + coloredStr;
    }

    std::ofstream ofs;
    ofs.open(logFile, std::ios::out | std::ios::app);
    ofs << str << "\n";
    ofs.close();

    if (!disableStdOut)
        std::cout << ((!coloredLogs) ? str : coloredStr) << std::endl;
}
