cmake_minimum_required(VERSION 3.15)
project(squade_illustrations CXX)


find_package(Crow REQUIRED)

add_executable(${PROJECT_NAME} src/main.cpp)

if (MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/SUBSYSTEM:CONSOLE")
endif()

# Linkar o executável com as dependências
target_link_libraries(${PROJECT_NAME} Crow::Crow)
