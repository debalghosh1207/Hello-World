cmake_minimum_required(VERSION 3.16)

project(helloworld)

set(SOURCE_FILES ./say_hi/say_hi.cpp ./say_hello/say_hello.cpp ./main.cpp)

set(HEADER_FILES ./say_hi/say_hi.hpp ./say_hello/say_hello.hpp)

set(HEADER_DIRECTORIES ./say_hello ./say_hi)

add_executable(${PROJECT_NAME} ${SOURCE_FILES} ${HEADER_FILES})

target_include_directories(${PROJECT_NAME} PUBLIC ${HEADER_DIRECTORIES})
