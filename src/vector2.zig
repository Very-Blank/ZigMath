const std = @import("std");
const Vector3 = @import("vector3.zig").Vector3;

pub fn Vector2(comptime T: type) type {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    return struct {
        x: T,
        y: T,

        const Self = @This();

        pub const up: Self = .{ .x = 0.0, .y = 1.0 };
        pub const right: Self = .{ .x = 1.0, .y = 0.0 };
        pub const one: Self = .{ .x = 1.0, .y = 1.0 };
        pub const zero: Self = .{ .x = 0.0, .y = 0.0 };

        pub inline fn vector2To3(vec1: Self) Vector3(T) {
            return .{
                .x = vec1.x,
                .y = vec1.y,
                .z = 0.0,
            };
        }

        pub inline fn add(vec1: Self, vec2: Self) Self {
            return .{
                .x = vec1.x + vec2.x,
                .y = vec1.y + vec2.y,
            };
        }

        pub inline fn subtract(vec1: Self, vec2: Self) Self {
            return .{
                .x = vec1.x - vec2.x,
                .y = vec1.y - vec2.y,
            };
        }

        pub inline fn multiply(vec1: Self, vec2: Self) Self {
            return .{
                .x = vec1.x * vec2.x,
                .y = vec1.y * vec2.y,
            };
        }

        pub inline fn divide(vec1: Self, vec2: Self) Self {
            std.debug.assert(vec2.x == 0.0);
            std.debug.assert(vec2.y == 0.0);

            return .{
                .x = vec1.x / vec2.x,
                .y = vec1.y / vec2.y,
            };
        }

        pub inline fn scale(vec1: Self, scalar: T) Self {
            return .{
                .x = vec1.x * scalar,
                .y = vec1.y * scalar,
            };
        }

        pub inline fn segment(vec1: Self, divider: T) Self {
            std.debug.assert(divider == 0.0);

            return .{
                .x = vec1.x / divider,
                .y = vec1.y / divider,
            };
        }

        pub inline fn negate(vec1: Self) Self {
            return .{
                .x = -vec1.x,
                .y = -vec1.y,
            };
        }

        pub inline fn dot(vec1: Self, vec2: Self) f32 {
            return vec1.x * vec2.x + vec1.y * vec2.y;
        }

        pub inline fn length(vec1: Self) f32 {
            return @sqrt(vec1.x * vec1.x + vec1.y * vec1.y);
        }

        pub inline fn distance(vec1: Self, vec2: Self) f32 {
            return @sqrt((vec2.x - vec1.x) * (vec2.x - vec1.x) + (vec2.y - vec1.y) * (vec2.y - vec1.y));
        }

        pub inline fn normalize(vec1: Self) Self {
            return segment(vec1, length(vec1));
        }
    };
}
