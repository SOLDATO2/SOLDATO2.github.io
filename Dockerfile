# Imagem base com CMake e um compilador C++ moderno
FROM ubuntu:22.04

# Atualizar os pacotes e instalar dependências
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

# Instalar o Conan
RUN pip3 install conan

# Criar diretório de trabalho no contêiner
WORKDIR /app

# Copiar todos os arquivos do projeto para o contêiner
COPY . .

# Configurar o perfil padrão do Conan
RUN conan profile detect --force

# Instalar as dependências com o Conan e gerar o arquivo conan_toolchain.cmake
RUN conan install . --output-folder=build --build=missing

# Configurar e compilar o projeto com CMake
RUN cmake -Bbuild -S. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake \
    && cmake --build build --config Release

# Expor a porta que o backend utilizará
EXPOSE 8080

# Comando para executar o backend
CMD ["./build/squade_illustrations"]
