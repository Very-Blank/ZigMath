const std = @import("std");

const Quaternion = @import("quaternion.zig").Quaternion;
const Vector2 = @import("vector2.zig").Vector2;
const AxisType = @import("axis.zig").AxisType;

pub fn Vector3(comptime T: type) type {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    return struct {
        x: T = 0.0,
        y: T = 0.0,
        z: T = 0.0,

        const Self = @This();

        pub const zero: Self = .{ .x = 0.0, .y = 0.0, .z = 0.0 };
        pub const one: Self = .{ .x = 1.0, .y = 1.0, .z = 1.0 };
        pub const up: Self = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
        pub const right: Self = .{ .x = 1.0, .y = 0.0, .z = 0.0 };
        pub const forward: Self = .{ .x = 0.0, .y = 0.0, .z = 1.0 };

        pub inline fn vector3To2(self: *const Self) Vector2(T) {
            return .{
                .x = self.x,
                .y = self.y,
            };
        }

        pub inline fn add(vec1: Self, vec2: Self) Self {
            return .{
                .x = vec1.x + vec2.x,
                .y = vec1.y + vec2.y,
                .z = vec1.z + vec2.z,
            };
        }

        pub inline fn subtract(vec1: Self, vec2: Self) Self {
            return .{
                .x = vec1.x - vec2.x,
                .y = vec1.y - vec2.y,
                .z = vec1.z - vec2.z,
            };
        }

        pub inline fn multiply(vec1: Self, vec2: Self) Self {
            return .{
                .x = vec1.x * vec2.x,
                .y = vec1.y * vec2.y,
                .z = vec1.z * vec2.z,
            };
        }

        pub inline fn divide(vec1: Self, vec2: Self) Self {
            std.debug.assert(vec2.x != 0.0);
            std.debug.assert(vec2.y != 0.0);
            std.debug.assert(vec2.z != 0.0);

            return .{
                .x = vec1.x / vec2.x,
                .y = vec1.y / vec2.y,
                .z = vec1.z / vec2.z,
            };
        }

        pub inline fn scale(vec1: Self, scalar: T) Self {
            return .{
                .x = vec1.x * scalar,
                .y = vec1.y * scalar,
                .z = vec1.z * scalar,
            };
        }

        pub inline fn segment(vec1: Self, divider: T) Self {
            std.debug.assert(divider != 0.0);

            return .{
                .x = vec1.x / divider,
                .y = vec1.y / divider,
                .z = vec1.z / divider,
            };
        }

        pub inline fn negate(vec1: Self) Self {
            return .{
                .x = -vec1.x,
                .y = -vec1.y,
                .z = -vec1.z,
            };
        }

        pub inline fn dot(vec1: Self, vec2: Self) T {
            return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z;
        }

        pub inline fn cross(vec1: Self, vec2: Self) Self {
            return .{
                .x = vec1.y * vec2.z - vec1.z * vec2.y,
                .y = vec1.z * vec2.x - vec1.x * vec2.z,
                .z = vec1.x * vec2.y - vec1.y * vec2.x,
            };
        }

        pub inline fn rotateAroundAxis(vec1: Self, comptime axis: AxisType, radians: f32) Self {
            const cos = @cos(radians);
            const sin = @sin(radians);

            return switch (axis) {
                .x => .{
                    .x = vec1.x,
                    .y = vec1.y * cos - vec1.z * sin,
                    .z = vec1.y * sin + vec1.z * cos,
                },
                .y => .{
                    .x = vec1.x * cos + vec1.z * sin,
                    .y = vec1.y,
                    .z = -vec1.x * sin + vec1.z * cos,
                },
                .z => .{
                    .x = vec1.x * cos - vec1.y * sin,
                    .y = vec1.x * sin - vec1.y * cos,
                    .z = vec1.z,
                },
            };
        }

        pub fn rotate(vec1: Self, rotation: Quaternion(T)) Self {
            const qVec = Self{
                .x = rotation.fields[1],
                .y = rotation.fields[2],
                .z = rotation.fields[3],
            };

            const uv = cross(qVec, vec1);
            const uuv = cross(qVec, uv);
            return vec1.add(
                multiply(
                    add(
                        multiply(
                            uv,
                            .{
                                .x = rotation.fields[0],
                                .y = rotation.fields[0],
                                .z = rotation.fields[0],
                            },
                        ),
                        uuv,
                    ),
                    .{ .x = 2.0, .y = 2.0, .z = 2.0 },
                ),
            );
        }

        pub inline fn length(vec1: Self) T {
            return @sqrt(vec1.x * vec1.x + vec1.y * vec1.y + vec1.z * vec1.z);
        }

        pub inline fn normalize(vec1: Self) Self {
            return vec1.segment(length(vec1));
        }
    };
}
