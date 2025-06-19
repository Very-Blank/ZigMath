pub const Vector2 = @import("vector2.zig").Vector2;
pub const Vector3 = @import("vector3.zig").Vector3;
pub const Mat4 = @import("mat4.zig").Mat4;
pub const Quaternion = @import("quaternion.zig").Quaternion;
pub const Axis = @import("quaternion.zig").Axis;

const @"f32" = struct {
    pub const Vector2 = @import("vector2.zig").Vector2(f32);
    pub const Vector3 = @import("vector3.zig").Vector3(f32);
    pub const Mat4 = @import("mat4.zig").Mat4(f32);
    pub const Quaternion = @import("quaternion.zig").Quaternion(f32);
};
