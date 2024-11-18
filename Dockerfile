# Usar a imagem base do Ubuntu 22.04
FROM ubuntu:22.04

# Atualizar os pacotes e instalar dependências necessárias
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

# Verificar a instalação do Ninja
RUN ninja --version

# Instalar o Conan
RUN pip3 install conan

# Definir o diretório de trabalho no contêiner
WORKDIR /app

# Copiar todos os arquivos do projeto para o contêiner
COPY . .

# Configurar o perfil padrão do Conan
RUN conan profile detect --force

# Garantir que os geradores estão especificados no conanfile.txt
# Seu conanfile.txt deve conter:
# [generators]
# CMakeToolchain
# CMakeDeps

# Instalar as dependências com o Conan e especificar a pasta de instalação
RUN conan install . --install-folder=build --build=missing

# Configurar e compilar o projeto com CMake
RUN cmake -B build -S . -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake \
    && cmake --build build --config Release

# Expor a porta que o backend utilizará
EXPOSE 8080

# Comando para executar o backend
CMD ["./build/squade_illustrations"]
