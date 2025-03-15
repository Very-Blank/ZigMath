pub fn pow2(comptime T: type, num: T) T {
    switch (@typeInfo(T)) {
        .int, .float, .comptime_float, .comptime_int => return num * num,
        else => @compileError("Type not supported. Was given " ++ @typeName(T) ++ " type"),
    }
}
