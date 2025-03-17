const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // tests
    const testMod = b.createModule(.{
        .root_source_file = b.path("src/testVector3.zig"),
        .target = target,
        .optimize = optimize,
    });

    const panic_test = b.createModule(.{
        .root_source_file = b.path("libs/ZigPanicErrorTester/src/comperrtest.zig"),
        .target = target,
        .optimize = optimize,
    });

    testMod.addImport("panictest", panic_test);

    const unit_tests = b.addTest(.{
        .root_module = testMod,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    // library
    const libMod = b.createModule(.{
        .root_source_file = b.path("src/zigmath.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "ZigMath",
        .root_module = libMod,
    });

    b.installArtifact(lib);
}
