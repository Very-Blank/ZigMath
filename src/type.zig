pub const Type = enum {
    mat4,
    quaternion,
    vector2,
    vector3,
};

pub fn assertCompatible(comptime other: type, comptime expected: Type) void {
    switch (@typeInfo(other)) {
        .@"struct" => {},
        else => @compileError("Unexpected type was given: " ++ @typeName(other) ++ "."),
    }

    if (!@hasDecl(other, "InnerType") or expected != other.InnerType)
        @compileError("Unexpected type was given: " ++ @typeName(other) ++ ".");
}
