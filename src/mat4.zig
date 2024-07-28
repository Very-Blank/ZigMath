const std = @import("std");
const vec3 = @import("vector3.zig");
const quat = @import("quaternion.zig");

/// zero matrix.
pub const ZERO = Mat4{
    .fields = [4]@Vector(4, f32){
        @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
        @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
        @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
        @Vector(4, f32){ 0.0, 0.0, 0.0, 0.0 },
    },
};

pub const IDENTITY = Mat4{
    .fields = [4]@Vector(4, f32){
        @Vector(4, f32){ 1.0, 0.0, 0.0, 0.0 },
        @Vector(4, f32){ 0.0, 1.0, 0.0, 0.0 },
        @Vector(4, f32){ 0.0, 0.0, 1.0, 0.0 },
        @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
    },
};

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

    pub fn setRotation(self: *Mat4, rot: quat.Quaternion) void {
        // 2 * (rot.data[1] * rot.data[2] + rot.data[3] * rot.data[0])
        //
        // 2 * (rot.data[1] * rot.data[3] + rot.data[2] * rot.data[0])
        //
        // 2 * (rot.data[2] * rot.data[3] + rot.data[1] * rot.data[0])

        //row major
        self.fields = [4]@Vector(4, f32){
            // @Vector(4, f32){ 1.0 - 2 * (@exp2(rot.data[2]) + @exp2(rot.data[3])), 2 * (rot.data[1] * rot.data[2] + rot.data[3] * rot.data[0]), 2 * (rot.data[1] * rot.data[3] - rot.data[2] * rot.data[0]), 0.0 },
            // @Vector(4, f32){ 2 * (rot.data[1] * rot.data[2] - rot.data[3] * rot.data[0]), 1.0 - 2 * (@exp2(rot.data[1]) + @exp2(rot.data[3])), 2 * (rot.data[2] * rot.data[3] + rot.data[1] * rot.data[0]), 0.0 },
            // @Vector(4, f32){ 2 * (rot.data[1] * rot.data[3] + rot.data[2] * rot.data[0]), 2 * (rot.data[2] * rot.data[3] - rot.data[1] * rot.data[0]), 1.0 - 2 * (@exp2(rot.data[1]) + @exp2(rot.data[2])), 0.0 },
            // @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        };

        //column major
        self.fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0 - 2 * (@exp2(rot.data[2]) + @exp2(rot.data[3])), 2 * (rot.data[1] * rot.data[2] - rot.data[3] * rot.data[0]), 2 * (rot.data[1] * rot.data[3] + rot.data[2] * rot.data[0]), 0.0 },
            @Vector(4, f32){ 2 * (rot.data[1] * rot.data[2] + rot.data[3] * rot.data[0]), 1.0 - 2 * (@exp2(rot.data[1]) + @exp2(rot.data[3])), 2 * (rot.data[2] * rot.data[3] - rot.data[1] * rot.data[0]), 0.0 },
            @Vector(4, f32){ 2 * (rot.data[1] * rot.data[3] + rot.data[2] * rot.data[0]), 2 * (rot.data[2] * rot.data[3] + rot.data[1] * rot.data[0]), 1.0 - 2 * (@exp2(rot.data[1]) + @exp2(rot.data[2])), 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        };
    }

    pub fn setScale(self: *Mat4, scale: vec3.Vector3) void {
        self.fields = [4]@Vector(4, f32){
            @Vector(4, f32){ scale.data[0], 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, scale.data[1], 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, scale.data[2], 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        };
    }

    pub fn setTranslate(self: *Mat4, vector: vec3.Vector3) void {
        self.fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 1.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 1.0, 0.0 },
            @Vector(4, f32){ vector.data[0], vector.data[1], vector.data[2], 1.0 },
        };
    }
};

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

pub fn createRotation(rot: quat.Quaternion) Mat4 {
    return .{
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0 - 2 * (@exp2(rot.data[2]) + @exp2(rot.data[3])), 2 * (rot.data[1] * rot.data[2] + rot.data[3] * rot.data[0]), 2 * (rot.data[1] * rot.data[3] - rot.data[2] * rot.data[0]), 0.0 },
            @Vector(4, f32){ 2 * (rot.data[1] * rot.data[2] - rot.data[3] * rot.data[0]), 1.0 - 2 * (@exp2(rot.data[1]) + @exp2(rot.data[3])), 2 * (rot.data[2] * rot.data[3] + rot.data[1] * rot.data[0]), 0.0 },
            @Vector(4, f32){ 2 * (rot.data[1] * rot.data[3] + rot.data[2] * rot.data[0]), 2 * (rot.data[2] * rot.data[3] - rot.data[1] * rot.data[0]), 1.0 - 2 * (@exp2(rot.data[1]) + @exp2(rot.data[2])), 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        },
    };
}

pub fn createScale(scale: vec3.Vector3) Mat4 {
    return .{
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ scale.data[0], 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, scale.data[1], 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, scale.data[2], 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 },
        },
    };
}

pub fn createTranslate(vector: vec3.Vector3) Mat4 {
    return .{
        .fields = [4]@Vector(4, f32){
            @Vector(4, f32){ 1.0, 0.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 1.0, 0.0, 0.0 },
            @Vector(4, f32){ 0.0, 0.0, 1.0, 0.0 },
            @Vector(4, f32){ vector.data[0], vector.data[1], vector.data[2], 1.0 },
        },
    };
}

// pub fn createOrhtoPerspective(fov: f32, aspect: f32, near: f32, far: f32) Mat4 {
// }

//just a shortcuts, they are used alot so
pub inline fn createView(position: vec3.Vector3, rotation: quat.Quaternion) Mat4 {
    return multiply(createTranslate(position), createRotation(rotation));
}

pub inline fn createModel(position: vec3.Vector3, scale: vec3.Vector3, rotation: quat.Quaternion) Mat4 {
    return multiply(multiply(createTranslate(position), createRotation(rotation)), createScale(scale));
}
