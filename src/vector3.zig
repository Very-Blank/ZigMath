const std = @import("std");
const math = std.math;
const constants = @import("constants.zig");
const quat = @import("quaternion.zig");

pub const ZERO: Vector3 = .{ .data = @Vector(3, f32){ 0.0, 0.0, 0.0 } };
pub const UP: Vector3 = .{ .data = @Vector(3, f32){ 0.0, 1.0, 0.0 } };
pub const RIGHT: Vector3 = .{ .data = @Vector(3, f32){ 1.0, 0.0, 0.0 } };
pub const FORWARD: Vector3 = .{ .data = @Vector(3, f32){ 0.0, 0.0, 1.0 } };

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

    pub inline fn setCross(self: *Vector3, other: Vector3) void {
        self.data = @Vector(3, f32){ (self.data[1] * other.data[2] - self.data[2] * other.data[1]), (self.data[2] * other.data[0] - self.data[0] * other.data[2]), (self.data[0] * other.data[1] - self.data[1] * other.data[0]) };
    }

    pub inline fn setCrossData(self: @Vector(3, f32), vec2: @Vector(3, f32)) void {
        self.data = @Vector(3, f32){ (self.data[1] * vec2[2] - self.data[2] * vec2.data[1]), (self.data[2] * vec2[0] - self.data[0] * vec2[2]), (self.data[0] * vec2[1] - self.data[1] * vec2[0]) };
    }

    pub inline fn setRotate(self: *Vector3, rot: quat.Quaternion) void {
        const rot_vec = @Vector(3, f32){ rot[1], rot[2], rot[3] };
        self.data = self.data + ((crossData(rot_vec, self.data) * rot[0]) + (crossData(rot_vec, (crossData(rot_vec, self.data))))) * 2.0;
    }
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
    return .{
        .data = vec1.data + vec2.data,
    };
}

pub inline fn subtract(vec1: Vector3, vec2: Vector3) Vector3 {
    return .{
        .data = vec1.data - vec2.data,
    };
}

pub inline fn multiply(vec1: Vector3, vec2: Vector3) Vector3 {
    return .{
        .data = vec1.data * vec2.data,
    };
}

pub inline fn divide(vec1: Vector3, vec2: Vector3) Vector3 {
    return .{
        .data = vec1.data / vec2.data,
    };
}

pub inline fn scale(vec1: Vector3, float: f32) void {
    return .{
        .data = vec1.data + float,
    };
}

pub inline fn segment(vec1: Vector3, float: f32) void {
    return .{
        .data = vec1.data / float,
    };
}

pub inline fn negate(vec1: Vector3) Vector3 {
    return .{
        .data = -vec1.data,
    };
}

pub inline fn dot(vec1: Vector3, vec2: Vector3) f32 {
    return vec1.data[0] * vec2.data[0] + vec1.data[1] * vec2.data[1] + vec1.data[2] * vec2.data[2];
}

pub inline fn dotData(vec1: @Vector(3, f32), vec2: @Vector(3, f32)) f32 {
    return vec1[0] * vec2[0] + vec1[1] * vec2[1] + vec1[2] * vec2[2];
}

pub inline fn cross(vec1: Vector3, vec2: Vector3) Vector3 {
    return .{ .data = @Vector(3, f32){ (vec1.data[1] * vec2.data[2] - vec1.data[2] * vec2.data[1]), (vec1.data[2] * vec2.data[0] - vec1.data[0] * vec2.data[2]), (vec1.data[0] * vec2.data[1] - vec1.data[1] * vec2.data[0]) } };
}

pub inline fn crossData(vec1: @Vector(3, f32), vec2: @Vector(3, f32)) @Vector(3, f32) {
    return @Vector(3, f32){ (vec1[1] * vec2[2] - vec1[2] * vec2[1]), (vec1[2] * vec2[0] - vec1[0] * vec2[2]), (vec1[0] * vec2[1] - vec1[1] * vec2[0]) };
}

pub inline fn rotate(vec1: Vector3, rot: quat.Quaternion) Vector3 {
    const rot_vec = @Vector(3, f32){ rot[1], rot[2], rot[3] };
    vec1.data = vec1.data + ((crossData(rot_vec, vec1.data) * rot[0]) + (crossData(rot_vec, (crossData(rot_vec, vec1.data))))) * 2.0;
}

pub inline fn length(vec1: Vector3) f32 {
    return @sqrt(math.pow(f32, vec1.data[0], 2.0) + math.pow(f32, vec1.data[1], 2.0) + math.pow(f32, vec1.data[2], 2.0));
}

pub inline fn distance(vec1: Vector3, vec2: Vector3) f32 {
    return @sqrt(math.pow(f32, vec2.data[0] - vec1.data[0], 2.0) + math.pow(f32, vec2.data[1] - vec1.data[1], 2.0) + math.pow(f32, vec2.data[2] - vec1.data[2], 2.0));
}
