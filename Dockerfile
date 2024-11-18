# Usar a imagem base do Arch Linux
FROM archlinux:latest

# Atualizar pacotes e instalar dependências
RUN pacman -Sy --noconfirm \
    base-devel \
    cmake \
    git \
    openssl \
    boost \
    zlib \
    python \
    python-pip \
    ninja

# Instalar o Conan
RUN pip install conan

# Criar diretório de trabalho no contêiner
WORKDIR /app

# Copiar todos os arquivos do projeto para o contêiner
COPY . .

# Configurar o perfil padrão do Conan
RUN conan profile detect --force

# Instalar as dependências com o Conan e gerar o arquivo conan_toolchain.cmake
RUN conan install . --output-folder=build --build=missing

# Configurar e compilar o projeto com CMake
RUN cmake -Bbuild -S. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=/app/build/conan_toolchain.cmake \
    && cmake --build build --config Release

# Expor a porta que o backend utilizará
EXPOSE 8080

# Comando para executar o backend
CMD ["./build/squade_illustrations"]
