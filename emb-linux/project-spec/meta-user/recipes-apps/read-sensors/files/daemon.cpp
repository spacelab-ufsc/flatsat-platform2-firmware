#include <cstddef>
#include <optional>
#include <string>
#include <thread>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>

#include "parser.hpp"
#include "daemon.hpp"
#include "log.hpp"

namespace {
    uint64_t strToU64(const char* str) {
        try {
            return static_cast<uint64_t>(std::stoull(str, nullptr, 10));
        } catch (const std::invalid_argument& e) {
            logs::log(ERR, "Invalid string to convert: " + std::string(e.what()));
            return 0;
        } catch (const std::out_of_range& e) {
            logs::log(ERR, "Out of Range to convert: " + std::string(e.what()));
            return 0;
        }
    }
}

CDaemon::CDaemon(std::shared_ptr<CSensorManager> man) : m_pManager{man} {
    this->setupSocket();

    m_tId = std::thread{&CDaemon::run, this};

    m_tId.detach();
}

void CDaemon::run(void) {
    constexpr size_t bufSize = 256U;
    char             buffer[bufSize];
    size_t           readSize;

    logs::log(INFO, "Starting to listen to socket...");

    while (true) {
        readSize = this->rxCommand(buffer, bufSize);

        this->parseCommand(buffer, readSize);
    }

    close(m_iSockFd);
}

void CDaemon::setupSocket(void) {
    m_iSockFd = dup(0);

    if (m_iSockFd < 0) {
        logs::log(ERR, "Could not get unix socket id");
        exit(1);
    }
}

void CDaemon::parseCommand(void* packet, size_t size) {
    std::optional<SParsedArgs> pkt = CParse::parsePacket(packet, size);

    if (!pkt)
        return;

    switch (pkt->cmd) {
        case CMD_TRACK_SENSOR: {
            logs::log(INFO, "Track sensor command received");

            std::string sensor{pkt->payload, pkt->len};
            m_pManager->startTracking(sensor);
            break;
        }
        case CMD_REGISTER_SENSOR: {
            logs::log(INFO, "Register sensor command received");

            std::string sensor{pkt->payload, pkt->len};
            m_pManager->registerSingleSensor(sensor);
            break;
        }
        case CMD_UNTRACK_SENSOR: {
            logs::log(INFO, "Untrack sensor command received");

            std::string sensor{pkt->payload, pkt->len};
            m_pManager->stopTracking(sensor);
            break;
        }
        case CMD_UNREGISTER_SENSOR: {
            logs::log(INFO, "Unregister sensor command received");

            std::string sensor{pkt->payload, pkt->len};
            m_pManager->unregisterSingleSensor(sensor);
            break;
        }
        case CMD_SET_MEASUREMENT_PERIOD: {
            logs::log(INFO, "Set measurement period command received");

            uint64_t new_period = strToU64(reinterpret_cast<const char*>(pkt->payload));

            logs::log(INFO, "New period: " + std::to_string(new_period) + " ms");
            
            if (new_period != 0) {
                m_pManager->setMeasurementPeriod(new_period);
            } else {
                logs::log(ERR, "Invalid measurement period given!!");
            }
            break;
        }
        default: logs::log(ERR, "Invalid command received!"); break;
    }
}

ssize_t CDaemon::rxCommand(void* buff, size_t maxSize) {
    ssize_t rbytes = recvfrom(m_iSockFd, buff, maxSize, 0, NULL, NULL);

    if (rbytes < 0) {
        logs::log(ERR, "Error receiving message from socket");
        return -1;
    }

    return rbytes;
}
