const std = @import("std");
const gl = @import("gl");
const glfw = @cImport({
    @cInclude("GLFW/glfw3.h");
});

pub fn main() !void {
    const glfw_init = glfw.glfwInit();
    defer glfw.glfwTerminate();
    if (glfw_init == glfw.GLFW_FALSE) return error.GlfwInit;

    var procs: gl.ProcTable = undefined;

    const width = 800;
    const height = 600;

    glfw.glfwWindowHint(glfw.GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfw.glfwWindowHint(glfw.GLFW_CONTEXT_VERSION_MINOR, 3);
    glfw.glfwWindowHint(glfw.GLFW_OPENGL_PROFILE, glfw.GLFW_OPENGL_CORE_PROFILE);

    const window = glfw.glfwCreateWindow(width, height, "LearnOpenGL", null, null);
    if (window == null) return error.WindowCreationFailed;
    glfw.glfwMakeContextCurrent(window);
    _ = glfw.glfwSetFramebufferSizeCallback(window, framebufferSizeCallback);

    if (!procs.init(glfw.glfwGetProcAddress)) return error.ProcInitFailed;

    gl.makeProcTableCurrent(&procs);
    defer gl.makeProcTableCurrent(null);

    gl.Viewport(0, 0, width, height);

    while (glfw.glfwWindowShouldClose(window) == glfw.GLFW_FALSE) {
        processInput(window);

        gl.ClearColor(0.2, 0.3, 0.3, 1.0);
        gl.Clear(gl.COLOR_BUFFER_BIT);

        glfw.glfwSwapBuffers(window);
        glfw.glfwPollEvents();
    }
}

fn framebufferSizeCallback(_: ?*glfw.GLFWwindow, width: c_int, height: c_int) callconv (.c) void {
    gl.Viewport(0, 0, width, height);
}

fn processInput(window: ?*glfw.GLFWwindow) void {
    if (glfw.glfwGetKey(window, glfw.GLFW_KEY_ENTER) == glfw.GLFW_PRESS) {
        glfw.glfwSetWindowShouldClose(window, glfw.GLFW_TRUE);
    }
}
