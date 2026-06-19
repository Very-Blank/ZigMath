const std = @import("std");
const Type = @import("type.zig").Type;
const assertCompatible = @import("type.zig").assertCompatible;

pub fn Mat4(comptime T: type, comptime Unique: type) type {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    switch (@typeInfo(Unique)) {
        .@"opaque" => {},
        else => @compileError("Unexpected type was given: " ++ @typeName(Unique) ++ ", expected an opaque"),
    }

    return struct {
        fields: [4][4]T,

        const Self = @This();

        pub const InnerType = T;
        pub const @"type": Type = .mat4;

        pub const zero = Self{
            .fields = [4][4]T{
                [4]T{ 0.0, 0.0, 0.0, 0.0 },
                [4]T{ 0.0, 0.0, 0.0, 0.0 },
                [4]T{ 0.0, 0.0, 0.0, 0.0 },
                [4]T{ 0.0, 0.0, 0.0, 0.0 },
            },
        };

        pub const identity = Self{
            .fields = [4][4]T{
                [4]T{ 1.0, 0.0, 0.0, 0.0 },
                [4]T{ 0.0, 1.0, 0.0, 0.0 },
                [4]T{ 0.0, 0.0, 1.0, 0.0 },
                [4]T{ 0.0, 0.0, 0.0, 1.0 },
            },
        };

        pub fn multiply(mat1: Self, mat2: anytype) Self {
            assertCompatible(InnerType, @TypeOf(mat2), .mat4);

            var result: [4][4]T = [4][4]T{
                [4]T{ 0.0, 0.0, 0.0, 0.0 },
                [4]T{ 0.0, 0.0, 0.0, 0.0 },
                [4]T{ 0.0, 0.0, 0.0, 0.0 },
                [4]T{ 0.0, 0.0, 0.0, 0.0 },
            };

            for (0..4) |i| {
                for (0..4) |j| {
                    for (0..4) |k| {
                        result[i][j] += mat1.fields[k][j] * mat2.fields[i][k];
                    }
                }
            }

            return .{
                .fields = result,
            };
        }

        pub fn multiplyVector(mat: Self, vec: [4]T) [4]T {
            var result: [4]T = .{ 0, 0, 0, 0 };
            for (0..4) |i| {
                for (0..4) |j| {
                    result[i] += mat.fields[j][i] * vec[j];
                }
            }
            return result;
        }

        pub fn initPerspective(fov: T, aspect: T, near: T, far: T) Self {
            std.debug.assert(@abs(aspect - 0.001) > 0);
            return .{
                .fields = [4][4]T{
                    [4]T{ 1.0 / (aspect * @tan(fov / 2)), 0.0, 0.0, 0.0 },
                    [4]T{ 0.0, 1.0 / @tan(fov / 2), 0.0, 0.0 },
                    [4]T{ 0.0, 0.0, -(far + near) / (far - near), -1.0 },
                    [4]T{ 0.0, 0.0, -(2.0 * far * near) / (far - near), 0.0 },
                },
            };
        }

        pub fn initOrtho(left: T, right: T, bottom: T, top: T, zNear: T, zFar: T) Self {
            return .{ .fields = [4][4]T{
                [4]T{ 2.0 / (right - left), 0.0, 0.0, 0.0 },
                [4]T{ 0.0, 2.0 / (top - bottom), 0.0, 0.0 },
                [4]T{ 0.0, 0.0, -1.0 / (zFar - zNear), 0.0 },
                [4]T{ -(right + left) / (right - left), -(top + bottom) / (top - bottom), -zNear / (zFar - zNear), 1.0 },
            } };
        }

        pub fn initFromRotation(rot: anytype) Self {
            assertCompatible(InnerType, @TypeOf(rot), .quaternion);

            return .{
                .fields = [4][4]T{
                    [4]T{
                        1.0 - 2 * (std.math.pow(T, rot.fields[2], 2.0) + std.math.pow(T, rot.fields[3], 2.0)),
                        2 * (rot.fields[1] * rot.fields[2] + rot.fields[3] * rot.fields[0]),
                        2 * (rot.fields[1] * rot.fields[3] - rot.fields[2] * rot.fields[0]),
                        0.0,
                    },
                    [4]T{
                        2 * (rot.fields[1] * rot.fields[2] - rot.fields[3] * rot.fields[0]),
                        1.0 - 2 * (std.math.pow(T, rot.fields[1], 2.0) + std.math.pow(T, rot.fields[3], 2.0)),
                        2 * (rot.fields[2] * rot.fields[3] + rot.fields[1] * rot.fields[0]),
                        0.0,
                    },
                    [4]T{
                        2 * (rot.fields[1] * rot.fields[3] + rot.fields[2] * rot.fields[0]),
                        2 * (rot.fields[2] * rot.fields[3] - rot.fields[1] * rot.fields[0]),
                        1.0 - 2 * (std.math.pow(T, rot.fields[1], 2.0) + std.math.pow(T, rot.fields[2], 2.0)),
                        0.0,
                    },
                    [4]T{
                        0.0,
                        0.0,
                        0.0,
                        1.0,
                    },
                },
            };
        }

        pub fn transpose(self: Self) Self {
            var result: Self = undefined;

            for (0..4) |r| {
                for (0..4) |c| {
                    result.fields[r][c] = self.fields[c][r];
                }
            }

            return result;
        }

        pub fn inverse(self: Self) Self {
            const det = self.determinant();
            std.debug.assert(det != 0);

            var result: Self = undefined;

            result.fields[0][0] = det3x3([3][3]T{
                [3]T{ self.fields[1][1], self.fields[1][2], self.fields[1][3] },
                [3]T{ self.fields[2][1], self.fields[2][2], self.fields[2][3] },
                [3]T{ self.fields[3][1], self.fields[3][2], self.fields[3][3] },
            }) / det;
            result.fields[1][0] = -det3x3([3][3]T{
                [3]T{ self.fields[1][0], self.fields[1][2], self.fields[1][3] },
                [3]T{ self.fields[2][0], self.fields[2][2], self.fields[2][3] },
                [3]T{ self.fields[3][0], self.fields[3][2], self.fields[3][3] },
            }) / det;
            result.fields[2][0] = det3x3([3][3]T{
                [3]T{ self.fields[1][0], self.fields[1][1], self.fields[1][3] },
                [3]T{ self.fields[2][0], self.fields[2][1], self.fields[2][3] },
                [3]T{ self.fields[3][0], self.fields[3][1], self.fields[3][3] },
            }) / det;
            result.fields[3][0] = -det3x3([3][3]T{
                [3]T{ self.fields[1][0], self.fields[1][1], self.fields[1][2] },
                [3]T{ self.fields[2][0], self.fields[2][1], self.fields[2][2] },
                [3]T{ self.fields[3][0], self.fields[3][1], self.fields[3][2] },
            }) / det;
            result.fields[0][1] = -det3x3([3][3]T{
                [3]T{ self.fields[0][1], self.fields[0][2], self.fields[0][3] },
                [3]T{ self.fields[2][1], self.fields[2][2], self.fields[2][3] },
                [3]T{ self.fields[3][1], self.fields[3][2], self.fields[3][3] },
            }) / det;
            result.fields[1][1] = det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][2], self.fields[0][3] },
                [3]T{ self.fields[2][0], self.fields[2][2], self.fields[2][3] },
                [3]T{ self.fields[3][0], self.fields[3][2], self.fields[3][3] },
            }) / det;
            result.fields[2][1] = -det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][1], self.fields[0][3] },
                [3]T{ self.fields[2][0], self.fields[2][1], self.fields[2][3] },
                [3]T{ self.fields[3][0], self.fields[3][1], self.fields[3][3] },
            }) / det;
            result.fields[3][1] = det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][1], self.fields[0][2] },
                [3]T{ self.fields[2][0], self.fields[2][1], self.fields[2][2] },
                [3]T{ self.fields[3][0], self.fields[3][1], self.fields[3][2] },
            }) / det;
            result.fields[0][2] = det3x3([3][3]T{
                [3]T{ self.fields[0][1], self.fields[0][2], self.fields[0][3] },
                [3]T{ self.fields[1][1], self.fields[1][2], self.fields[1][3] },
                [3]T{ self.fields[3][1], self.fields[3][2], self.fields[3][3] },
            }) / det;
            result.fields[1][2] = -det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][2], self.fields[0][3] },
                [3]T{ self.fields[1][0], self.fields[1][2], self.fields[1][3] },
                [3]T{ self.fields[3][0], self.fields[3][2], self.fields[3][3] },
            }) / det;
            result.fields[2][2] = det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][1], self.fields[0][3] },
                [3]T{ self.fields[1][0], self.fields[1][1], self.fields[1][3] },
                [3]T{ self.fields[3][0], self.fields[3][1], self.fields[3][3] },
            }) / det;
            result.fields[3][2] = -det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][1], self.fields[0][2] },
                [3]T{ self.fields[1][0], self.fields[1][1], self.fields[1][2] },
                [3]T{ self.fields[3][0], self.fields[3][1], self.fields[3][2] },
            }) / det;
            result.fields[0][3] = -det3x3([3][3]T{
                [3]T{ self.fields[0][1], self.fields[0][2], self.fields[0][3] },
                [3]T{ self.fields[1][1], self.fields[1][2], self.fields[1][3] },
                [3]T{ self.fields[2][1], self.fields[2][2], self.fields[2][3] },
            }) / det;
            result.fields[1][3] = det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][2], self.fields[0][3] },
                [3]T{ self.fields[1][0], self.fields[1][2], self.fields[1][3] },
                [3]T{ self.fields[2][0], self.fields[2][2], self.fields[2][3] },
            }) / det;
            result.fields[2][3] = -det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][1], self.fields[0][3] },
                [3]T{ self.fields[1][0], self.fields[1][1], self.fields[1][3] },
                [3]T{ self.fields[2][0], self.fields[2][1], self.fields[2][3] },
            }) / det;
            result.fields[3][3] = det3x3([3][3]T{
                [3]T{ self.fields[0][0], self.fields[0][1], self.fields[0][2] },
                [3]T{ self.fields[1][0], self.fields[1][1], self.fields[1][2] },
                [3]T{ self.fields[2][0], self.fields[2][1], self.fields[2][2] },
            }) / det;

            return result;
        }

        pub fn determinant(self: Self) T {
            return self.fields[0][0] * det3x3(
                [3][3]T{
                    [3]T{ self.fields[1][1], self.fields[1][2], self.fields[1][3] },
                    [3]T{ self.fields[2][1], self.fields[2][2], self.fields[2][3] },
                    [3]T{ self.fields[3][1], self.fields[3][2], self.fields[3][3] },
                },
            ) - self.fields[0][1] * det3x3(
                [3][3]T{
                    [3]T{ self.fields[1][0], self.fields[1][2], self.fields[1][3] },
                    [3]T{ self.fields[2][0], self.fields[2][2], self.fields[2][3] },
                    [3]T{ self.fields[3][0], self.fields[3][2], self.fields[3][3] },
                },
            ) + self.fields[0][2] * det3x3(
                [3][3]T{
                    [3]T{ self.fields[1][0], self.fields[1][1], self.fields[1][3] },
                    [3]T{ self.fields[2][0], self.fields[2][1], self.fields[2][3] },
                    [3]T{ self.fields[3][0], self.fields[3][1], self.fields[3][3] },
                },
            ) - self.fields[0][3] * det3x3(
                [3][3]T{
                    [3]T{ self.fields[1][0], self.fields[1][1], self.fields[1][2] },
                    [3]T{ self.fields[2][0], self.fields[2][1], self.fields[2][2] },
                    [3]T{ self.fields[3][0], self.fields[3][1], self.fields[3][2] },
                },
            );
        }

        inline fn det3x3(fields: [3][3]T) T {
            // zig fmt: off
            return fields[0][0] * (fields[1][1] * fields[2][2] - fields[1][2] * fields[2][1])
                - fields[0][1] * (fields[1][0] * fields[2][2] - fields[1][2] * fields[2][0])
                + fields[0][2] * (fields[1][0] * fields[2][1] - fields[1][1] * fields[2][0]);
            // zig fmt: on
        }

        pub inline fn initScale(sc: anytype) Self {
            assertCompatible(InnerType, @TypeOf(sc), .vector3);

            return .{
                .fields = [4][4]T{
                    [4]T{ sc.x, 0.0, 0.0, 0.0 },
                    [4]T{ 0.0, sc.y, 0.0, 0.0 },
                    [4]T{ 0.0, 0.0, sc.z, 0.0 },
                    [4]T{ 0.0, 0.0, 0.0, 1.0 },
                },
            };
        }

        pub inline fn initTranslate(pos: anytype) Self {
            assertCompatible(InnerType, @TypeOf(pos), .vector3);
            return .{
                .fields = [4][4]T{
                    [4]T{ 1.0, 0.0, 0.0, 0.0 },
                    [4]T{ 0.0, 1.0, 0.0, 0.0 },
                    [4]T{ 0.0, 0.0, 1.0, 0.0 },
                    [4]T{ pos.x, pos.y, pos.z, 1.0 },
                },
            };
        }

        pub inline fn initView(pos: anytype, rot: anytype) Self {
            assertCompatible(InnerType, @TypeOf(pos), .vector3);
            assertCompatible(InnerType, @TypeOf(rot), .quaternion);

            return multiply(initFromRotation(rot), initTranslate(pos));
        }

        pub inline fn initModel(pos: anytype, sc: anytype, rot: anytype) Self {
            assertCompatible(InnerType, @TypeOf(pos), .vector3);
            assertCompatible(InnerType, @TypeOf(sc), .vector3);
            assertCompatible(InnerType, @TypeOf(rot), .quaternion);

            return multiply(
                multiply(
                    initTranslate(pos),
                    initFromRotation(rot),
                ),
                initScale(sc),
            );
        }
    };
}
