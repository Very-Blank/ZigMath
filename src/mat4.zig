const std = @import("std");
const Vector3 = @import("vector3.zig").Vector3;
const quat = @import("quaternion.zig");
const math = std.math;

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
