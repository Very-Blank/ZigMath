const std = @import("std");
const quat = @import("quaternion.zig");
const math = std.math;

pub const Vector3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub inline fn setAdd(self: *Vector3, other: Vector3) void {
        self.x += other.x;
        self.y += other.y;
        self.z += other.z;
    }

    pub inline fn setSubtract(self: *Vector3, other: Vector3) void {
        self.x -= other.x;
        self.y -= other.y;
        self.z -= other.z;
    }

    pub inline fn setMultiply(self: *Vector3, other: Vector3) void {
        self.x *= other.x;
        self.y *= other.y;
        self.z *= other.z;
    }

    pub inline fn setDivide(self: *Vector3, other: Vector3) void {
        self.x /= other.x;
        self.y /= other.y;
        self.z /= other.z;
    }

    pub inline fn setScale(self: *Vector3, scalar: f32) void {
        self.x *= scalar;
        self.y *= scalar;
        self.z *= scalar;
    }

    pub inline fn setSegment(self: *Vector3, scalar: f32) void {
        self.x /= scalar;
        self.y /= scalar;
        self.z /= scalar;
    }

    pub inline fn setNegate(self: *Vector3) void {
        self.x = -self.x;
        self.y = -self.y;
        self.z = -self.z;
    }

    pub inline fn setCross(self: *Vector3, other: Vector3) void {
        self.x = self.y * other.z - self.z * other.y;
        self.y = self.z * other.x - self.x * other.z;
        self.z = self.x * other.y - self.y * other.x;
    }

    pub inline fn setRotate(self: *Vector3, rot: quat.Quaternion) void {
        const qVec = Vector3{
            .x = rot.fields[1],
            .y = rot.fields[2],
            .z = rot.fields[3],
        };

        const uv = cross(qVec, self.data);
        const uuv = cross(qVec, uv);
        self.setAdd(
            Vector3.multiply(
                Vector3.add(
                    Vector3.multiply(
                        uv,
                        .{
                            .x = rot.fields[0],
                            .y = rot.fields[0],
                            .z = rot.fields[0],
                        },
                    ),
                    uuv,
                ),
                .{ .x = 2.0, .y = 2.0, .z = 2.0 },
            ),
        );
    }

    pub inline fn setNormalize(self: *Vector3) void {
        self.setSegment(length(self));
    }

    // NOTE: non set functions

    pub inline fn add(vec1: Vector3, vec2: Vector3) Vector3 {
        return Vector3{
            .x = vec1.x + vec2.x,
            .y = vec1.y + vec2.y,
            .z = vec1.z + vec2.z,
        };
    }

    pub inline fn subtract(vec1: Vector3, vec2: Vector3) Vector3 {
        return Vector3{
            .x = vec1.x - vec2.x,
            .y = vec1.y - vec2.y,
            .z = vec1.z - vec2.z,
        };
    }

    pub inline fn multiply(vec1: Vector3, vec2: Vector3) Vector3 {
        return Vector3{
            .x = vec1.x * vec2.x,
            .y = vec1.y * vec2.y,
            .z = vec1.z * vec2.z,
        };
    }

    pub inline fn divide(vec1: Vector3, vec2: Vector3) Vector3 {
        return Vector3{
            .x = vec1.x / vec2.x,
            .y = vec1.y / vec2.y,
            .z = vec1.z / vec2.z,
        };
    }

    pub inline fn scale(vec1: Vector3, scalar: f32) Vector3 {
        return Vector3{
            .x = vec1.x * scalar,
            .y = vec1.y * scalar,
            .z = vec1.z * scalar,
        };
    }

    pub inline fn segment(vec1: Vector3, scalar: f32) Vector3 {
        return Vector3{
            .x = vec1.x / scalar,
            .y = vec1.y / scalar,
            .z = vec1.z / scalar,
        };
    }

    pub inline fn negate(vec1: Vector3) Vector3 {
        return Vector3{
            .x = -vec1.x,
            .y = -vec1.y,
            .z = -vec1.z,
        };
    }

    pub inline fn dot(vec1: Vector3, vec2: Vector3) f32 {
        return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z;
    }

    pub inline fn cross(vec1: Vector3, vec2: Vector3) Vector3 {
        return Vector3{
            .x = vec1.y * vec2.z - vec1.z * vec2.y,
            .y = vec1.z * vec2.x - vec1.x * vec2.z,
            .z = vec1.x * vec2.y - vec1.y * vec2.x,
        };
    }

    pub inline fn rotate(vec1: Vector3, rot: quat.Quaternion) Vector3 {
        const qVec = Vector3{
            .x = rot.fields[1],
            .y = rot.fields[2],
            .z = rot.fields[3],
        };

        const uv = cross(qVec, vec1.data);
        const uuv = cross(qVec, uv);
        vec1.setAdd(
            Vector3.multiply(
                Vector3.add(
                    Vector3.multiply(
                        uv,
                        .{
                            .x = rot.fields[0],
                            .y = rot.fields[0],
                            .z = rot.fields[0],
                        },
                    ),
                    uuv,
                ),
                .{ .x = 2.0, .y = 2.0, .z = 2.0 },
            ),
        );

        return vec1;
    }

    pub inline fn length(vec1: Vector3) f32 {
        return @sqrt(math.pow(f32, vec1.x, 2.0) + math.pow(f32, vec1.y, 2.0) + math.pow(f32, vec1.z, 2.0));
    }

    pub inline fn distance(vec1: Vector3, vec2: Vector3) f32 {
        return @sqrt(math.pow(f32, vec2.x - vec1.x, 2.0) + math.pow(f32, vec2.y - vec1.y, 2.0) + math.pow(f32, vec2.z - vec1.z, 2.0));
    }

    pub inline fn normalize(vec1: Vector3) Vector3 {
        return Vector3.segment(vec1, length(vec1));
    }
};
