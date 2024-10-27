#ifndef SERVICE_H_
#define SERVICE_H_

#include <cstdint>
#include <functional>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

#define UP std::unique_ptr

struct SRawPacket
{
    uint8_t data[ 256 ];
    size_t size;
};

using FormatCommandFN = std::function<
    UP<SRawPacket>( std::vector<std::string> &, uint8_t )>;

struct SServiceCommand
{
    std::string request;
    uint8_t rawCmd;
    FormatCommandFN fn;
};

class CServiceInterface
{
  public:
    CServiceInterface( std::string && serviceName );
    void sendCommand( std::vector<std::string> && requestVec );

  private:
    std::string requestToService( SRawPacket * rawData );
    SServiceCommand registerCommand( SServiceCommand cmd );
    std::string m_szName;
    std::string m_szSocketPath;
    std::vector<SServiceCommand> m_vCommands;
};

inline std::unordered_map<std::string, CServiceInterface> g_mSupportedServices = {
    { "read-sensors", CServiceInterface { "read-sensors" } },
};

#endif
