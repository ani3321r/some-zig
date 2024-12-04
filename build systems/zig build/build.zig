const std = @import("std");

// the "zig build" allows more advanced things with the zig projects
// artifacts, additional configs, custom tasks, etc

// using compilers builtin cache system we don't have to bring other lang build tools(cmake, etc) 

pub fn build(b: *std.Build) void {
  const exe = b.addExecutable(.{
    .name = "hello",
    .root_source_file = b.path("src/main.zig"),
    .target = b.standardTargetOptions(.{}),
    .optimize = b.standardOptimizeOption(.{}), // these standard optimizations are defaults
  });

  b.installArtifact(exe);
  const run_exe = b.addRunArtifact(exe);

  // instead of running "zig run" we can configure build like this to run the bin
  const run_step = b.step("run", "Run the application");
  run_step.dependOn(&run_exe.step);
  // here we use just "zig build run"
  // to look the whole steps we can use "zig build run --summary all"
}

// similar to the "zig run" in which we can add many attributes as our needs
// "zig build" also got attributes to add which we can see using "zig build --help"

// we can also make optional executable name in here like this
// const exe_name = b.option(
//    []const u8,
//    "exe_name",
//    "Name of the executable",
// ) orelse "hello";