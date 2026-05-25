const AxisType = @import("axis.zig").AxisType;
const Type = @import("type.zig").Type;

pub fn Quaternion(comptime T: type, Unique: type) type {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type."),
    }

    switch (@typeInfo(Unique)) {
        .@"opaque" => {},
        else => @compileError("Unexpected type was given: " ++ @typeName(Unique) ++ ", expected an opaque"),
    }

    return struct {
        fields: @Vector(4, T),

        const _unique = Unique;

        const Self = @This();

        pub const InnerType = T;
        pub const @"type": Type = .quaternion;

        pub const identity: Self = .{ .fields = @Vector(4, T){ 1, 0, 0, 0 } };

        fn assertCompatible(comptime other: type, comptime expected: Type) void {
            switch (@typeInfo(other)) {
                .@"struct" => {},
                else => @compileError("Unexpected type was given: " ++ @typeName(other) ++ "."),
            }

            if (!@hasDecl(other, "InnerType") or InnerType != other.InnerType)
                @compileError("Unexpected type was given: " ++ @typeName(other) ++ ".");

            if (!@hasDecl(other, "type") or @TypeOf(other.type) != Type or other.type != expected)
                @compileError("Unexpected type was given: " ++ @typeName(other) ++ ".");
        }

        pub fn initFromRadians(comptime axis: AxisType, radians: T) Self {
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
        pub fn initFromVector(vector: anytype) Self {
            assertCompatible(@TypeOf(vector), .vector3);

            return multiply(multiply(initFromRadians(.x, vector.x), initFromRadians(.y, vector.y)), initFromRadians(.z, vector.z));
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

        pub fn addRotationAroundAxis(self: Self, comptime axis: AxisType, radians: T) Self {
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
        pub fn multiply(quat1: Self, quat2: anytype) Self {
            assertCompatible(@TypeOf(quat2), .quaternion);

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
