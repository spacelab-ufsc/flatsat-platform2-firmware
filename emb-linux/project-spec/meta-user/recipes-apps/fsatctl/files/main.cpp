#include <iostream>
#include <ostream>
#include <string>
#include <vector>

#include "service.h"

const std::string_view
    USAGE = R"#(usage: fsatctl <service> <command> [args...|--help])#";

static std::vector<std::string> splitArgs( int argc, char ** argv )
{
    std::vector<std::string> result;

    for( auto i = 1; i < argc; ++i )
        result.push_back( std::string( argv[ i ] ) );

    return result;
}

int main( int argc, char ** argv )
{
    std::vector<std::string> request;

    if( argc < 2 )
    {
        std::cout << USAGE << std::endl;
        return 1;
    }

    const auto args = splitArgs( argc, argv );

    for( size_t i = 0; i < args.size(); ++i )
    {
        if( args[ i ] == "--help" || args[ i ] == "-h" )
        {
            std::cout << USAGE << std::endl;
            return 1;
        }

        if( request.size() > 0 )
        {
            request.emplace_back( args[ i ] );
        }

        auto it { g_mSupportedServices.find( args[ i ] ) };

        if( it != g_mSupportedServices.end() )
        {
            request.emplace_back( args[ i ] );
        }
    }

    size_t request_args = request.size();

    if( request_args == 0 )
    {
        std::cerr << "Invalid Service!!!" << std::endl;
        return 1;
    }

    if( request_args < 2 )
    {
        std::cerr << "Not enough arguments were provided!!" << std::endl;
        return 1;
    }

    auto service { g_mSupportedServices.find( request[ 0 ] ) };

    std::cout << "Sending command to " << service->first << std::endl;

    service->second.sendCommand( std::move( request ) );

    return 0;
}
