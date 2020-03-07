FROM debian:buster

RUN apt-get update

RUN apt-get install -y make zlib1g-dev libssl-dev gperf cmake default-jdk clang libc++-dev libc++abi-dev

RUN cd td && mkdir build && cd build

RUN export CXXFLAGS="-stdlib=libc++"

RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX:PATH=.. \
  -DTD_ENABLE_JNI=ON ..

RUN cmake --build . --target install

RUN cd ../.. && mkdir build && cd build

RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX:PATH=../td/tdlib \
  -DTd_DIR:PATH="$(readlink -e ../td/lib/cmake/Td)" .. || exit

RUN cmake --build . --target install