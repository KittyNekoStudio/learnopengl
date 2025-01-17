cmake_minimum_required(VERSION 3.30.3)

project(project)

add_subdirectory(vender/glfw-3.4)

add_executable(project src/main.c src/glad.c src/shader.c src/image.c)

target_include_directories(project PUBLIC include)
target_link_libraries(project PUBLIC glfw)
