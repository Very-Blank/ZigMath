const std = @import("std");
const math = std.math;
const constants = @import("constants.zig");
const quat = @import("quaternion.zig");

pub const ZERO: Vector2 = .{ .data = @Vector(2, f32){ 0.0, 0.0 } };
pub const UP: Vector2 = .{ .data = @Vector(2, f32){
    0.0,
    1.0,
} };
pub const RIGHT: Vector2 = .{ .data = @Vector(2, f32){ 1.0, 0.0 } };

pub const Vector2 = struct {
    data: @Vector(2, f32),

    pub inline fn setZERO(self: *Vector2) void {
        self.data = @Vector(2, f32){ 0.0, 0.0 };
    }

    pub inline fn setUP(self: *Vector2) void {
        self.data = @Vector(2, f32){ 0.0, 1.0 };
    }

    pub inline fn setRIGHT(self: *Vector2) void {
        self.data = @Vector(2, f32){ 1.0, 0.0 };
    }

    pub inline fn floatSet(self: *Vector2, floatx: f32, floaty: f32) void {
        self.data = @Vector(2, f32){ floatx, floaty };
    }

    pub inline fn vectorSet(self: *Vector2, vector: Vector2) void {
        self.data = vector.data;
    }

    pub inline fn dataSet(self: *Vector2, data: @Vector(2, f32)) void {
        self.data = data;
    }

    pub inline fn setAdd(self: *Vector2, other: Vector2) void {
        self.data += other.data;
    }

    pub inline fn setSubtract(self: *Vector2, other: Vector2) void {
        self.data -= other.data;
    }

    pub inline fn setMultiply(self: *Vector2, other: Vector2) void {
        self.data *= other.data;
    }

    pub inline fn setDivide(self: *Vector2, other: Vector2) void {
        self.data /= other.data;
    }

    pub inline fn setScale(self: *Vector2, other: f32) void {
        self.data = @Vector(2, f32){
            self.data[0] * other,
            self.data[1] * other,
        };
    }

    pub inline fn setSegment(self: *Vector2, other: f32) void {
        self.data = @Vector(2, f32){
            self.data[0] / other,
            self.data[1] / other,
        };
    }

    pub inline fn setNegate(self: *Vector2) void {
        self.data = -self.data;
    }

    //setCross?

    //Rotate with angle

    pub inline fn setNormalize(self: *Vector2) void {
        const len: f32 = getLength(self);
        if (len > 0) {
            self.data = self.data / @Vector(2, f32){ len, len };
        }
    }

    pub inline fn getLength(self: *Vector2) f32 {
        return @sqrt(math.pow(f32, self.data[0], 2.0) + math.pow(f32, self.data[1], 2.0));
    }

    pub inline fn getDot(self: *Vector2, vec2: Vector2) f32 {
        return self.data[0] * vec2.data[0] + self.data[1] * vec2.data[1];
    }

    pub inline fn getDistance(self: *Vector2, vec2: Vector2) f32 {
        return @sqrt(math.pow(f32, vec2.data[0] - self.data[0], 2.0) + math.pow(f32, vec2.data[1] - self.data[1], 2.0));
    }
};

pub inline fn createZERO() Vector2 {
    return .{
        .data = @Vector(2, f32){ 0.0, 0.0 },
    };
}

pub inline fn createUP() Vector2 {
    return .{
        .data = @Vector(2, f32){ 0.0, 1.0 },
    };
}

pub inline fn createRIGHT() Vector2 {
    return .{
        .data = @Vector(2, f32){ 1.0, 0.0, 0.0 },
    };
}

pub inline fn createFORWARD() Vector2 {
    return .{
        .data = @Vector(2, f32){ 0.0, 0.0 },
    };
}

pub inline fn floatCreate(floatx: f32, floaty: f32) Vector2 {
    return .{
        .data = @Vector(2, f32){ floatx, floaty },
    };
}

pub inline fn vectorCreate(vector: Vector2) Vector2 {
    return .{
        .data = vector.data,
    };
}

pub inline fn dataCreate(data: @Vector(2, f32)) Vector2 {
    return .{
        .data = data,
    };
}

pub inline fn add(vec1: Vector2, vec2: Vector2) Vector2 {
    return .{
        .data = vec1.data + vec2.data,
    };
}

pub inline fn subtract(vec1: Vector2, vec2: Vector2) Vector2 {
    return .{
        .data = vec1.data - vec2.data,
    };
}

pub inline fn multiply(vec1: Vector2, vec2: Vector2) Vector2 {
    return .{
        .data = vec1.data * vec2.data,
    };
}

pub inline fn divide(vec1: Vector2, vec2: Vector2) Vector2 {
    return .{
        .data = vec1.data / vec2.data,
    };
}

pub inline fn scale(vec1: Vector2, float: f32) Vector2 {
    return .{
        .data = @Vector(2, f32){
            vec1.data[0] * float,
            vec1.data[1] * float,
        },
    };
}

pub inline fn segment(vec1: Vector2, float: f32) Vector2 {
    return .{
        .data = @Vector(3, f32){
            vec1.data[0] / float,
            vec1.data[1] / float,
        },
    };
}

pub inline fn negate(vec1: Vector2) Vector2 {
    return .{
        .data = -vec1.data,
    };
}

pub inline fn dot(vec1: Vector2, vec2: Vector2) f32 {
    return vec1.data[0] * vec2.data[0] + vec1.data[1] * vec2.data[1];
}

pub inline fn dotData(vec1: @Vector(2, f32), vec2: @Vector(2, f32)) f32 {
    return vec1[0] * vec2[0] + vec1[1] * vec2[1];
}

pub inline fn length(vec1: Vector2) f32 {
    return @sqrt(math.pow(f32, vec1.data[0], 2.0) + math.pow(f32, vec1.data[1], 2.0));
}

pub inline fn distance(vec1: Vector2, vec2: Vector2) f32 {
    return @sqrt(math.pow(f32, vec2.data[0] - vec1.data[0], 2.0) + math.pow(f32, vec2.data[1] - vec1.data[1], 2.0));
}

pub inline fn normalize(vec1: Vector2) Vector2 {
    const len: f32 = length(vec1);
    return .{
        .data = vec1.data / @Vector(2, f32){ len, len },
    };
}
