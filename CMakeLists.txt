cmake_minimum_required(VERSION 3.3.0)
    
project(myprogram C)

# find_package(OpenGL REQUIRED)

# set(GLFW_INCLUDE_PATH "include/GLFW")

# include_directories(
	# ${GLFW_INCLUDE_PATH}
# )

set(MY_HEADER_FILES
    src/shader.h
)

set(MY_SOURCE_FILES
    src/main.c
    src/glad.c
    src/shader.c
)

add_executable(myprogram ${MY_HEADER_FILES} ${MY_SOURCE_FILES})

target_link_libraries(myprogram
	# ${OPENGL_LIBRARY}
	# ${GLFW_LIBRARY}
    glfw
    GL
    X11
    pthread
    Xrandr
    Xi
    dl)
