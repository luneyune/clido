const std = @import("std");
const c = @import("c_includes.zig");


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

pub fn main(_: std.process.Init) !void {
    var some_time: c.struct_tm = .{
        .tm_year = 2026 - 1900,
        .tm_mon = 10,
        .tm_mday = 22,
        .tm_hour = 15,
    };
    std.debug.print("{}\n", .{c.mktime(&some_time)});
}
