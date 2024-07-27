const std = @import("std");
const constants = @import("constants.zig");

pub const ZERO = Vector3.init(0, 0, 0);
pub const UP = Vector3.init(0, 1, 0);
pub const RIGHT = Vector3.init(1, 0, 0);
pub const FORWARD = Vector3.init(0, 0, 1);

pub const Vector3 = struct {
    data: @Vector(3, f32),

    pub inline fn floatSet(self: *Vector3, floatx: f32, floaty: f32, floatz: f32) void {
        self.data = @Vector(3, f32){ floatx, floaty, floatz };
    }

    pub inline fn vectorSet(self: *Vector3, vector: Vector3) void {
        self.data = vector.data;
    }

    pub inline fn dataSet(self: *Vector3, data: @Vector(3, f32)) void {
        self.data = data;
    }

    pub inline fn setAdd(self: *Vector3, other: Vector3) void {
        self.data += other.data;
    }

    pub inline fn setSubtract(self: *Vector3, other: Vector3) void {
        self.data -= other.data;
    }

    pub inline fn setMultiply(self: *Vector3, other: Vector3) void {
        self.data *= other.data;
    }

    pub inline fn setDivide(self: *Vector3, other: Vector3) void {
        self.data /= other.data;
    }

    pub inline fn setScale(self: *Vector3, other: f32) void {
        self.data *= other;
    }

    pub inline fn setSegment(self: *Vector3, other: f32) void {
        self.data /= other;
    }

    pub inline fn setNegate(self: *Vector3) void {
        self.data = -self.data;
    }

    // pub inline fn rotate(self: *Vector3, other: quaternion) void {
    //     self.x /= other;
    // }
    //
    // pub inline fn rotateOnAxis(self: *Vector3, axis: constants.Axis) void {
    //     self.x /= other;
    // }
};

pub inline fn floatCreate(floatx: f32, floaty: f32, floatz: f32) Vector3 {
    return .{
        .data = @Vector(3, f32){ floatx, floaty, floatz },
    };
}

pub inline fn vectorCreate(vector: Vector3) Vector3 {
    return .{
        .data = vector.data,
    };
}

pub inline fn dataCreate(data: @Vector(3, f32)) Vector3 {
    return .{
        .data = data,
    };
}

pub inline fn add(vec1: Vector3, vec2: Vector3) Vector3 {
    return Vector3.dataInit(vec1.data + vec2.data);
}

pub inline fn subtract(vec1: Vector3, vec2: Vector3) Vector3 {
    return Vector3.dataInit(vec1.data - vec2.data);
}

pub inline fn multiply(vec1: Vector3, vec2: Vector3) Vector3 {
    return Vector3.dataInit(vec1.data * vec2.data);
}

pub inline fn divide(vec1: Vector3, vec2: Vector3) Vector3 {
    return Vector3.dataInit(vec1.data / vec2.data);
}

pub inline fn scale(vec1: Vector3, float: f32) void {
    return Vector3.dataInit(vec1.data * float);
}

pub inline fn segment(vec1: Vector3, float: f32) void {
    return Vector3.dataInit(vec1.data / float);
}

pub inline fn negate(vec1: Vector3) Vector3 {
    return Vector3.dataInit(-vec1.data);
}
