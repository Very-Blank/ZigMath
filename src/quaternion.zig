const std = @import("std");
const AxisType = @import("axis.zig").AxisType;
const Type = @import("type.zig").Type;
const assertCompatible = @import("type.zig").assertCompatible;

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
            assertCompatible(InnerType, @TypeOf(vector), .vector3);

            return multiply(multiply(initFromRadians(.x, vector.x), initFromRadians(.y, vector.y)), initFromRadians(.z, vector.z));
        }

        // From: https://github.com/g-truc/glm
        pub fn initFromMatrix(mat: anytype) Self {
            assertCompatible(InnerType, @TypeOf(mat), .mat4);
            var quaternion: Self = undefined;

            const trace: T = mat.fields[0][0] + mat.fields[1][1] + mat.fields[2][2];
            var root: T = trace;

            if (0 < trace) {
                root = @sqrt(trace + 1.0);
                quaternion.fields[0] = 0.5 * root;
                root = 0.5 / root;
                quaternion.fields[1] = root * (mat.fields[1][2] - mat.fields[2][1]);
                quaternion.fields[2] = root * (mat.fields[2][0] - mat.fields[0][2]);
                quaternion.fields[3] = root * (mat.fields[0][1] - mat.fields[1][0]);
            } else {
                const next: [3]usize = .{ 1, 2, 0 };
                var i: usize = 0;
                if (mat.fields[1][1] > mat.fields[0][0]) i = 1;
                if (mat.fields[2][2] > mat.fields[i][i]) i = 2;
                const j: usize = next[i];
                const k: usize = next[j];

                root = @sqrt(mat.fields[i][i] - mat.fields[j][j] - mat.fields[k][k] + 1.0);

                var fields: [4]T = undefined;

                fields[i + 1] = 0.5 * root;
                root = 0.5 / root;
                fields[j + 1] = root * (mat.fields[i][j] + mat.fields[j][i]);
                fields[k + 1] = root * (mat.fields[i][k] + mat.fields[k][i]);
                fields[0] = root * (mat.fields[j][k] - mat.fields[k][j]);

                quaternion.fields = fields;
            }

            return quaternion;
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

        pub fn addAroundAxis(self: Self, comptime axis: AxisType, radians: T) Self {
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

        pub fn extractAxis(self: Self, comptime axis: AxisType) T {
            return switch (axis) {
                .x => std.math.atan2(
                    2.0 * (self.fields[2] * self.fields[3] + self.fields[0] * self.fields[1]),
                    self.fields[0] * self.fields[0] - self.fields[1] * self.fields[1] - self.fields[2] * self.fields[2] + self.fields[3] * self.fields[3],
                ),
                .y => std.math.asin(
                    -2.0 * (self.fields[1] * self.fields[3] - self.fields[0] * self.fields[2]),
                ),
                .z => std.math.atan2(
                    2.0 * (self.fields[1] * self.fields[2] + self.fields[0] * self.fields[3]),
                    self.fields[0] * self.fields[0] + self.fields[1] * self.fields[1] - self.fields[2] * self.fields[2] - self.fields[3] * self.fields[3],
                ),
            };
        }

        // Hamilton product
        pub fn multiply(quat1: Self, quat2: anytype) Self {
            assertCompatible(InnerType, @TypeOf(quat2), .quaternion);

            return .{
                .fields = @Vector(4, T){
                    quat1.fields[0] * quat2.fields[0] - quat1.fields[1] * quat2.fields[1] - quat1.fields[2] * quat2.fields[2] - quat1.fields[3] * quat2.fields[3],
                    quat1.fields[0] * quat2.fields[1] + quat1.fields[1] * quat2.fields[0] + quat1.fields[2] * quat2.fields[3] - quat1.fields[3] * quat2.fields[2],
                    quat1.fields[0] * quat2.fields[2] - quat1.fields[1] * quat2.fields[3] + quat1.fields[2] * quat2.fields[0] + quat1.fields[3] * quat2.fields[1],
                    quat1.fields[0] * quat2.fields[3] + quat1.fields[1] * quat2.fields[2] - quat1.fields[2] * quat2.fields[1] + quat1.fields[3] * quat2.fields[0],
                },
            };
        }

        pub fn normalize(self: Self) Self {
            const magnitude: T = self.fields[0] * self.fields[0] + self.fields[1] * self.fields[1] + self.fields[2] * self.fields[2] + self.fields[3] * self.fields[3];
            const scale: T = if (@abs(1.0 - magnitude) < 2.107342e-08) 2.0 / (1.0 + magnitude) else 1.0 / @sqrt(magnitude);

            return .{
                .fields = .{ self.fields[0] * scale, self.fields[1] * scale, self.fields[2] * scale, self.fields[3] * scale },
            };
        }
    };
}
