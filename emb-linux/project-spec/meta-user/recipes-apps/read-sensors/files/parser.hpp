#ifndef PARSER_HPP_
#define PARSER_HPP_

#include <cstddef>
#include <stdint.h>

#include "log.hpp"

struct SParsedArgs {
    uint8_t cmd;
    uint8_t len;
    char*   payload;
};

class CParse {
  public:
    static std::optional<SParsedArgs> parsePacket(void* packet, size_t size) {
        if (size < 3U) {
            logs::log(ERR, "Packet is not formatted correctly");
            return {};
        }

        SParsedArgs pkt;

        pkt.cmd     = (*reinterpret_cast<uint8_t*>(packet));
        pkt.len     = (*(reinterpret_cast<uint8_t*>(packet) + 1UL));
        pkt.payload = reinterpret_cast<char*>(packet) + 2UL;

        if ((pkt.len + 2U) != size) {
            logs::log(ERR, "Packet lenght does not match payload lenght");
            return {};
        }

        return std::optional<SParsedArgs>(pkt);
    }
};

#endif
