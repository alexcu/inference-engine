#!/usr/bin/env bash

#
# Alex Cummaudo - 1744070
# Intro to AI - Assignment 2
# Run Script
#

EXECUTABLE="bin/iengine"
SOURCE_CODE="src/*.swift"
OS=$(uname)

#
# Check that swift 2.2 is installed
#
function check_swift_version() {
  SWIFT_INSTALLED=$(which swiftc 2>&1 >/dev/null; echo $?)
  SWIFT_VERSION_22=$(swiftc -v 2>&1 >/dev/null | grep -c 2.2)

  echo "Checking your Swift compiler version..."
  if [ $SWIFT_INSTALLED -ne 0 ] || [ $SWIFT_VERSION_22 -ne 1 ]; then
    echo "You do not have the Swift 2.2 compiler installed on this machine"
    echo "Please download and install Swift 2.2 from http://swift.org/download"
    if [ "$OS" == "Darwin" ]; then
      OS_INSTALL_DOWNLOAD="installation"
    elif [ "$OS" == "Linux" ]; then
      OS_INSTALL_DOWNLOAD="installation-1"
    fi
    echo "and follow installation instructions here https://swift.org/download/#$OS_INSTALL_DOWNLOAD"
    exit 1
  else
    echo "OK - Swift 2.2 is installed!"
  fi
}

#
# Compiles Swift source to exeuctable
#
function compile_src() {
  echo "Compiling Swift source code..."
  mkdir -p $(dirname $EXECUTABLE)
  if [ "$OS" == "Darwin" ]; then
    xcrun -sdk macosx \
      swiftc $SOURCE_CODE -o $EXECUTABLE \
        -lX11 -L/usr/local/lib/X11 \
        -I/usr/local/include/X11 \
        -I$(pwd)/lib/CX11 \
        -O -whole-module-optimization
  elif [ "$OS" == "Linux" ]; then
    swiftc $SOURCE_CODE -o $EXECUTABLE \
      -lX11 -L/usr/local/lib/X11 \
      -I/usr/local/include/X11 \
      -I$(pwd)/lib/CX11 \
      -O -whole-module-optimization
  fi
  if [ $? -ne 0 ]; then
    echo "Couldn't build my code on your machine :'("
    echo "Please don't fail me - I tried!"
    echo "Can you email me at acummaudo@swin.edu.au and we can work out why?"
    exit 1
  fi
}

# Don't even bother if not OS X or Linux
if [ "$OS" != "Darwin" ] && [ "$OS" != "Linux" ]; then
  echo "This OS cannot compile or run the required software. Use Linux (Ubuntu) or OS X."
  exit 1
fi

# Make sure we run wherever the shell script is
cd "$(dirname $0)"

# Build the executable if it is not yet build
if [ ! -x $EXECUTABLE ]; then
  echo "Source not yet compiled!"
  check_swift_version
  compile_src
  echo "Compiled! Running $EXECUTABLE"
fi

# Now run it
$EXECUTABLE "$@"
