const std = @import("std");
const math = std.math;
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

        pub const up: Self = .{ .x = 0, .y = 1 };
        pub const right: Self = .{ .x = 1, .y = 0 };
        pub const one: Self = .{ .x = 1, .y = 1 };
        pub const zero: Self = .{ .x = 0, .y = 0 };

        pub inline fn vector2To3(vec1: Self) Vector3(T) {
            return .{
                .x = vec1.x,
                .y = vec1.y,
                .z = 0.0,
            };
        }

        pub inline fn add(vec1: Self, vec2: Self) Self {
            return Self{
                .x = vec1.x + vec2.x,
                .y = vec1.y + vec2.y,
            };
        }

        pub inline fn subtract(vec1: Self, vec2: Self) Self {
            return Self{
                .x = vec1.x - vec2.x,
                .y = vec1.y - vec2.y,
            };
        }

        pub inline fn multiply(vec1: Self, vec2: Self) Self {
            return Self{
                .x = vec1.x * vec2.x,
                .y = vec1.y * vec2.y,
            };
        }

        pub inline fn divide(vec1: Self, vec2: Self) Self {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {
                    switch (T) {
                        f16 => {
                            std.debug.assert(vec2.x > 1e-3);
                            std.debug.assert(vec2.y > 1e-3);
                        },
                        f32, comptime_float => {
                            std.debug.assert(vec2.x > 1e-6);
                            std.debug.assert(vec2.y > 1e-6);
                        },
                        f64 => {
                            std.debug.assert(vec2.x > 1e-12);
                            std.debug.assert(vec2.y > 1e-12);
                        },
                        f128 => {
                            std.debug.assert(vec2.x > 1e-24);
                            std.debug.assert(vec2.y > 1e-24);
                        },
                        else => unreachable,
                    }
                },
                else => unreachable,
            }

            return Self{
                .x = vec1.x / vec2.x,
                .y = vec1.y / vec2.y,
            };
        }

        pub inline fn scale(vec1: Self, scalar: T) Self {
            return Self{
                .x = vec1.x * scalar,
                .y = vec1.y * scalar,
            };
        }

        pub inline fn segment(vec1: Self, scalar: T) Self {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {
                    switch (T) {
                        f16 => {
                            std.debug.assert(scalar > 1e-3);
                        },
                        f32, comptime_float => {
                            std.debug.assert(scalar > 1e-6);
                        },
                        f64 => {
                            std.debug.assert(scalar > 1e-12);
                        },
                        f128 => {
                            std.debug.assert(scalar > 1e-24);
                        },
                        else => unreachable,
                    }
                },
                else => unreachable,
            }

            return Self{
                .x = vec1.x / scalar,
                .y = vec1.y / scalar,
            };
        }

        pub inline fn negate(vec1: Self) Self {
            return Self{
                .x = -vec1.x,
                .y = -vec1.y,
            };
        }

        pub inline fn dot(vec1: Self, vec2: Self) f32 {
            return vec1.x * vec2.x + vec1.y * vec2.y;
        }

        pub inline fn length(vec1: Self) f32 {
            return @sqrt(math.pow(f32, vec1.x, 2.0) + math.pow(f32, vec1.y, 2.0));
        }

        pub inline fn distance(vec1: Self, vec2: Self) f32 {
            return @sqrt(math.pow(f32, vec2.x - vec1.x, 2.0) + math.pow(f32, vec2.y - vec1.y, 2.0));
        }

        pub inline fn normalize(vec1: Self) Self {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {
                    switch (T) {
                        f16 => {
                            std.debug.assert(length(vec1) > 1e-3);
                        },
                        f32, comptime_float => {
                            std.debug.assert(length(vec1) > 1e-6);
                        },
                        f64 => {
                            std.debug.assert(length(vec1) > 1e-12);
                        },
                        f128 => {
                            std.debug.assert(length(vec1) > 1e-24);
                        },
                        else => unreachable,
                    }
                },
                else => unreachable,
            }

            return Self.segment(vec1, length(vec1));
        }
    };
}
