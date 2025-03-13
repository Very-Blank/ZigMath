const std = @import("std");
const builtin = @import("std").builtin;
const zigmath = @import("zigmath.zig");
const expect = std.testing.expect;

// NOTE: this waits for https://github.com/ziglang/zig/issues/513
//
// test "Vector with improper types" {
//     try std.testing.expectCompileError(zigmath.Vec3.Vector3(bool));
// }

// This just tests that the thing complies nothing else really
test "Vector3 with proper types" {
    _ = zigmath.Vec3.Vector3(f32);
    _ = zigmath.Vec3.Vector3(u32);
    _ = zigmath.Vec3.Vector3(i32);
}

test "Vector3 defaults" {
    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 0, .y = 0, .z = 0 }, zigmath.Vec3.Vector3(f32).zero);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 0, .y = 0, .z = 0 }, zigmath.Vec3.Vector3(u32).zero);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 0, .y = 0, .z = 0 }, zigmath.Vec3.Vector3(i32).zero);

    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 1, .y = 1, .z = 1 }, zigmath.Vec3.Vector3(f32).one);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 1, .y = 1, .z = 1 }, zigmath.Vec3.Vector3(u32).one);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 1, .y = 1, .z = 1 }, zigmath.Vec3.Vector3(i32).one);

    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 0, .y = 1, .z = 0 }, zigmath.Vec3.Vector3(f32).up);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 0, .y = 1, .z = 0 }, zigmath.Vec3.Vector3(u32).up);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 0, .y = 1, .z = 0 }, zigmath.Vec3.Vector3(i32).up);

    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 1, .y = 0, .z = 0 }, zigmath.Vec3.Vector3(f32).right);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 1, .y = 0, .z = 0 }, zigmath.Vec3.Vector3(u32).right);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 1, .y = 0, .z = 0 }, zigmath.Vec3.Vector3(i32).right);

    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 0, .y = 0, .z = 1 }, zigmath.Vec3.Vector3(f32).forward);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 0, .y = 0, .z = 1 }, zigmath.Vec3.Vector3(u32).forward);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 0, .y = 0, .z = 1 }, zigmath.Vec3.Vector3(i32).forward);
}

test "Vector3 float addition" {
    var vec1: zigmath.Vec3.Vector3(f32) = .{ .x = 2, .y = 3, .z = -5 };
    const vec2: zigmath.Vec3.Vector3(f32) = .{ .x = -3, .y = 2, .z = 8 };

    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = -1, .y = 5, .z = 3 }, vec1.add(vec2));
    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 2, .y = 3, .z = -5 }, vec1);
    vec1.setAdd(vec2);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = -1, .y = 5, .z = 3 }, vec1);
}

test "Vector3 signed integer addition" {
    var vec1: zigmath.Vec3.Vector3(i32) = .{ .x = 2, .y = 3, .z = -5 };
    const vec2: zigmath.Vec3.Vector3(i32) = .{ .x = -3, .y = 2, .z = 8 };

    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = -1, .y = 5, .z = 3 }, vec1.add(vec2));
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 2, .y = 3, .z = -5 }, vec1);
    vec1.setAdd(vec2);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = -1, .y = 5, .z = 3 }, vec1);
}

test "Vector3 unsigned integer addition" {
    var vec1: zigmath.Vec3.Vector3(u32) = .{ .x = 2, .y = 3, .z = 5 };
    const vec2: zigmath.Vec3.Vector3(u32) = .{ .x = 3, .y = 2, .z = 8 };

    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 5, .y = 5, .z = 13 }, vec1.add(vec2));
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 2, .y = 3, .z = 5 }, vec1);
    vec1.setAdd(vec2);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 5, .y = 5, .z = 13 }, vec1);
}

test "Vector3 float multiplication" {
    var vec1: zigmath.Vec3.Vector3(f32) = .{ .x = 2, .y = 3, .z = -5 };
    const vec2: zigmath.Vec3.Vector3(f32) = .{ .x = -3, .y = 2, .z = 8 };

    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = -6, .y = 6, .z = -40 }, vec1.multiply(vec2));
    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 2, .y = 3, .z = -5 }, vec1);
    vec1.setAdd(vec2);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = -6, .y = 6, .z = -40 }, vec1);
}

test "Vector3 signed integer multiplication" {
    var vec1: zigmath.Vec3.Vector3(i32) = .{ .x = 2, .y = 3, .z = -5 };
    const vec2: zigmath.Vec3.Vector3(i32) = .{ .x = -3, .y = 2, .z = 8 };

    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = -6, .y = 6, .z = -40 }, vec1.multiply(vec2));
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 2, .y = 3, .z = -5 }, vec1);
    vec1.setAdd(vec2);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = -6, .y = 6, .z = -40 }, vec1);
}

test "Vector3 unsigned integer multiplication" {
    var vec1: zigmath.Vec3.Vector3(u32) = .{ .x = 2, .y = 3, .z = 5 };
    const vec2: zigmath.Vec3.Vector3(u32) = .{ .x = 3, .y = 2, .z = 8 };

    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 6, .y = 6, .z = 40 }, vec1.add(vec2));
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 2, .y = 3, .z = 5 }, vec1);
    vec1.setAdd(vec2);
    try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 6, .y = 6, .z = 40 }, vec1);
}
