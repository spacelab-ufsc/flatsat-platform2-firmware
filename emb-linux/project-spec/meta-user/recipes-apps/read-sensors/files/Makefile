APP = read-sensors

# Add any other object files to this list below
APP_OBJS = log.o daemon.o sensor.o sensor-manager.o main.o

INCLUDE_FLAG = -I./
CPP_FLAGS = -std=c++17

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CXX) -o $@ $(APP_OBJS) $(LDFLAGS) $(LDLIBS)
clean:
	rm -f $(APP) *.o
