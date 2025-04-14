const std = @import("std");
const c = @cImport({
    @cInclude("GLFW/glfw3.h");
    @cInclude("GL/gl.h");
});

pub fn main() !void {
    std.debug.print("Hello, World!\n", .{});
}
