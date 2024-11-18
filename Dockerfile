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

# Criar diretório de trabalho no contêiner
WORKDIR /app

# Copiar todos os arquivos do projeto para o contêiner
COPY . .

# Garantir que o arquivo CMakeLists.txt está no diretório correto
RUN test -f /app/CMakeLists.txt || (echo "CMakeLists.txt não encontrado!" && exit 1)

# Configurar e compilar o projeto com CMake
RUN cmake -Bbuild -S. -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build --config Release

# Expor a porta que o backend utilizará
EXPOSE 8080

# Comando para executar o backend
CMD ["./build/squade_illustrations"]
