FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    libssl-dev \
    zlib1g-dev \
    python3 \
    python3-pip \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

RUN ninja --version

RUN pip3 install conan

WORKDIR /app

COPY . .

RUN conan profile detect --force

# Certifique-se de que os geradores estão especificados
COPY conanfile.txt conanfile.txt

RUN conan install . --output-folder=build --build=missing

RUN cmake -B build -S . -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake \
    && cmake --build build --config Release

EXPOSE 8080

CMD ["./build/squade_illustrations"]
