const Vector3 = @import("vector3.zig").Vector3;
const Quaternion = @import("quaternion.zig").Quaternion;
const Vector2 = @import("vector2.zig").Vector2;
const Mat4 = @import("mat4.zig").Mat4;

pub const Axis = enum {
    y,
    x,
    z,
};

pub const PI: f32 = 3.141592;

pub const Quat = struct {
    pub const IDENTITY: Quaternion = .{ .fields = @Vector(4, f32){ 1, 0, 0, 0 } };
};

pub const Matrix4 = struct {
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
};

pub const Vec3 = struct {
    pub const ZERO: Vector3 = .{ .x = 0.0, .y = 0.0, .z = 0.0 };
    pub const ONE: Vector3 = .{ .x = 1.0, .y = 1.0, .z = 1.0 };
    pub const UP: Vector3 = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
    pub const RIGHT: Vector3 = .{ .x = 1.0, .y = 0.0, .z = 0.0 };
    pub const FORWARD: Vector3 = .{ .x = 0.0, .y = 0.0, .z = 1.0 };
};

pub const Vec2 = struct {
    pub const ZERO: Vector2 = .{ .x = 0.0, .y = 0.0 };
    pub const ONE: Vector2 = .{ .x = 1.0, .y = 1.0 };
    pub const UP: Vector2 = .{ .x = 0.0, .y = 1.0 };
    pub const RIGHT: Vector2 = .{ .x = 1.0, .y = 0.0 };
};
