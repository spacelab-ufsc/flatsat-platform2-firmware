#ifndef DAEMON_HPP_
#define DAEMON_HPP_

#include <cstddef>
#include <memory>
#include <sys/types.h>
#include <thread>

#include "sensor-manager.hpp"

enum eFlatSatCommands {
    CMD_NONE,
    CMD_TRACK_SENSOR,
    CMD_REGISTER_SENSOR,
    CMD_UNTRACK_SENSOR,
    CMD_UNREGISTER_SENSOR,
    CMD_SET_MEASUREMENT_PERIOD,
};

class CDaemon {
  public:
    CDaemon(std::shared_ptr<CSensorManager> man);

  private:
    void                            parseCommand(void* packet, size_t size);
    void                            run(void);
    void                            setupSocket(void);
    ssize_t                         rxCommand(void* buff, size_t maxSize);
    std::shared_ptr<CSensorManager> m_pManager;
    std::thread                     m_tId;
    int                             m_iSockFd;
};

#endif
