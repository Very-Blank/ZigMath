const std = @import("std");
const zigmath = @import("zigmath.zig");
const panictest = @import("panictest");

// BUG: this might succeed because your code was incorrect.
test "Vector with improper types" {
    try panictest.expectCompileError(
        \\const zigmath = @import("src/zigmath.zig");
        \\test "This should panic" {
        \\   _ = zigmath.Vec3.Vector3(bool);
        \\}
    );

    try panictest.expectCompileError(
        \\const zigmath = @import("src/zigmath.zig");
        \\test "This should panic" {
        \\   _ = zigmath.Vec3.Vector3([]u8);
        \\}
    );
}

test "Vector3 with proper types" {
    panictest.expectCompileError(
        \\const zigmath = @import("src/zigmath.zig");
        \\test "This shouldn't panic" {
        \\  _ = zigmath.Vec3.Vector3(f32);
        \\  _ = zigmath.Vec3.Vector3(u32);
        \\  _ = zigmath.Vec3.Vector3(i32);
        \\}
    ) catch return;

    return error.TestFailed;
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

test "Vector3 addition" {
    {
        var vec1: zigmath.Vec3.Vector3(f32) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(f32) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = -1, .y = 5, .z = 3 }, vec1.add(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setAdd(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = -1, .y = 5, .z = 3 }, vec1);
    }

    {
        var vec1: zigmath.Vec3.Vector3(i32) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(i32) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = -1, .y = 5, .z = 3 }, vec1.add(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setAdd(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = -1, .y = 5, .z = 3 }, vec1);
    }

    {
        var vec1: zigmath.Vec3.Vector3(u32) = .{ .x = 2, .y = 3, .z = 5 };
        const vec2: zigmath.Vec3.Vector3(u32) = .{ .x = 3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 5, .y = 5, .z = 13 }, vec1.add(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 2, .y = 3, .z = 5 }, vec1);
        vec1.setAdd(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 5, .y = 5, .z = 13 }, vec1);
    }
}

test "Vector3 subtraction" {
    {
        var vec1: zigmath.Vec3.Vector3(f32) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(f32) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 5, .y = 1, .z = -13 }, vec1.subtract(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setSubtract(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 5, .y = 1, .z = -13 }, vec1);
    }

    {
        var vec1: zigmath.Vec3.Vector3(i32) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(i32) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 5, .y = 1, .z = -13 }, vec1.subtract(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setSubtract(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 5, .y = 1, .z = -13 }, vec1);
    }

    {
        var vec1: zigmath.Vec3.Vector3(u32) = .{ .x = 4, .y = 3, .z = 8 };
        const vec2: zigmath.Vec3.Vector3(u32) = .{ .x = 3, .y = 2, .z = 5 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 1, .y = 1, .z = 3 }, vec1.subtract(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 4, .y = 3, .z = 8 }, vec1);
        vec1.setSubtract(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 1, .y = 1, .z = 3 }, vec1);
    }

    {
        comptime var vec1: zigmath.Vec3.Vector3(comptime_float) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(comptime_float) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = 5, .y = 1, .z = -13 }, vec1.subtract(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setSubtract(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = 5, .y = 1, .z = -13 }, vec1);
    }

    {
        comptime var vec1: zigmath.Vec3.Vector3(comptime_int) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(comptime_int) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = 5, .y = 1, .z = -13 }, vec1.subtract(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setSubtract(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = 5, .y = 1, .z = -13 }, vec1);
    }
}

test "Vector3 multiplication" {
    {
        var vec1: zigmath.Vec3.Vector3(f32) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(f32) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = -6, .y = 6, .z = -40 }, vec1.multiply(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setMultiply(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = -6, .y = 6, .z = -40 }, vec1);
    }

    {
        var vec1: zigmath.Vec3.Vector3(i32) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(i32) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = -6, .y = 6, .z = -40 }, vec1.multiply(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setMultiply(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = -6, .y = 6, .z = -40 }, vec1);
    }

    {
        var vec1: zigmath.Vec3.Vector3(u32) = .{ .x = 2, .y = 3, .z = 5 };
        const vec2: zigmath.Vec3.Vector3(u32) = .{ .x = 3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 6, .y = 6, .z = 40 }, vec1.multiply(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 2, .y = 3, .z = 5 }, vec1);
        vec1.setMultiply(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 6, .y = 6, .z = 40 }, vec1);
    }

    {
        comptime var vec1: zigmath.Vec3.Vector3(comptime_float) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(comptime_float) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = -6, .y = 6, .z = -40 }, vec1.multiply(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setMultiply(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = -6, .y = 6, .z = -40 }, vec1);
    }

    {
        comptime var vec1: zigmath.Vec3.Vector3(comptime_int) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(comptime_int) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = -6, .y = 6, .z = -40 }, vec1.multiply(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setMultiply(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = -6, .y = 6, .z = -40 }, vec1);
    }
}

test "Vector3 division" {
    {
        var vec1: zigmath.Vec3.Vector3(f32) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(f32) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 2.0 / -3.0, .y = 3.0 / 2.0, .z = -5.0 / 8.0 }, vec1.divide(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 2.0, .y = 3.0, .z = -5.0 }, vec1);
        vec1.setDivide(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(f32){ .x = 2.0 / -3.0, .y = 3.0 / 2.0, .z = -5.0 / 8.0 }, vec1);
    }

    {
        var vec1: zigmath.Vec3.Vector3(i32) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(i32) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = @divFloor(2, -3), .y = @divFloor(3, 2), .z = @divFloor(-5, 8) }, vec1.divide(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setDivide(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(i32){ .x = @divFloor(2, -3), .y = @divFloor(3, 2), .z = @divFloor(-5, 8) }, vec1);
    }

    {
        var vec1: zigmath.Vec3.Vector3(u32) = .{ .x = 2, .y = 3, .z = 5 };
        const vec2: zigmath.Vec3.Vector3(u32) = .{ .x = 3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 2 / 3, .y = 3 / 2, .z = 5 / 8 }, vec1.divide(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 2, .y = 3, .z = 5 }, vec1);
        vec1.setDivide(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(u32){ .x = 2 / 3, .y = 3 / 2, .z = 5 / 8 }, vec1);
    }

    {
        comptime var vec1: zigmath.Vec3.Vector3(comptime_float) = .{ .x = 2.0, .y = 3.0, .z = -5.0 };
        const vec2: zigmath.Vec3.Vector3(comptime_float) = .{ .x = -3.0, .y = 2.0, .z = 8.0 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = 2.0 / -3.0, .y = 3.0 / 2.0, .z = -5.0 / 8.0 }, vec1.divide(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = 2.0, .y = 3.0, .z = -5.0 }, vec1);
        vec1.setDivide(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_float){ .x = 2.0 / -3.0, .y = 3.0 / 2.0, .z = -5.0 / 8.0 }, vec1);
    }

    {
        comptime var vec1: zigmath.Vec3.Vector3(comptime_int) = .{ .x = 2, .y = 3, .z = -5 };
        const vec2: zigmath.Vec3.Vector3(comptime_int) = .{ .x = -3, .y = 2, .z = 8 };

        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = 2 / -3, .y = 3 / 2, .z = -5 / 8 }, vec1.divide(vec2));
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = 2, .y = 3, .z = -5 }, vec1);
        vec1.setDivide(vec2);
        try std.testing.expectEqual(zigmath.Vec3.Vector3(comptime_int){ .x = 2 / -3, .y = 3 / 2, .z = -5 / 8 }, vec1);
    }
}
