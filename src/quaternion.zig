const std = @import("std");
const constants = @import("constants.zig");
const vec3 = @import("vector3.zig");

pub const IDENTITY: Quaternion = .{ .data = @Vector(4, f32){ 1, 0, 0, 0 } };

pub const Quaternion = struct {
    data: @Vector(4, f32),

    pub fn setFromAngle(radians: f32, axis: constants.Axis) void {
        switch (axis) {
            .x => {
                return .{
                    .data = @Vector(4, f32){ @cos(radians / 2), @sin(radians / 2), 0, 0 },
                };
            },
            .y => {
                return .{
                    .data = @Vector(4, f32){ @cos(radians / 2), 0, @sin(radians / 2), 0 },
                };
            },
            .z => {
                return .{
                    .data = @Vector(4, f32){ @cos(radians / 2), 0, 0, @sin(radians / 2) },
                };
            },
        }
    }

    // Uses x, y, z order
    pub fn setFromVector(self: *Quaternion, vector3: vec3.Vector3) void {
        self.setMultiply(multiply(createFromRadians(vector3.x, constants.Axis.x), createFromRadians(vector3.y, constants.Axis.y)), createFromRadians(vector3.z, constants.Axis.z));
    }

    // Hamilton product
    pub fn setMultiply(self: *Quaternion, other: Quaternion) void {
        self.data = @Vector(4, f32){
            self.data[0] * other.data[0] - self.data[1] * other.data[1] - self.data[2] * other.data[2] - self.data[3] * other.data[3],
            self.data[0] * other.data[1] + self.data[1] * other.data[0] + self.data[2] * other.data[3] - self.data[3] * other.data[2],
            self.data[0] * other.data[2] - self.data[1] * other.data[3] + self.data[2] * other.data[0] + self.data[3] * other.data[1],
            self.data[0] * other.data[3] + self.data[1] * other.data[2] - self.data[2] * other.data[1] + self.data[3] * other.data[0],
        };
    }
};

pub fn createFromRadians(radians: f32, axis: constants.Axis) Quaternion {
    switch (axis) {
        .x => {
            return .{
                .data = @Vector(4, f32){ @cos(radians / 2), @sin(radians / 2), 0, 0 },
            };
        },
        .y => {
            return .{
                .data = @Vector(4, f32){ @cos(radians / 2), 0, @sin(radians / 2), 0 },
            };
        },
        .z => {
            return .{
                .data = @Vector(4, f32){ @cos(radians / 2), 0, 0, @sin(radians / 2) },
            };
        },
    }
}

// Uses x, y, z order
pub fn createFromVector(vector3: vec3.Vector3) Quaternion {
    return multiply(multiply(createFromRadians(vector3.x, constants.Axis.x), createFromRadians(vector3.y, constants.Axis.y)), createFromRadians(vector3.z, constants.Axis.z));
}

// Hamilton product
pub fn multiply(quat1: Quaternion, quat2: Quaternion) Quaternion {
    return .{
        .data = @Vector(4, f32){
            quat1.data[0] * quat2.data[0] - quat1.data[1] * quat2.data[1] - quat1.data[2] * quat2.data[2] - quat1.data[3] * quat2.data[3],
            quat1.data[0] * quat2.data[1] + quat1.data[1] * quat2.data[0] + quat1.data[2] * quat2.data[3] - quat1.data[3] * quat2.data[2],
            quat1.data[0] * quat2.data[2] - quat1.data[1] * quat2.data[3] + quat1.data[2] * quat2.data[0] + quat1.data[3] * quat2.data[1],
            quat1.data[0] * quat2.data[3] + quat1.data[1] * quat2.data[2] - quat1.data[2] * quat2.data[1] + quat1.data[3] * quat2.data[0],
        },
    };
}
