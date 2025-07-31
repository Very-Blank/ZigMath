const std = @import("std");
const Vector3 = @import("vector3.zig").Vector3;
const quat = @import("quaternion.zig");
const math = std.math;

test "determinant" {
    // Identity Matrix - Determinant: 1.0
    const mat1 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 1.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 1.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        },
    };
    std.debug.print("{any}\n", .{mat1.determinant()});

    try std.testing.expectApproxEqRel(1.0, mat1.determinant(), 0.1);

    // Uniform Scale Matrix (2x) - Determinant: 16.0
    const mat2 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 2.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 2.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 2.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 2.0 },
        },
    };

    try std.testing.expectApproxEqRel(16.0, mat2.determinant(), 0.1);

    // Translation Matrix - Determinant: 1.0
    const mat3 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0, 0.0, 0.0, 5.0 },
            @Vector(4, f32){ 0.0, 1.0, 0.0, 3.0 },
            @Vector(4, f32){ 0.0, 0.0, 1.0, -2.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        },
    };

    try std.testing.expectApproxEqRel(1.0, mat3.determinant(), 0.1);

    // Non-uniform Scale Matrix - Determinant: 24.0
    const mat4 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 2.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 3.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 4.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        },
    };

    try std.testing.expectApproxEqRel(24.0, mat4.determinant(), 0.1);

    // Simple Upper Triangular Matrix - Determinant: 120.0
    const mat5 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 2.0, 1.0, 3.0, 4.0 },
            @Vector(4, f32){ 0.0, 3.0, 2.0, 1.0 },
            @Vector(4, f32){ 0.0, 0.0, 4.0, 5.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 5.0 },
        },
    };

    try std.testing.expectApproxEqRel(120.0, mat5.determinant(), 0.1);

    // Rotation Matrix (90° around Z-axis) - Determinant: 1.0
    const mat6 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 0.0, -1.0, 0.0, 0.0 },
            @Vector(4, f32){ 1.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 1.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        },
    };

    try std.testing.expectApproxEqRel(1.0, mat6.determinant(), 0.1);

    // Reflection Matrix (across XY plane) - Determinant: -1.0
    const mat7 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 1.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, -1.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        },
    };

    try std.testing.expectApproxEqRel(-1.0, mat7.determinant(), 0.1);

    // Singular Matrix (zero determinant) - Determinant: 0.0
    const mat8 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0, 2.0, 3.0, 4.0 },
            @Vector(4, f32){ 2.0, 4.0, 6.0, 8.0 },
            @Vector(4, f32){ 0.0, 0.0, 1.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        },
    };

    try std.testing.expectApproxEqRel(0.0, mat8.determinant(), 0.1);

    // General Matrix - Determinant: -306.0
    const mat9 = Mat4(f32){
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0, 2.0, 0.0, 3.0 },
            @Vector(4, f32){ 4.0, 1.0, 2.0, 0.0 },
            @Vector(4, f32){ 0.0, 3.0, 1.0, 4.0 },
            @Vector(4, f32){ 2.0, 0.0, 4.0, 1.0 },
        },
    };

    try std.testing.expectApproxEqRel(-306.0, mat9.determinant(), 0.1);
}

