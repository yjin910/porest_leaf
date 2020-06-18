# Target
TARGET = .server.out

# compiler, flags, libs
CXX = g++
CXXFLAGS = -std=c++11 -pthread
OPENCV = `pkg-config --cflags --libs opencv4`

# Sources
RELEASE_SRC = src/common.cpp src/ml.cpp src/main.cpp

# Task options
OPT = #-DDIVIDE

#-----------------------------------------------#

# Compile and Run: release version

all: $(TARGET)
	@echo "Compile is done! Run with 'make run'"

$(TARGET):
	$(CXX) $(CXXFLAGS) $(OPT) $(RELEASE_SRC) $(OPENCV) -o $(TARGET)

run:
	./.server.out

#-----------------------------------------------#

# Make init and Remove target file

clean:
	rm -f *.out
	rm -f .*.out
