const std = @import("std");
const quat = @import("quaternion.zig");
const math = std.math;
const Vec2 = @import("vector2.zig");

pub fn Vector3(comptime T: type) type {
    switch (@typeInfo(T)) {
        .int, .float, .comptime_int, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type"),
    }

    return struct {
        x: T,
        y: T,
        z: T,

        pub const zero: Vector3(T) = .{ .x = 0.0, .y = 0.0, .z = 0.0 };
        pub const one: Vector3(T) = .{ .x = 1.0, .y = 1.0, .z = 1.0 };
        pub const up: Vector3(T) = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
        pub const right: Vector3(T) = .{ .x = 1.0, .y = 0.0, .z = 0.0 };
        pub const forward: Vector3(T) = .{ .x = 0.0, .y = 0.0, .z = 1.0 };

        pub inline fn setAdd(self: *Vector3(T), other: Vector3(T)) void {
            self.x += other.x;
            self.y += other.y;
            self.z += other.z;
        }

        pub inline fn setSubtract(self: *Vector3(T), other: Vector3(T)) void {
            self.x -= other.x;
            self.y -= other.y;
            self.z -= other.z;
        }

        pub inline fn setMultiply(self: *Vector3(T), other: Vector3(T)) void {
            self.x *= other.x;
            self.y *= other.y;
            self.z *= other.z;
        }

        pub inline fn setDivide(self: *Vector3(T), other: Vector3(T)) void {
            switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    self.x /= other.x;
                    self.y /= other.y;
                    self.z /= other.z;
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            self.x = @divFloor(self.x, other.x);
                            self.y = @divFloor(self.y, other.y);
                            self.z = @divFloor(self.z, other.z);
                        },
                        .unsigned => {
                            self.x /= other.x;
                            self.y /= other.y;
                            self.z /= other.z;
                        },
                    }
                },
                else => unreachable,
            }
        }

        pub inline fn setScale(self: *Vector3(T), scalar: T) void {
            self.x *= scalar;
            self.y *= scalar;
            self.z *= scalar;
        }

        pub inline fn setSegment(self: *Vector3(T), scalar: T) void {
            switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    self.x /= scalar;
                    self.y /= scalar;
                    self.z /= scalar;
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            self.x = @divFloor(self.x, scalar);
                            self.y = @divFloor(self.y, scalar);
                            self.z = @divFloor(self.z, scalar);
                        },
                        .unsigned => {
                            self.x /= scalar;
                            self.y /= scalar;
                            self.z /= scalar;
                        },
                    }
                },
                else => unreachable,
            }
        }

        pub inline fn setNegate(self: *Vector3(T)) void {
            switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    self.x = -self.x;
                    self.y = -self.y;
                    self.z = -self.z;
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            self.x = -self.x;
                            self.y = -self.y;
                            self.z = -self.z;
                        },
                        .unsigned => {
                            @compileError("Can't sign an unsigned integer. Was given " ++ @typeName(T) ++ " type");
                        },
                    }
                },
                else => unreachable,
            }
        }

        pub inline fn setCross(self: *Vector3(T), other: Vector3(T)) void {
            self.x = self.y * other.z - self.z * other.y;
            self.y = self.z * other.x - self.x * other.z;
            self.z = self.x * other.y - self.y * other.x;
        }

        // FIXME: Only for floats doesn't make sense with ints
        pub inline fn setRotate(self: *Vector3(T), rot: quat.Quaternion(T)) void {
            const qVec = Vector3(T){
                .x = rot.fields[1],
                .y = rot.fields[2],
                .z = rot.fields[3],
            };

            const uv = cross(qVec, self.data);
            const uuv = cross(qVec, uv);
            self.setAdd(
                Vector3(T).multiply(
                    Vector3(T).add(
                        Vector3(T).multiply(
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

        // FIXME: Only for floats doesn't make sense with ints
        pub inline fn setNormalize(self: *Vector3(T)) void {
            const len: f32 = length(self.*);
            if (len > 0.0) {
                self.setSegment(len);
            }
        }

        // NOTE: non set functions

        pub inline fn Vector3To2(self: *const Vector3(T)) Vec2.Vector2(T) {
            return Vec2.Vector2(T){
                .x = self.x,
                .y = self.y,
            };
        }

        pub inline fn add(vec1: Vector3(T), vec2: Vector3(T)) Vector3(T) {
            return Vector3(T){
                .x = vec1.x + vec2.x,
                .y = vec1.y + vec2.y,
                .z = vec1.z + vec2.z,
            };
        }

        pub inline fn subtract(vec1: Vector3(T), vec2: Vector3(T)) Vector3(T) {
            return Vector3(T){
                .x = vec1.x - vec2.x,
                .y = vec1.y - vec2.y,
                .z = vec1.z - vec2.z,
            };
        }

        pub inline fn multiply(vec1: Vector3(T), vec2: Vector3(T)) Vector3(T) {
            return Vector3(T){
                .x = vec1.x * vec2.x,
                .y = vec1.y * vec2.y,
                .z = vec1.z * vec2.z,
            };
        }

        pub inline fn divide(vec1: Vector3(T), vec2: Vector3(T)) Vector3(T) {
            return switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    return Vector3(T){
                        .x = vec1.x / vec2.x,
                        .y = vec1.y / vec2.y,
                        .z = vec1.z / vec2.z,
                    };
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            return Vector3(T){
                                .x = @divFloor(vec1.x, vec2.x),
                                .y = @divFloor(vec1.y, vec2.y),
                                .z = @divFloor(vec1.z, vec2.z),
                            };
                        },
                        .unsigned => {
                            return Vector3(T){
                                .x = vec1.x / vec2.x,
                                .y = vec1.y / vec2.y,
                                .z = vec1.z / vec2.z,
                            };
                        },
                    }
                },
                else => unreachable,
            };
        }

        pub inline fn scale(vec1: Vector3(T), scalar: f32) Vector3(T) {
            return Vector3(T){
                .x = vec1.x * scalar,
                .y = vec1.y * scalar,
                .z = vec1.z * scalar,
            };
        }

        pub inline fn segment(vec1: Vector3(T), scalar: f32) Vector3(T) {
            return switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    Vector3(T){
                        .x = vec1.x / scalar,
                        .y = vec1.y / scalar,
                        .z = vec1.z / scalar,
                    };
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            Vector3(T){
                                .x = @divFloor(vec1.x, scalar),
                                .y = @divFloor(vec1.y, scalar),
                                .z = @divFloor(vec1.z, scalar),
                            };
                        },
                        .unsigned => {
                            Vector3(T){
                                .x = vec1.x / scalar,
                                .y = vec1.y / scalar,
                                .z = vec1.z / scalar,
                            };
                        },
                    }
                },
                else => unreachable,
            };
        }

        pub inline fn negate(vec1: Vector3(T)) Vector3(T) {
            return switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    Vector3(T){
                        .x = -vec1.x,
                        .y = -vec1.y,
                        .z = -vec1.z,
                    };
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            Vector3(T){
                                .x = -vec1.x,
                                .y = -vec1.y,
                                .z = -vec1.z,
                            };
                        },
                        .unsigned => {
                            @compileError("Can't sign an unsigned integer. Was given " ++ @typeName(T) ++ " type");
                        },
                    }
                },
                else => unreachable,
            };
        }

        // FIXME: Only for floats doesn't make sense with ints
        pub inline fn dot(vec1: Vector3(T), vec2: Vector3(T)) T {
            return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z;
        }

        pub inline fn cross(vec1: Vector3(T), vec2: Vector3(T)) Vector3(T) {
            return Vector3(T){
                .x = vec1.y * vec2.z - vec1.z * vec2.y,
                .y = vec1.z * vec2.x - vec1.x * vec2.z,
                .z = vec1.x * vec2.y - vec1.y * vec2.x,
            };
        }

        pub inline fn rotate(vec1: Vector3(T), rot: quat.Quaternion(T)) Vector3(T) {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {},
                else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type"),
            }

            const qVec = Vector3(T){
                .x = rot.fields[1],
                .y = rot.fields[2],
                .z = rot.fields[3],
            };

            const uv = cross(qVec, vec1);
            const uuv = cross(qVec, uv);
            return vec1.add(
                Vector3(T).multiply(
                    Vector3(T).add(
                        Vector3(T).multiply(
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

        // FIXME: If int return float with that many bits
        // If comptime_int return comptime_float
        pub inline fn length(vec1: Vector3(T)) T {
            return @sqrt(math.pow(T, vec1.x, 2) + math.pow(T, vec1.y, 2) + math.pow(T, vec1.z, 2));
        }

        // FIXME: If int return float with that many bits
        // If comptime_int return comptime_float
        pub inline fn distance(vec1: Vector3(T), vec2: Vector3(T)) f32 {
            return @sqrt(math.pow(T, vec2.x - vec1.x, 2) + math.pow(T, vec2.y - vec1.y, 2) + math.pow(T, vec2.z - vec1.z, 2));
        }

        // FIXME: Only for floats doesn't make sense with ints
        pub inline fn normalize(vec1: Vector3(T)) Vector3(T) {
            const len: f32 = length(vec1);
            std.debug.assert(len > 0);

            return Vector3(T).segment(vec1, len);
        }
    };
}