pub fn Mat4(comptime T: type) type {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    return struct {
        fields: [4]@Vector(4, T),

        const Self = @This();

        pub const ZERO = Self{
            .fields = [4]@Vector(4, T){
                @Vector(4, T){ 0.0, 0.0, 0.0, 0.0 },
                @Vector(4, T){ 0.0, 0.0, 0.0, 0.0 },
                @Vector(4, T){ 0.0, 0.0, 0.0, 0.0 },
                @Vector(4, T){ 0.0, 0.0, 0.0, 0.0 },
            },
        };

        pub const IDENTITY = Self{
            .fields = [4]@Vector(4, T){
                @Vector(4, T){ 1.0, 0.0, 0.0, 0.0 },
                @Vector(4, T){ 0.0, 1.0, 0.0, 0.0 },
                @Vector(4, T){ 0.0, 0.0, 1.0, 0.0 },
                @Vector(4, T){ 0.0, 0.0, 0.0, 1.0 },
            },
        };

        pub fn multiply(mat1: Self, mat2: Self) Self {
            var result: [4]@Vector(4, T) = [4]@Vector(4, T){
                @Vector(4, T){ 0.0, 0.0, 0.0, 0.0 },
                @Vector(4, T){ 0.0, 0.0, 0.0, 0.0 },
                @Vector(4, T){ 0.0, 0.0, 0.0, 0.0 },
                @Vector(4, T){ 0.0, 0.0, 0.0, 0.0 },
            };

            for (0..4) |i| {
                for (0..4) |j| {
                    for (0..4) |k| {
                        result[i][j] += mat1.fields[i][k] * mat2.fields[k][j];
                    }
                }
            }

            return .{
                .fields = result,
            };
        }

        pub fn perspective(fov: T, aspect: T, near: T, far: T) Self {
            std.debug.assert(@abs(aspect - 0.001) > 0);
            return .{
                .fields = [4]@Vector(4, T){
                    @Vector(4, T){ 1.0 / (aspect * @tan(fov / 2)), 0.0, 0.0, 0.0 },
                    @Vector(4, T){ 0.0, 1.0 / @tan(fov / 2), 0.0, 0.0 },
                    @Vector(4, T){ 0.0, 0.0, -(far + near) / (far - near), -1.0 },
                    @Vector(4, T){ 0.0, 0.0, -(2.0 * far * near) / (far - near), 0.0 },
                },
            };
        }

        pub fn ortho(left: T, right: T, bottom: T, top: T, zNear: T, zFar: T) Self {
            return .{ .fields = [4]@Vector(4, T){
                @Vector(4, T){ 2.0 / (right - left), 0.0, 0.0, -(right + left) / (right - left) },
                @Vector(4, T){ 0.0, 2.0 / (top - bottom), 0.0, -(top + bottom) / (top - bottom) },
                @Vector(4, T){ 0.0, 0.0, -1.0 / (zFar - zNear), -zNear / (zFar - zNear) },
                @Vector(4, T){ 0.0, 0.0, 0.0, 1.0 },
            } };
        }

        pub fn rotation(rot: quat.Quaternion(T)) Self {
            return .{
                .fields = [4]@Vector(4, T){
                    @Vector(4, T){
                        1.0 - 2 * (math.pow(T, rot.fields[2], 2.0) + math.pow(T, rot.fields[3], 2.0)),
                        2 * (rot.fields[1] * rot.fields[2] + rot.fields[3] * rot.fields[0]),
                        2 * (rot.fields[1] * rot.fields[3] - rot.fields[2] * rot.fields[0]),
                        0.0,
                    },
                    @Vector(4, T){
                        2 * (rot.fields[1] * rot.fields[2] - rot.fields[3] * rot.fields[0]),
                        1.0 - 2 * (math.pow(T, rot.fields[1], 2.0) + math.pow(T, rot.fields[3], 2.0)),
                        2 * (rot.fields[2] * rot.fields[3] + rot.fields[1] * rot.fields[0]),
                        0.0,
                    },
                    @Vector(4, T){
                        2 * (rot.fields[1] * rot.fields[3] + rot.fields[2] * rot.fields[0]),
                        2 * (rot.fields[2] * rot.fields[3] - rot.fields[1] * rot.fields[0]),
                        1.0 - 2 * (math.pow(T, rot.fields[1], 2.0) + math.pow(T, rot.fields[2], 2.0)),
                        0.0,
                    },
                    @Vector(4, T){
                        0.0,
                        0.0,
                        0.0,
                        1.0,
                    },
                },
            };
        }

        // FIXME:
        pub fn determinant(self: Self) T {
            var det: T = 0.0;
            inline for (0..4) |i| {
                var sDet: T = 0.0;
                inline for (1..3) |j| {
                    std.debug.print("\n", .{});

                    std.debug.print("1,1: [1][{any}]\n", .{(i + j) % 4});

                    std.debug.print("a * d\n", .{});
                    std.debug.print("2,2: [2][{any}]\n", .{(i + j + 1) % 4});
                    std.debug.print("3,3: [3][{any}]\n", .{(i + j + 2) % 4});

                    std.debug.print("- b * c\n", .{});
                    std.debug.print("3,2: [2][{any}]\n", .{(i + j + 2) % 4});
                    std.debug.print("2,3: [3][{any}]\n", .{(i + j + 1) % 4});

                    if (j % 2 == 0) {
                        sDet += self.fields[1][(i + j) % 4] * (self.fields[2][(i + j + 1) % 4] * self.fields[3][(i + j + 2) % 4] - self.fields[2][(i + j + 2) % 4] * self.fields[3][(i + j + 1) % 4]);
                    } else {
                        sDet -= self.fields[1][(i + j) % 4] * (self.fields[2][(i + j + 1) % 4] * self.fields[3][(i + j + 2) % 4] - self.fields[2][(i + j + 2) % 4] * self.fields[3][(i + j + 1) % 4]);
                    }
                }

                if (i % 2 == 0) {
                    det += self.fields[0][i] * sDet;
                } else {
                    det -= self.fields[0][i] * sDet;
                }
            }

            std.debug.print("\n", .{});
            std.debug.print("\n", .{});

            return det;
        }

        pub fn scale(sc: Vector3(T)) Self {
            return .{
                .fields = [4]@Vector(4, T){
                    @Vector(4, T){ sc.x, 0.0, 0.0, 0.0 },
                    @Vector(4, T){ 0.0, sc.y, 0.0, 0.0 },
                    @Vector(4, T){ 0.0, 0.0, sc.z, 0.0 },
                    @Vector(4, T){ 0.0, 0.0, 0.0, 1.0 },
                },
            };
        }

        pub fn translate(pos: Vector3(T)) Self {
            return .{
                .fields = [4]@Vector(4, T){
                    @Vector(4, T){ 1.0, 0.0, 0.0, 0.0 },
                    @Vector(4, T){ 0.0, 1.0, 0.0, 0.0 },
                    @Vector(4, T){ 0.0, 0.0, 1.0, 0.0 },
                    @Vector(4, T){ pos.x, pos.y, pos.z, 1.0 },
                },
            };
        }

        pub inline fn view(pos: Vector3(T), rot: quat.Quaternion(T)) Self {
            return multiply(translate(pos), rotation(rot));
        }

        pub inline fn model(pos: Vector3(T), sc: Vector3(T), rot: quat.Quaternion(T)) Self {
            return multiply(
                multiply(
                    rotation(rot),
                    scale(sc),
                ),
                translate(pos),
            );
        }
    };
}
