#include <memory>

#include "log.hpp"
#include "sensor-manager.hpp"
#include "daemon.hpp"
#include <vector>

#define DEBUG 0

#if DEBUG == 1
#warning Debug flag is enabled, make sure to provide a mockup for the drivers filesystem and place its absolute path at the "TEST_FS_PATH" macro on main.cpp
#define TEST_FS_PATH ""

#define BASE_PATH (TEST_FS_PATH "/sys/class/hwmon/")
#define LOG_DIR   (TEST_FS_PATH "/var/log/fsat/")
#else
#define BASE_PATH "/sys/class/hwmon/"
#define LOG_DIR   "/var/log/fsat/"
#endif

std::vector<std::string> devs = {"main-radio-power", "tmp102", "obdh-power", "beacon-power", "edc-power", "beacon2-power", "antenna-power", "payload-power"};

int main(int argc, char** argv) {
    logs::init(LOG_DIR);
    logs::disableSensorStdOut = true;
    logs::disableTime = true;

    std::shared_ptr<CSensorManager> man = std::make_shared<CSensorManager>(BASE_PATH);

    CDaemon daemon{man};

    man->registerSensors(std::move(devs));
    man->runManager();
}
