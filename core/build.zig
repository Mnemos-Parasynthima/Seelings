// zig fmt: off

const std = @import("std");

pub fn build(b: *std.Build) void {
  // Standard target options allows the person running `zig build` to choose
  // what target to build for. Here we do not override the defaults, which
  // means any target is allowed, and the default is native. Other options
  // for restricting supported target set are available.
  const target = b.standardTargetOptions(.{});

  // Standard optimization options allow the person running `zig build` to select
  // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
  // set a preferred release mode, allowing the user to decide how to optimize.
  const optimize = b.standardOptimizeOption(.{});

  const constsModule = b.createModule(.{
    .root_source_file = b.path("src/consts.zig")
  });

  const testStrlibModule = b.createModule(.{
    .root_source_file = b.path("src/testlibustr.zig")
  });

  const libtestModule = b.createModule(.{
    .root_source_file = b.path("src/libtesting.zig")
  });
  
  // We will also create a module for our other entry point, 'main.zig'.
  const exe_mod = b.createModule(.{
    // `root_source_file` is the Zig "entry point" of the module. If a module
    // only contains e.g. external object files, you can make this `null`.
    // In this case the main source file is merely a path, however, in more
    // complicated build scripts, this could be a generated file.
    .root_source_file = b.path("src/main.zig"),
    .target = target,
    .optimize = optimize,
    .imports = &.{
      .{ .name = "consts", .module = constsModule },
      .{ .name = "testlibustr", .module = testStrlibModule },
      .{ .name = "libtest", .module = libtestModule }
    }
  });
 

  // This creates another `std.Build.Step.Compile`, but this one builds an executable rather than a static library.
  const exe = b.addExecutable(.{
    .name = "clings",
    .root_module = exe_mod,
  });

  const useCompiler = b.option([]const u8, "compiler", "Which compiler to use (gcc|clang)") orelse "gcc";

  const opts = b.addOptions();
  opts.addOption([]const u8, "compiler", useCompiler);
  exe.root_module.addOptions("buildopts", opts);

  // THIS IS TEMPORARY
  exe.linkLibC();

  // This declares intent for the executable to be installed into the
  // standard location when the user invokes the "install" step (the default step when running `zig build`).
  b.installArtifact(exe);
}