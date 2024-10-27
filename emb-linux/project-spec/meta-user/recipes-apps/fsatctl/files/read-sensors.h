#ifndef READ_SENSORS_H_
#define READ_SENSORS_H_

#include <cstdint>

#define READ_SENSORS_SOCK_PATH "/run/read-sensors/read-sensors.sock"

enum eReadSensorsCmd : uint8_t
{
    CMD_TRACK_SENSOR = 0x01U,
    CMD_REGISTER_SENSOR = 0x02U,
    CMD_UNTRACK_SENSOR = 0x03U,
    CMD_UNREGISTER_SENSOR = 0x04U,
    CMD_SET_MEASUREMENT_PERIOD = 0x05U,
};

#endif
