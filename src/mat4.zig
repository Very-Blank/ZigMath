const std = @import("std");
const Vector3 = @import("vector3.zig").Vector3;
const quat = @import("quaternion.zig");
const math = std.math;

pub const Mat4 = struct {
    fields: [4]@Vector(4, f32),

    pub fn setMultiply(self: *Mat4, other: Mat4) void {
        var result: [4]@Vector(4, f32) = [4]@Vector(4, f32){
            @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
        };

        for (0..4) |i| {
            for (0..4) |j| {
                for (0..4) |k| {
                    result[i][j] += self.fields[i][k] * other.fields[k][j];
                }
            }
        }

        self.fields = result;
    }

    pub fn setPerspective(self: *Mat4, fov: f32, aspect: f32, near: f32, far: f32) void {
        std.debug.assert(@abs(aspect - 0.001) > 0);

        self.fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0 / (aspect * @tan(fov / 2)), 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 1.0 / @tan(fov / 2), 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, -(far + near) / (far - near), -1.0 },
            @Vector(4, f32){ 0.0, 0.0, -(2.0 * far * near) / (far - near), 0.0 },
        };
    }

    pub fn setOrtho(self: *Mat4, left: f32, right: f32, bottom: f32, top: f32, zNear: f32, zFar: f32) void {
        self.fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 2.0 / (right - left), 0.0, 0.0, -(right + left) / (right - left) },
            @Vector(4, f32){ 0.0, 2.0 / (top - bottom), 0.0, -(top + bottom) / (top - bottom) },
            @Vector(4, f32){ 0.0, 0.0, -1.0 / (zFar - zNear), -zNear / (zFar - zNear) },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        };
    }

    pub fn setRotation(self: *Mat4, rot: quat.Quaternion) void {
        // column major
        self.fields = [4]@Vector(4, f32){
            @Vector(4, f32){
                1.0 - 2 * (math.pow(f32, rot.fields[2], 2.0) + math.pow(f32, rot.fields[3], 2.0)),
                2 * (rot.fields[1] * rot.fields[2] + rot.fields[3] * rot.fields[0]),
                2 * (rot.fields[1] * rot.fields[3] - rot.fields[2] * rot.fields[0]),
                0.0,
            },
            @Vector(4, f32){
                2 * (rot.fields[1] * rot.fields[2] - rot.fields[3] * rot.fields[0]),
                1.0 - 2 * (math.pow(f32, rot.fields[1], 2.0) + math.pow(f32, rot.fields[3], 2.0)),
                2 * (rot.fields[2] * rot.fields[3] + rot.fields[1] * rot.fields[0]),
                0.0,
            },
            @Vector(4, f32){
                2 * (rot.fields[1] * rot.fields[3] + rot.fields[2] * rot.fields[0]),
                2 * (rot.fields[2] * rot.fields[3] - rot.fields[1] * rot.fields[0]),
                1.0 - 2 * (math.pow(f32, rot.fields[1], 2.0) + math.pow(f32, rot.fields[2], 2.0)),
                0.0,
            },
            @Vector(4, f32){
                0.0,
                0.0,
                0.0,
                1.0,
            },
        };
    }

    pub fn setScale(self: *Mat4, scale: Vector3) void {
        self.fields = [4]@Vector(4, f32){
            @Vector(4, f32){ scale.x, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, scale.y, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, scale.z, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        };
    }

    pub fn setTranslate(self: *Mat4, vector: Vector3) void {
        self.fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 1.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 1.0, 0.0 },
            @Vector(4, f32){ vector.x, vector.y, vector.z, 1.0 },
        };
    }

    pub inline fn setView(self: *Mat4, position: Vector3, rotation: quat.Quaternion) void {
        self.fields = multiply(createTranslate(position), createRotation(rotation)).fields;
    }

    pub inline fn setModel(self: *Mat4, position: Vector3, scale: Vector3, rotation: quat.Quaternion) void {
        self.fields = multiply(
            multiply(
                createRotation(rotation),
                createScale(scale),
            ),
            createTranslate(position),
        ).fields;
    }

    pub fn multiply(mat1: Mat4, mat2: Mat4) Mat4 {
        var result: [4]@Vector(4, f32) = [4]@Vector(4, f32){
            @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
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

    pub fn createPerspective(fov: f32, aspect: f32, near: f32, far: f32) Mat4 {
        std.debug.assert(@abs(aspect - 0.001) > 0);
        return .{
            .fields = [4]@Vector(4, f32){
                @Vector(4, f32){ 1.0 / (aspect * @tan(fov / 2)), 0.0, 0.0, 0.0 },
                @Vector(4, f32){ 0.0, 1.0 / @tan(fov / 2), 0.0, 0.0 },
                @Vector(4, f32){ 0.0, 0.0, -(far + near) / (far - near), -1.0 },
                @Vector(4, f32){ 0.0, 0.0, -(2.0 * far * near) / (far - near), 0.0 },
            },
        };
    }

    pub fn createOrtho(left: f32, right: f32, bottom: f32, top: f32, zNear: f32, zFar: f32) Mat4 {
        return .{ .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 2.0 / (right - left), 0.0, 0.0, -(right + left) / (right - left) },
            @Vector(4, f32){ 0.0, 2.0 / (top - bottom), 0.0, -(top + bottom) / (top - bottom) },
            @Vector(4, f32){ 0.0, 0.0, -1.0 / (zFar - zNear), -zNear / (zFar - zNear) },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        } };
    }

    pub fn createRotation(rot: quat.Quaternion) Mat4 {
        return .{
            .fields = [4]@Vector(4, f32){
                @Vector(4, f32){
                    1.0 - 2 * (math.pow(f32, rot.fields[2], 2.0) + math.pow(f32, rot.fields[3], 2.0)),
                    2 * (rot.fields[1] * rot.fields[2] + rot.fields[3] * rot.fields[0]),
                    2 * (rot.fields[1] * rot.fields[3] - rot.fields[2] * rot.fields[0]),
                    0.0,
                },
                @Vector(4, f32){
                    2 * (rot.fields[1] * rot.fields[2] - rot.fields[3] * rot.fields[0]),
                    1.0 - 2 * (math.pow(f32, rot.fields[1], 2.0) + math.pow(f32, rot.fields[3], 2.0)),
                    2 * (rot.fields[2] * rot.fields[3] + rot.fields[1] * rot.fields[0]),
                    0.0,
                },
                @Vector(4, f32){
                    2 * (rot.fields[1] * rot.fields[3] + rot.fields[2] * rot.fields[0]),
                    2 * (rot.fields[2] * rot.fields[3] - rot.fields[1] * rot.fields[0]),
                    1.0 - 2 * (math.pow(f32, rot.fields[1], 2.0) + math.pow(f32, rot.fields[2], 2.0)),
                    0.0,
                },
                @Vector(4, f32){
                    0.0,
                    0.0,
                    0.0,
                    1.0,
                },
            },
        };
    }

    pub fn createScale(scale: Vector3) Mat4 {
        return .{
            .fields = [4]@Vector(4, f32){
                @Vector(4, f32){ scale.x, 0.0, 0.0, 0.0 },
                @Vector(4, f32){ 0.0, scale.y, 0.0, 0.0 },
                @Vector(4, f32){ 0.0, 0.0, scale.z, 0.0 },
                @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
            },
        };
    }

    pub fn createTranslate(vector: Vector3) Mat4 {
        return .{
            .fields = [4]@Vector(4, f32){
                @Vector(4, f32){ 1.0, 0.0, 0.0, 0.0 },
                @Vector(4, f32){ 0.0, 1.0, 0.0, 0.0 },
                @Vector(4, f32){ 0.0, 0.0, 1.0, 0.0 },
                @Vector(4, f32){ vector.x, vector.y, vector.z, 1.0 },
            },
        };
    }

    pub inline fn createView(position: Vector3, rotation: quat.Quaternion) Mat4 {
        return multiply(createTranslate(position), createRotation(rotation));
    }

    pub inline fn createModel(position: Vector3, scale: Vector3, rotation: quat.Quaternion) Mat4 {
        return multiply(
            multiply(
                createRotation(rotation),
                createScale(scale),
            ),
            createTranslate(position),
        );
    }
};
