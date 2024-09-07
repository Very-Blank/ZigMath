const std = @import("std");
const vec3 = @import("vector3.zig");
const quat = @import("quaternion.zig");
const math = std.math;

/// zero matrix.
pub const ZERO = Mat3{
    .fields = [3]@Vector(3, f32){
        @Vector(3, f32){ 0.0, 0.0, 0.0 },
        @Vector(3, f32){ 0.0, 0.0, 0.0 },
        @Vector(3, f32){ 0.0, 0.0, 0.0 },
    },
};

pub const IDENTITY = Mat3{
    .fields = [3]@Vector(3, f32){
        @Vector(3, f32){ 1.0, 0.0, 0.0 },
        @Vector(3, f32){ 0.0, 1.0, 0.0 },
        @Vector(3, f32){ 0.0, 0.0, 1.0 },
    },
};

pub const Mat3 = struct {
    fields: [3]@Vector(3, f32),

    pub fn setMultiply(self: *Mat3, other: Mat3) void {
        var result: [3]@Vector(3, f32) = [3]@Vector(3, f32){
            @Vector(3, f32){ 1.0, 0.0, 0.0 },
            @Vector(3, f32){ 0.0, 1.0, 0.0 },
            @Vector(3, f32){ 0.0, 0.0, 1.0 },
        };

        for (0..3) |i| {
            for (0..3) |j| {
                for (0..3) |k| {
                    result[i][j] += self.fields[i][k] * other.fields[k][j];
                }
            }
        }

        self.fields = result;
    }

    pub fn setRotation(self: *Mat3, rot: quat.Quaternion) void {
        // column major
        self.fields = [3]@Vector(3, f32){
            @Vector(3, f32){
                1.0 - 2 * (math.pow(f32, rot.data[2], 2.0) + math.pow(f32, rot.data[3], 2.0)),
                2 * (rot.data[1] * rot.data[2] + rot.data[3] * rot.data[0]),
                2 * (rot.data[1] * rot.data[3] - rot.data[2] * rot.data[0]),
            },
            @Vector(3, f32){
                2 * (rot.data[1] * rot.data[2] - rot.data[3] * rot.data[0]),
                1.0 - 2 * (math.pow(f32, rot.data[1], 2.0) + math.pow(f32, rot.data[3], 2.0)),
                2 * (rot.data[2] * rot.data[3] + rot.data[1] * rot.data[0]),
            },
            @Vector(3, f32){
                2 * (rot.data[1] * rot.data[3] + rot.data[2] * rot.data[0]),
                2 * (rot.data[2] * rot.data[3] - rot.data[1] * rot.data[0]),
                1.0 - 2 * (math.pow(f32, rot.data[1], 2.0) + math.pow(f32, rot.data[2], 2.0)),
            },
        };
    }

    pub fn setScale(self: *Mat3, scale: vec3.Vector3) void {
        self.fields = [3]@Vector(3, f32){
            @Vector(3, f32){ scale.data[0], 0.0, 0.0 },
            @Vector(3, f32){ 0.0, scale.data[1], 0.0 },
            @Vector(3, f32){ 0.0, 0.0, scale.data[2] },
        };
    }
};

pub fn multiply(mat1: Mat3, mat2: Mat3) Mat3 {
    var result: [3]@Vector(3, f32) = [3]@Vector(3, f32){
        @Vector(3, f32){ 1.0, 0.0, 0.0 },
        @Vector(3, f32){ 0.0, 1.0, 0.0 },
        @Vector(3, f32){ 0.0, 0.0, 1.0 },
    };

    for (0..3) |i| {
        for (0..3) |j| {
            for (0..3) |k| {
                result[i][j] += mat1.fields[i][k] * mat2.fields[k][j];
            }
        }
    }

    return .{
        .fields = result,
    };
}

pub fn createRotation(rot: quat.Quaternion) Mat3 {
    // column major
    const result: [3]@Vector(3, f32) = [3]@Vector(3, f32){
        @Vector(3, f32){
            1.0 - 2 * (math.pow(f32, rot.data[2], 2.0) + math.pow(f32, rot.data[3], 2.0)),
            2 * (rot.data[1] * rot.data[2] + rot.data[3] * rot.data[0]),
            2 * (rot.data[1] * rot.data[3] - rot.data[2] * rot.data[0]),
        },
        @Vector(3, f32){
            2 * (rot.data[1] * rot.data[2] - rot.data[3] * rot.data[0]),
            1.0 - 2 * (math.pow(f32, rot.data[1], 2.0) + math.pow(f32, rot.data[3], 2.0)),
            2 * (rot.data[2] * rot.data[3] + rot.data[1] * rot.data[0]),
        },
        @Vector(3, f32){
            2 * (rot.data[1] * rot.data[3] + rot.data[2] * rot.data[0]),
            2 * (rot.data[2] * rot.data[3] - rot.data[1] * rot.data[0]),
            1.0 - 2 * (math.pow(f32, rot.data[1], 2.0) + math.pow(f32, rot.data[2], 2.0)),
        },
    };

    return .{
        .fields = result,
    };
}

pub fn createScale(scale: vec3.Vector3) Mat3 {
    return .{
        .fields = [3]@Vector(3, f32){
            @Vector(4, f32){ scale.data[0], 0.0, 0.0 },
            @Vector(4, f32){ 0.0, scale.data[1], 0.0 },
            @Vector(4, f32){ 0.0, 0.0, scale.data[2] },
        },
    };
}
