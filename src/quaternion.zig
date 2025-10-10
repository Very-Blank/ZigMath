const Vector3 = @import("vector3.zig").Vector3;
const AxisType = @import("axis.zig").AxisType;

pub fn Quaternion(comptime T: type) type {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    return struct {
        fields: @Vector(4, T),

        pub const identity: Self = .{ .fields = @Vector(4, T){ 1, 0, 0, 0 } };

        const Self = @This();

        pub fn initFromRadians(radians: T, axis: AxisType) Self {
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
        pub fn initFromVector(vector: Vector3) Self {
            return multiply(multiply(initFromRadians(vector.x, .x), initFromRadians(vector.y, .y)), initFromRadians(vector.z, .z));
        }

        pub fn initCamRotation(yaw: T, pitch: T) Self {
            const yawn_w = @cos(yaw / 2);
            const yawn_y = @sin(yaw / 2);

            const pitch_w = @cos(pitch / 2);
            const pitch_x = @sin(pitch / 2);

            return .{
                .fields = @Vector(4, T){
                    pitch_w * yawn_w,
                    pitch_x * yawn_w,
                    pitch_w * yawn_y,
                    pitch_x * yawn_y,
                },
            };
        }

        pub fn addRotationAroundAxis(self: Self, radians: T, comptime axis: AxisType) Self {
            const rad_cos = @cos(radians / 2);
            const rad_sin = @sin(radians / 2);

            return switch (axis) {
                .x => .{
                    .fields = @Vector(4, T){
                        rad_cos * self.fields[0] - rad_sin * self.fields[1],
                        rad_cos * self.fields[1] + rad_sin * self.fields[0],
                        rad_cos * self.fields[2] - rad_sin * self.fields[3],
                        rad_cos * self.fields[3] + rad_sin * self.fields[2],
                    },
                },
                .y => .{
                    .fields = @Vector(4, T){
                        rad_cos * self.fields[0] - rad_sin * self.fields[2],
                        rad_cos * self.fields[1] + rad_sin * self.fields[3],
                        rad_cos * self.fields[2] + rad_sin * self.fields[0],
                        rad_cos * self.fields[3] - rad_sin * self.fields[1],
                    },
                },
                .z => .{
                    .fields = @Vector(4, T){
                        rad_cos * self.fields[0] - rad_sin * self.fields[3],
                        rad_cos * self.fields[1] - rad_sin * self.fields[2],
                        rad_cos * self.fields[2] + rad_sin * self.fields[1],
                        rad_cos * self.fields[3] + rad_sin * self.fields[0],
                    },
                },
            };
        }

        // Hamilton product
        pub fn multiply(quat1: Self, quat2: Self) Self {
            return .{
                .fields = @Vector(4, T){
                    quat1.fields[0] * quat2.fields[0] - quat1.fields[1] * quat2.fields[1] - quat1.fields[2] * quat2.fields[2] - quat1.fields[3] * quat2.fields[3],
                    quat1.fields[0] * quat2.fields[1] + quat1.fields[1] * quat2.fields[0] + quat1.fields[2] * quat2.fields[3] - quat1.fields[3] * quat2.fields[2],
                    quat1.fields[0] * quat2.fields[2] - quat1.fields[1] * quat2.fields[3] + quat1.fields[2] * quat2.fields[0] + quat1.fields[3] * quat2.fields[1],
                    quat1.fields[0] * quat2.fields[3] + quat1.fields[1] * quat2.fields[2] - quat1.fields[2] * quat2.fields[1] + quat1.fields[3] * quat2.fields[0],
                },
            };
        }
    };
}
