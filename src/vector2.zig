const std = @import("std");
const math = std.math;
const constants = @import("constants.zig");

pub const Vector2 = struct {
    x: f32,
    y: f32,

    pub inline fn setAdd(self: *Vector2, other: Vector2) void {
        self.x += other.x;
        self.y += other.y;
    }

    pub inline fn setSubtract(self: *Vector2, other: Vector2) void {
        self.x -= other.x;
        self.y -= other.y;
    }

    pub inline fn setMultiply(self: *Vector2, other: Vector2) void {
        self.x *= other.x;
        self.y *= other.y;
    }

    pub inline fn setDivide(self: *Vector2, other: Vector2) void {
        self.x /= other.x;
        self.y /= other.y;
    }

    pub inline fn setScale(self: *Vector2, scalar: f32) void {
        self.x *= scalar;
        self.y *= scalar;
    }

    pub inline fn setSegment(self: *Vector2, scalar: f32) void {
        self.x /= scalar;
        self.y /= scalar;
    }

    pub inline fn setNegate(self: *Vector2) void {
        self.x = -self.x;
        self.y = -self.y;
    }

    pub inline fn setNormalize(self: *Vector2) void {
        self.setSegment(length(self));
    }

    // NOTE: non set functions

    pub inline fn add(vec1: Vector2, vec2: Vector2) Vector2 {
        return Vector2{
            .x = vec1.x + vec2.x,
            .y = vec1.y + vec2.y,
        };
    }

    pub inline fn subtract(vec1: Vector2, vec2: Vector2) Vector2 {
        return Vector2{
            .x = vec1.x - vec2.x,
            .y = vec1.y - vec2.y,
        };
    }

    pub inline fn multiply(vec1: Vector2, vec2: Vector2) Vector2 {
        return Vector2{
            .x = vec1.x * vec2.x,
            .y = vec1.y * vec2.y,
        };
    }

    pub inline fn divide(vec1: Vector2, vec2: Vector2) Vector2 {
        return Vector2{
            .x = vec1.x / vec2.x,
            .y = vec1.y / vec2.y,
        };
    }

    pub inline fn scale(vec1: Vector2, scalar: f32) Vector2 {
        return Vector2{
            .x = vec1.x * scalar,
            .y = vec1.y * scalar,
        };
    }

    pub inline fn segment(vec1: Vector2, scalar: f32) Vector2 {
        return Vector2{
            .x = vec1.x / scalar,
            .y = vec1.y / scalar,
        };
    }

    pub inline fn negate(vec1: Vector2) Vector2 {
        return Vector2{
            .x = -vec1.x,
            .y = -vec1.y,
        };
    }

    pub inline fn dot(vec1: Vector2, vec2: Vector2) f32 {
        return vec1.x * vec2.x + vec1.y * vec2.y;
    }

    pub inline fn length(vec1: Vector2) f32 {
        return @sqrt(math.pow(f32, vec1.x, 2.0) + math.pow(f32, vec1.y, 2.0));
    }

    pub inline fn distance(vec1: Vector2, vec2: Vector2) f32 {
        return @sqrt(math.pow(f32, vec2.x - vec1.x, 2.0) + math.pow(f32, vec2.y - vec1.y, 2.0));
    }

    pub inline fn normalize(vec1: Vector2) Vector2 {
        return Vector2.segment(vec1, length(vec1));
    }
};
