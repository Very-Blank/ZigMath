const constants = @import("constants.zig");
const Vector3 = @import("vector3.zig").Vector3;

pub const Quaternion = struct {
    fields: @Vector(4, f32),

    pub fn setFromAngle(radians: f32, axis: constants.Axis) void {
        switch (axis) {
            .x => {
                return .{
                    .fields = @Vector(4, f32){ @cos(radians / 2), @sin(radians / 2), 0, 0 },
                };
            },
            .y => {
                return .{
                    .fields = @Vector(4, f32){ @cos(radians / 2), 0, @sin(radians / 2), 0 },
                };
            },
            .z => {
                return .{
                    .fields = @Vector(4, f32){ @cos(radians / 2), 0, 0, @sin(radians / 2) },
                };
            },
        }
    }

    // Uses x, y, z order
    pub fn setFromVector(self: *Quaternion, vector: Vector3) void {
        self.setMultiply(multiply(createFromRadians(vector.x, constants.Axis.x), createFromRadians(vector.y, constants.Axis.y)), createFromRadians(vector.z, constants.Axis.z));
    }

    // Hamilton product
    pub fn setMultiply(self: *Quaternion, other: Quaternion) void {
        self.fields = @Vector(4, f32){
            self.fields[0] * other.fields[0] - self.fields[1] * other.fields[1] - self.fields[2] * other.fields[2] - self.fields[3] * other.fields[3],
            self.fields[0] * other.fields[1] + self.fields[1] * other.fields[0] + self.fields[2] * other.fields[3] - self.fields[3] * other.fields[2],
            self.fields[0] * other.fields[2] - self.fields[1] * other.fields[3] + self.fields[2] * other.fields[0] + self.fields[3] * other.fields[1],
            self.fields[0] * other.fields[3] + self.fields[1] * other.fields[2] - self.fields[2] * other.fields[1] + self.fields[3] * other.fields[0],
        };
    }

    pub fn createFromRadians(radians: f32, axis: constants.Axis) Quaternion {
        switch (axis) {
            .x => {
                return .{
                    .fields = @Vector(4, f32){ @cos(radians / 2), @sin(radians / 2), 0, 0 },
                };
            },
            .y => {
                return .{
                    .fields = @Vector(4, f32){ @cos(radians / 2), 0, @sin(radians / 2), 0 },
                };
            },
            .z => {
                return .{
                    .fields = @Vector(4, f32){ @cos(radians / 2), 0, 0, @sin(radians / 2) },
                };
            },
        }
    }

    // Uses x, y, z order
    pub fn createFromVector(vector: Vector3) Quaternion {
        return multiply(multiply(createFromRadians(vector.x, constants.Axis.x), createFromRadians(vector.y, constants.Axis.y)), createFromRadians(vector.z, constants.Axis.z));
    }

    // Hamilton product
    pub fn multiply(quat1: Quaternion, quat2: Quaternion) Quaternion {
        return .{
            .data = @Vector(4, f32){
                quat1.fields[0] * quat2.fields[0] - quat1.fields[1] * quat2.fields[1] - quat1.fields[2] * quat2.fields[2] - quat1.fields[3] * quat2.fields[3],
                quat1.fields[0] * quat2.fields[1] + quat1.fields[1] * quat2.fields[0] + quat1.fields[2] * quat2.fields[3] - quat1.fields[3] * quat2.fields[2],
                quat1.fields[0] * quat2.fields[2] - quat1.fields[1] * quat2.fields[3] + quat1.fields[2] * quat2.fields[0] + quat1.fields[3] * quat2.fields[1],
                quat1.fields[0] * quat2.fields[3] + quat1.fields[1] * quat2.fields[2] - quat1.fields[2] * quat2.fields[1] + quat1.fields[3] * quat2.fields[0],
            },
        };
    }
};
