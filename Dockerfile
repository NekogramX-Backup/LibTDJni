FROM debian:buster

RUN apt-get update & \

apt-get install -y git make zlib1g-dev libssl-dev gperf cmake default-jdk clang libc++-dev libc++abi-dev & \

git clone https://github.com/NekogramX/LibTDJni td & \

cd td && git submodule init && git submodule update & \

cd td && mkdir build && cd build & \

export CXXFLAGS="-stdlib=libc++" & \

CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX:PATH=.. \
  -DTD_ENABLE_JNI=ON .. & \

cmake --build . --target install & \

cd ../.. && mkdir build && cd build & \

CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX:PATH=../td/tdlib \
  -DTd_DIR:PATH="$(readlink -e ../td/lib/cmake/Td)" .. & \

cmake --build . --target install