pub const Type = enum {
    mat4,
    quaternion,
    vector2,
    vector3,
};

pub fn assertType(comptime other: type, comptime expected: Type) void {
    switch (@typeInfo(other)) {
        .@"struct" => {},
        else => @compileError("Unexpected type was given: " ++ @typeName(other) ++ "."),
    }

    if (!@hasDecl(other, "type") or other.type != expected)
        @compileError("Unexpected type was given: " ++ @typeName(other) ++ ".");
}

pub fn assertCompatible(InnerType: type, comptime other: type, comptime expected: Type) void {
    switch (@typeInfo(other)) {
        .@"struct" => {},
        else => @compileError("Unexpected type was given: " ++ @typeName(other) ++ "."),
    }

    if (!@hasDecl(other, "InnerType") or InnerType != other.InnerType)
        @compileError("Unexpected type was given: " ++ @typeName(other) ++ ".");

    if (!@hasDecl(other, "type") or other.type != expected)
        @compileError("Unexpected type was given: " ++ @typeName(other) ++ ".");
}
