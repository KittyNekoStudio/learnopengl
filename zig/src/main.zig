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

    const vertex_shader_source =
        \\#version 330 core
        \\layout (location = 0) in vec3 aPos;
        \\
        \\void main() {
        \\  gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0f);
        \\}
    ;

    const fragment_shader_source =
        \\#version 330 core
        \\out vec4 FragColor;
        \\
        \\void main() {
        \\  FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
        \\}
    ;

    glfw.glfwWindowHint(glfw.GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfw.glfwWindowHint(glfw.GLFW_CONTEXT_VERSION_MINOR, 3);
    glfw.glfwWindowHint(glfw.GLFW_OPENGL_PROFILE, glfw.GLFW_OPENGL_CORE_PROFILE);

    const window = glfw.glfwCreateWindow(width, height, "LearnOpenGL", null, null);
    if (window == null) return error.WindowCreationFailed;
    glfw.glfwMakeContextCurrent(window);
    defer glfw.glfwMakeContextCurrent(null);
    // TODO! figure out what this returns
    _ = glfw.glfwSetFramebufferSizeCallback(window, framebufferSizeCallback);

    if (!procs.init(glfw.glfwGetProcAddress)) return error.ProcInitFailed;

    gl.makeProcTableCurrent(&procs);
    defer gl.makeProcTableCurrent(null);

    const vertex_shader = gl.CreateShader(gl.VERTEX_SHADER);
    if (vertex_shader == gl.FALSE) return error.CreateVertexShaderFailed;
    defer gl.DeleteShader(vertex_shader);

    gl.ShaderSource(vertex_shader, 1, &.{vertex_shader_source}, null);
    gl.CompileShader(vertex_shader);

    try checkCompilationSucess(vertex_shader);

    const fragment_shader = gl.CreateShader(gl.FRAGMENT_SHADER);
    if (fragment_shader == gl.FALSE) return error.CreateFragmentShaderFailed;
    defer gl.DeleteShader(fragment_shader);

    gl.ShaderSource(fragment_shader, 1, &.{fragment_shader_source}, null);
    gl.CompileShader(fragment_shader);
    try checkCompilationSucess(fragment_shader);

    const shader_program = gl.CreateProgram();
    if (shader_program == gl.FALSE) return error.CreateShaderProgramFailed;
    defer gl.DeleteProgram(shader_program);

    gl.AttachShader(shader_program, vertex_shader);
    gl.AttachShader(shader_program, fragment_shader);
    gl.LinkProgram(shader_program);
    try checkLinkSuccess(shader_program);

    gl.Viewport(0, 0, width, height);

    const vertices = [_]f32{
        0.5, 0.5, 0.0, // Top right
        0.5, -0.5, 0.0, // Bottom right
        -0.5, -0.5, 0.0, // Bottom left
        -0.5, 0.5, 0.0, // Top left
    };

    const indices = [_]u32{
        0, 1, 3,
        1, 2, 3,
    };

    var vao: c_uint = undefined;
    gl.GenVertexArrays(1, (&vao)[0..1]);
    defer gl.DeleteVertexArrays(1, (&vao)[0..1]);

    var vbo: c_uint = undefined;
    gl.GenBuffers(1, (&vbo)[0..1]);
    defer gl.DeleteBuffers(1, (&vbo)[0..1]);

    var ebo: c_uint = undefined;
    gl.GenBuffers(1, (&ebo)[0..1]);
    defer gl.DeleteBuffers(1, (&ebo)[0..1]);

    gl.BindVertexArray(vao);
    defer gl.BindVertexArray(0);

    gl.BindBuffer(gl.ARRAY_BUFFER, vbo);
    defer gl.BindBuffer(gl.ARRAY_BUFFER, 0);
    gl.BufferData(gl.ARRAY_BUFFER, @sizeOf(f32) * vertices.len, &vertices, gl.STATIC_DRAW);

    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo);
    defer gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, 0);
    gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, @sizeOf(u32) * indices.len, &indices, gl.STATIC_DRAW);

    gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * @sizeOf(f32), 0);
    gl.EnableVertexAttribArray(0);

    while (glfw.glfwWindowShouldClose(window) == glfw.GLFW_FALSE) {
        processInput(window);

        gl.ClearColor(0.2, 0.3, 0.3, 1.0);
        gl.Clear(gl.COLOR_BUFFER_BIT);

        gl.UseProgram(shader_program);

        gl.BindVertexArray(vao);
        defer gl.BindVertexArray(0);

        //gl.DrawArrays(gl.TRIANGLES, 0, 6);
        gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, 0);

        glfw.glfwSwapBuffers(window);
        glfw.glfwPollEvents();
    }
}

fn framebufferSizeCallback(_: ?*glfw.GLFWwindow, width: c_int, height: c_int) callconv(.c) void {
    gl.Viewport(0, 0, width, height);
}

fn processInput(window: ?*glfw.GLFWwindow) void {
    if (glfw.glfwGetKey(window, glfw.GLFW_KEY_ENTER) == glfw.GLFW_PRESS) {
        glfw.glfwSetWindowShouldClose(window, glfw.GLFW_TRUE);
    }
}

fn checkCompilationSucess(shader: c_uint) !void {
    var success: c_int = undefined;
    var info_log: [512:0]u8 = undefined;

    gl.GetShaderiv(shader, gl.COMPILE_STATUS, &success);
    if (success == gl.FALSE) {
        gl.GetShaderInfoLog(shader, info_log.len, null, &info_log);
        std.log.err("{s}\n", .{info_log});
        return error.CompileVertexShaderFailed;
    }
}

fn checkLinkSuccess(program: c_uint) !void {
    var success: c_int = undefined;
    var info_log: [512:0]u8 = undefined;

    gl.GetProgramiv(program, gl.LINK_STATUS, &success);
    if (success == gl.FALSE) {
        gl.GetProgramInfoLog(program, info_log.len, null, &info_log);
        std.log.err("{s}\n", .{info_log});
        return error.LinkShaderProgramFailed;
    }
}
