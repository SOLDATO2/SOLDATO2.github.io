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
    && rm -rf /var/lib/apt/lists/*

# Criar diretório de trabalho
WORKDIR /app

# Copiar o código do projeto para o contêiner
COPY . .

# Configurar e compilar o projeto com CMake
RUN cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build --config Release

# Expor a porta que o backend utilizará
EXPOSE 8080

# Comando para executar o backend
CMD ["./build/squade_illustrations"]
