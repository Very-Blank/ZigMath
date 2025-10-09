const Vector3 = @import("vector3.zig").Vector3;
const AxisType = @import("axis.zig").AxisType;

pub fn Quaternion(comptime T: type) type {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    return struct {
        fields: @Vector(4, T),

        pub const identity: Quaternion(T) = .{ .fields = @Vector(4, T){ 1, 0, 0, 0 } };

        pub fn initFromRadians(radians: T, axis: AxisType) Quaternion(T) {
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
        pub fn initFromVector(vector: Vector3) Quaternion(T) {
            return multiply(multiply(initFromRadians(vector.x, AxisType.x), initFromRadians(vector.y, AxisType.y)), initFromRadians(vector.z, AxisType.z));
        }

        pub fn initCamRotation(yaw: T, pitch: T) Quaternion(T) {
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

            // return .{
            //     .fields = @Vector(4, T){
            //         yawn_w * pitch_w,
            //         yawn_w * pitch_x,
            //         yawn_y * pitch_w,
            //         -yawn_y * pitch_x,
            //     },
            // };
        }

        // Hamilton product
        pub fn multiply(quat1: Quaternion(T), quat2: Quaternion(T)) Quaternion(T) {
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
