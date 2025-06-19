const Vector3 = @import("vector3.zig").Vector3;

pub const Axis = enum { x, y, z };

pub fn Quaternion(comptime T: type) type {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    return struct {
        fields: @Vector(4, T),

        pub const IDENTITY: Quaternion = .{ .fields = @Vector(4, f32){ 1, 0, 0, 0 } };

        pub fn setFromAngle(radians: T, axis: Axis) void {
            switch (axis) {
                .x => {
                    return .{
                        .fields = @Vector(4, T){ @cos(radians / 2), @sin(radians / 2), 0, 0 },
                    };
                },
                .y => {
                    return .{
                        .fields = @Vector(4, T){ @cos(radians / 2), 0, @sin(radians / 2), 0 },
                    };
                },
                .z => {
                    return .{
                        .fields = @Vector(4, T){ @cos(radians / 2), 0, 0, @sin(radians / 2) },
                    };
                },
            }
        }

        // Uses x, y, z order
        pub fn setFromVector(self: *Quaternion(T), vector: Vector3) void {
            self.setMultiply(multiply(createFromRadians(vector.x, Axis.x), createFromRadians(vector.y, Axis.y)), createFromRadians(vector.z, Axis.z));
        }

        // Hamilton product
        pub fn setMultiply(self: *Quaternion(T), other: Quaternion(T)) void {
            self.fields = @Vector(4, T){
                self.fields[0] * other.fields[0] - self.fields[1] * other.fields[1] - self.fields[2] * other.fields[2] - self.fields[3] * other.fields[3],
                self.fields[0] * other.fields[1] + self.fields[1] * other.fields[0] + self.fields[2] * other.fields[3] - self.fields[3] * other.fields[2],
                self.fields[0] * other.fields[2] - self.fields[1] * other.fields[3] + self.fields[2] * other.fields[0] + self.fields[3] * other.fields[1],
                self.fields[0] * other.fields[3] + self.fields[1] * other.fields[2] - self.fields[2] * other.fields[1] + self.fields[3] * other.fields[0],
            };
        }

        pub fn createFromRadians(radians: T, axis: Axis) Quaternion(T) {
            switch (axis) {
                .x => {
                    return .{
                        .fields = @Vector(4, T){ @cos(radians / 2), @sin(radians / 2), 0, 0 },
                    };
                },
                .y => {
                    return .{
                        .fields = @Vector(4, T){ @cos(radians / 2), 0, @sin(radians / 2), 0 },
                    };
                },
                .z => {
                    return .{
                        .fields = @Vector(4, T){ @cos(radians / 2), 0, 0, @sin(radians / 2) },
                    };
                },
            }
        }

        // Uses x, y, z order
        pub fn createFromVector(vector: Vector3) Quaternion(T) {
            return multiply(multiply(createFromRadians(vector.x, Axis.x), createFromRadians(vector.y, Axis.y)), createFromRadians(vector.z, Axis.z));
        }

        // Hamilton product
        pub fn multiply(quat1: Quaternion(T), quat2: Quaternion(T)) Quaternion(T) {
            return .{
                .data = @Vector(4, T){
                    quat1.fields[0] * quat2.fields[0] - quat1.fields[1] * quat2.fields[1] - quat1.fields[2] * quat2.fields[2] - quat1.fields[3] * quat2.fields[3],
                    quat1.fields[0] * quat2.fields[1] + quat1.fields[1] * quat2.fields[0] + quat1.fields[2] * quat2.fields[3] - quat1.fields[3] * quat2.fields[2],
                    quat1.fields[0] * quat2.fields[2] - quat1.fields[1] * quat2.fields[3] + quat1.fields[2] * quat2.fields[0] + quat1.fields[3] * quat2.fields[1],
                    quat1.fields[0] * quat2.fields[3] + quat1.fields[1] * quat2.fields[2] - quat1.fields[2] * quat2.fields[1] + quat1.fields[3] * quat2.fields[0],
                },
            };
        }
    };
}
