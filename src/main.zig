const std = @import("std");
const c = @import("c_includes.zig");

fn processArgs(a: std.process.Args, alloc: std.mem.Allocator) !void {
    var iterator = try a.iterateAllocator(alloc);
    defer iterator.deinit();
    _ = iterator.next() orelse return error.NoArgs;
    
    const first_arg = iterator.next() orelse return error.NoArgs;
    
    if (std.mem.eql(u8, first_arg, "add")) {
        const description = iterator.next() orelse return error.NoDescription;
        const maybe_time = iterator.next();

        add(description, maybe_time);
    }
}

fn add(description: []const u8, time: ?[]const u8) void {
    if (time) |t| {
        std.debug.print("Task added:\nDescription: {s}\nTime: {s}", .{description, t});
        return;
    }
    std.debug.print("Task added:\nDescription: {s}\n", .{description});
}

pub fn main(process: std.process.Init) !void {
//    var some_time: c.struct_tm = .{
//        .tm_year = 2026 - 1900,
//       .tm_mon = 10,
//        .tm_mday = 22,
//        .tm_hour = 15,
//    };
//    std.debug.print("{}\n", .{c.mktime(&some_time)});
    try processArgs(process.minimal.args, process.gpa);
}
