const std = @import("std");
const quat = @import("quaternion.zig");
const math = @import("mathHelper.zig");
const Vec2 = @import("vector2.zig");

pub fn Vector3(comptime T: type) type {
    switch (@typeInfo(T)) {
        .int, .float, .comptime_int, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    return struct {
        x: T,
        y: T,
        z: T,

        const Self = @This();

        pub const zero: Self = .{ .x = 0.0, .y = 0.0, .z = 0.0 };
        pub const one: Self = .{ .x = 1.0, .y = 1.0, .z = 1.0 };
        pub const up: Self = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
        pub const right: Self = .{ .x = 1.0, .y = 0.0, .z = 0.0 };
        pub const forward: Self = .{ .x = 0.0, .y = 0.0, .z = 1.0 };

        pub inline fn Vector3To2(self: *const Self) Vec2.Vector2(T) {
            return Vec2.Vector2(T){
                .x = self.x,
                .y = self.y,
            };
        }

        pub inline fn add(vec1: Self, vec2: Self) Self {
            return Self{
                .x = vec1.x + vec2.x,
                .y = vec1.y + vec2.y,
                .z = vec1.z + vec2.z,
            };
        }

        pub inline fn subtract(vec1: Self, vec2: Self) Self {
            return Self{
                .x = vec1.x - vec2.x,
                .y = vec1.y - vec2.y,
                .z = vec1.z - vec2.z,
            };
        }

        pub inline fn multiply(vec1: Self, vec2: Self) Self {
            return Self{
                .x = vec1.x * vec2.x,
                .y = vec1.y * vec2.y,
                .z = vec1.z * vec2.z,
            };
        }

        pub inline fn divide(vec1: Self, vec2: Self) Self {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {
                    switch (T) {
                        f16 => {
                            std.debug.assert(vec2.x > 1e-3);
                            std.debug.assert(vec2.y > 1e-3);
                            std.debug.assert(vec2.z > 1e-3);
                        },
                        f32, comptime_float => {
                            std.debug.assert(vec2.x > 1e-6);
                            std.debug.assert(vec2.y > 1e-6);
                            std.debug.assert(vec2.z > 1e-6);
                        },
                        f64 => {
                            std.debug.assert(vec2.x > 1e-12);
                            std.debug.assert(vec2.y > 1e-12);
                            std.debug.assert(vec2.z > 1e-12);
                        },
                        f128 => {
                            std.debug.assert(vec2.x > 1e-24);
                            std.debug.assert(vec2.y > 1e-24);
                            std.debug.assert(vec2.z > 1e-24);
                        },
                        else => unreachable,
                    }
                },
                .int, .comptime_int => {
                    std.debug.assert(vec2.x != 0);
                    std.debug.assert(vec2.y != 0);
                    std.debug.assert(vec2.z != 0);
                },
                else => unreachable,
            }

            switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    return Self{
                        .x = vec1.x / vec2.x,
                        .y = vec1.y / vec2.y,
                        .z = vec1.z / vec2.z,
                    };
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            return Self{
                                .x = @divFloor(vec1.x, vec2.x),
                                .y = @divFloor(vec1.y, vec2.y),
                                .z = @divFloor(vec1.z, vec2.z),
                            };
                        },
                        .unsigned => {
                            return Self{
                                .x = vec1.x / vec2.x,
                                .y = vec1.y / vec2.y,
                                .z = vec1.z / vec2.z,
                            };
                        },
                    }
                },
                else => unreachable,
            }
        }

        pub inline fn scale(vec1: Self, scalar: T) Self {
            return Self{
                .x = vec1.x * scalar,
                .y = vec1.y * scalar,
                .z = vec1.z * scalar,
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
                .int, .comptime_int => {
                    std.debug.assert(scalar != 0);
                },
                else => unreachable,
            }

            switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    return Self{
                        .x = vec1.x / scalar,
                        .y = vec1.y / scalar,
                        .z = vec1.z / scalar,
                    };
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            return Self{
                                .x = @divFloor(vec1.x, scalar),
                                .y = @divFloor(vec1.y, scalar),
                                .z = @divFloor(vec1.z, scalar),
                            };
                        },
                        .unsigned => {
                            return Self{
                                .x = vec1.x / scalar,
                                .y = vec1.y / scalar,
                                .z = vec1.z / scalar,
                            };
                        },
                    }
                },
                else => unreachable,
            }
        }

        pub inline fn negate(vec1: Self) Self {
            switch (@typeInfo(T)) {
                .float, .comptime_int, .comptime_float => {
                    return Self{
                        .x = -vec1.x,
                        .y = -vec1.y,
                        .z = -vec1.z,
                    };
                },
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {
                            return Self{
                                .x = -vec1.x,
                                .y = -vec1.y,
                                .z = -vec1.z,
                            };
                        },
                        .unsigned => {
                            @compileError("Can't sign an unsigned integer. Was given " ++ @typeName(T) ++ " type.");
                        },
                    }
                },
                else => unreachable,
            }
        }

        pub inline fn dot(vec1: Self, vec2: Self) T {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {},
                else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
            }

            switch (T) {
                f16 => {
                    std.debug.assert(@abs(vec1.length() - 1.0) < 1e-3);
                    std.debug.assert(@abs(vec2.length() - 1.0) < 1e-3);
                },
                f32, comptime_float => {
                    std.debug.assert(@abs(vec1.length() - 1.0) < 1e-6);
                    std.debug.assert(@abs(vec2.length() - 1.0) < 1e-6);
                },
                f64 => {
                    std.debug.assert(@abs(vec1.length() - 1.0) < 1e-12);
                    std.debug.assert(@abs(vec2.length() - 1.0) < 1e-12);
                },
                f128 => {
                    std.debug.assert(@abs(vec1.length() - 1.0) < 1e-24);
                    std.debug.assert(@abs(vec2.length() - 1.0) < 1e-24);
                },
                else => unreachable,
            }

            return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z;
        }

        pub inline fn cross(vec1: Self, vec2: Self) Self {
            switch (@typeInfo(T)) {
                .int => |int| {
                    switch (int.signedness) {
                        .signed => {},
                        .unsigned => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
                    }
                },
                else => {},
            }
            return Self{
                .x = vec1.y * vec2.z - vec1.z * vec2.y,
                .y = vec1.z * vec2.x - vec1.x * vec2.z,
                .z = vec1.x * vec2.y - vec1.y * vec2.x,
            };
        }

        pub inline fn rotate(vec1: Self, rot: quat.Quaternion(T)) Self {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {},
                else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
            }

            const qVec = Self{
                .x = rot.fields[1],
                .y = rot.fields[2],
                .z = rot.fields[3],
            };

            const uv = cross(qVec, vec1);
            const uuv = cross(qVec, uv);
            return vec1.add(
                Self.multiply(
                    Self.add(
                        Self.multiply(
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

        const returnType: type = switch (@typeInfo(T)) {
            .float, .comptime_float => T,
            .int => |int| @Type(.{ .float = .{ .bits = int.bits } }),
            .comptime_int => comptime_float,
            else => unreachable,
        };

        pub inline fn length(vec1: Self) returnType {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {
                    return @sqrt(math.pow2(returnType, vec1.x) + math.pow2(returnType, vec1.y) + math.pow2(returnType, vec1.z));
                },
                .int, .comptime_int => {
                    return @sqrt(math.pow2(returnType, @as(returnType, @floatFromInt(vec1.x))) + math.pow2(returnType, @as(returnType, @floatFromInt(vec1.y))) + math.pow2(returnType, @as(returnType, @floatFromInt(vec1.z))));
                },
                else => unreachable,
            }
        }

        pub inline fn distance(vec1: Self, vec2: Self) returnType {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {
                    return @sqrt(math.pow2(returnType, vec2.x - vec1.x) + math.pow2(returnType, vec2.y - vec1.y) + math.pow2(returnType, vec2.z - vec1.z));
                },
                .int, .comptime_int => {
                    return @sqrt(math.pow2(returnType, @as(returnType, @floatFromInt(vec2.x)) - @as(returnType, @floatFromInt(vec1.x))) + math.pow2(returnType, @as(returnType, @floatFromInt(vec2.y)) - @as(returnType, @floatFromInt(vec1.y))) + math.pow2(returnType, @as(returnType, @floatFromInt(vec2.z)) - @as(returnType, @floatFromInt(vec1.z))));
                },
                else => unreachable,
            }
        }

        pub inline fn normalize(vec1: Self) Vector3(returnType) {
            switch (@typeInfo(T)) {
                .float, .comptime_float => {
                    const len: T = length(vec1);

                    switch (T) {
                        f16 => {
                            std.debug.assert(len > 1e-3);
                        },
                        f32, comptime_float => {
                            std.debug.assert(len > 1e-6);
                        },
                        f64 => {
                            std.debug.assert(len > 1e-12);
                        },
                        f128 => {
                            std.debug.assert(len > 1e-24);
                        },
                        else => unreachable,
                    }

                    return vec1.segment(len);
                },
                .int, .comptime_int => {
                    const newVec: Vector3(returnType) = .{
                        .x = @floatFromInt(vec1.x),
                        .y = @floatFromInt(vec1.y),
                        .z = @floatFromInt(vec1.z),
                    };

                    const len: returnType = newVec.length();
                    switch (returnType) {
                        f16 => {
                            std.debug.assert(len > 1e-3);
                        },
                        f32, comptime_float => {
                            std.debug.assert(len > 1e-6);
                        },
                        f64 => {
                            std.debug.assert(len > 1e-12);
                        },
                        f128 => {
                            std.debug.assert(len > 1e-24);
                        },
                        else => unreachable,
                    }

                    return newVec.segment(len);
                },
                else => unreachable,
            }
        }
    };
}
