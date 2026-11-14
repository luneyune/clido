const std = @import("std");

fn listTasks() void {
    std.debug.print("There's no tasks to do\n", .{});
}

fn printArgs(a: std.process.Args, alloc: std.mem.Allocator) !void {
    var iterator = try a.iterateAllocator(alloc);
    defer iterator.deinit();
    while (iterator.next()) |arg| {
        std.debug.print("{s}\n", .{arg});
    }
}

pub fn main(init: std.process.Init) !void {
    try printArgs(init.minimal.args, init.gpa);
}
