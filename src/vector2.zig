const std = @import("std");
const math = std.math;
const Vector3 = @import("vector3.zig").Vector3;

pub fn Vector2(comptime T: type) type {
    return struct {
        x: T,
        y: T,

        pub const up = .{ .x = 0, .y = 1 };
        pub const right = .{ .x = 1, .y = 0 };
        pub const one = .{ .x = 1, .y = 1 };
        pub const zero = .{ .x = 0, .y = 0 };

        const Self = @This();

        pub inline fn setAdd(self: *Self, other: Self) void {
            self.x += other.x;
            self.y += other.y;
        }

        pub inline fn setSubtract(self: *Self, other: Self) void {
            self.x -= other.x;
            self.y -= other.y;
        }

        pub inline fn setMultiply(self: *Self, other: Self) void {
            self.x *= other.x;
            self.y *= other.y;
        }

        pub inline fn setDivide(self: *Self, other: Self) void {
            self.x /= other.x;
            self.y /= other.y;
        }

        pub inline fn setScale(self: *Self, scalar: f32) void {
            self.x *= scalar;
            self.y *= scalar;
        }

        pub inline fn setSegment(self: *Self, scalar: f32) void {
            self.x /= scalar;
            self.y /= scalar;
        }

        pub inline fn setNegate(self: *Self) void {
            self.x = -self.x;
            self.y = -self.y;
        }

        pub inline fn setNormalize(self: *Self) void {
            self.setSegment(length(self.*));
        }

        // NOTE: non set functions

        pub inline fn vector2To3(self: *const Self) Vector3 {
            return .{
                .x = self.x,
                .y = self.y,
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
            return Self{
                .x = vec1.x / vec2.x,
                .y = vec1.y / vec2.y,
            };
        }

        pub inline fn scale(vec1: Self, scalar: f32) Self {
            return Self{
                .x = vec1.x * scalar,
                .y = vec1.y * scalar,
            };
        }

        pub inline fn segment(vec1: Self, scalar: f32) Self {
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
            return Self.segment(vec1, length(vec1));
        }
    };
}
