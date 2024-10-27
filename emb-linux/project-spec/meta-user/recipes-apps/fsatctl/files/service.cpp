#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <memory>
#include <ostream>
#include <string>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h>
#include <unistd.h>
#include <utility>
#include <vector>

#include "read-sensors.h"
#include "service.h"

static UP<SRawPacket> readSensorsCommandFN(
    std::vector<std::string> & requestVec,
    uint8_t rawCmd )
{
    auto pkt = std::make_unique<SRawPacket>();

    if( requestVec.size() < 3 )
    {
        std::cerr << "Invalid number of arguments for Read Sensors Service!!"
                  << std::endl;
        exit( 1 );
    }

    if( requestVec[ 2 ].size() > 254U )
    {
        std::cerr << "Argument provided exceeded maximum length!!" << std::endl;
        exit( 1 );
    }

    pkt->data[ 0 ] = rawCmd;
    pkt->data[ 1 ] = requestVec[ 2 ].size();
    std::memcpy( &pkt->data[ 2 ], requestVec[ 2 ].c_str(), pkt->data[ 1 ] );
    pkt->size = pkt->data[ 1 ] + 2U;

    return pkt;
}

CServiceInterface::CServiceInterface( std::string && serviceName )
{
    std::string service = std::move( serviceName );

    if( service == "read-sensors" )
    {
        m_szName = service;
        m_szSocketPath = READ_SENSORS_SOCK_PATH;

        registerCommand( SServiceCommand { "register",
                                           CMD_REGISTER_SENSOR,
                                           readSensorsCommandFN } );
        registerCommand( SServiceCommand { "unregister",
                                           CMD_UNREGISTER_SENSOR,
                                           readSensorsCommandFN } );
        registerCommand( SServiceCommand { "track",
                                           CMD_TRACK_SENSOR,
                                           readSensorsCommandFN } );
        registerCommand( SServiceCommand { "untrack",
                                           CMD_UNTRACK_SENSOR,
                                           readSensorsCommandFN } );
        registerCommand( SServiceCommand { "set-measurement-period",
                                           CMD_SET_MEASUREMENT_PERIOD,
                                           readSensorsCommandFN } );
    }
    else
    {
        std::cerr << "Unsupported service!!" << std::endl;
    }
}

void CServiceInterface::sendCommand( std::vector<std::string> && requestVec )
{
    std::vector<std::string> rq = std::move( requestVec );
    UP<SRawPacket> pkt = nullptr;
    std::string result = "";

    for( const auto & cmd: m_vCommands )
    {
        if( cmd.request == rq[ 1 ] )
        {
            pkt = cmd.fn( rq, cmd.rawCmd );
        }
    }

    if( !pkt )
    {
        std::cerr << "Invalid Command!!" << std::endl;
        exit( 1 );
    }

    result = this->requestToService( pkt.get() );

    std::cout << "Socket response: " << result << std::endl;
}

std::string CServiceInterface::requestToService( SRawPacket * rawData )
{
    int sockFd = socket( AF_UNIX, SOCK_DGRAM, 0 );

    if( sockFd == -1 )
    {
        std::cerr << "Could not get Service Socket fd!!" << std::endl;
        exit( 1 );
    }

    sockaddr_un addr {};
    addr.sun_family = AF_UNIX;
    std::strncpy( addr.sun_path,
                  m_szSocketPath.c_str(),
                  sizeof( addr.sun_path ) - 1 );

    ssize_t bytes_sent = sendto( sockFd,
                                 rawData->data,
                                 rawData->size,
                                 0,
                                 reinterpret_cast<sockaddr *>( &addr ),
                                 sizeof( addr ) );

    if( bytes_sent < 0 )
    {
        std::cerr << "Error writing to Service Socket!!" << std::endl;
        perror( "Errno: " );
        exit( 1 );
    }

    if( static_cast<size_t>( bytes_sent ) < rawData->size )
    {
        std::cerr << "Could not write the full packet to Service Socket"
                  << std::endl;
        exit( 1 );
    }

    close( sockFd );

    return "Services do not support socket response yet :(";
}

SServiceCommand CServiceInterface::registerCommand( SServiceCommand cmd )
{
    return m_vCommands.emplace_back( cmd );
}
