// zig fmt: off

const std = @import("std");
const builtin = @import("builtin");
const buildopts = @import("buildopts");
const consts = @import("consts.zig");
const testlib = @import("testlibustr.zig");

const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const print = std.debug.print;
const intro = consts.intro;
const exercises = consts.exercises;
const expecteds = consts.expected;
const moduleDescrips = consts.moduleDescrips;
const fileDescrips = consts.fileDescrips;
const ustrlen_t = testlib.ustrlen_t;
const ustrcmp_t = testlib.ustrcmp_t;
const ustrcat_t = testlib.ustrcat_t;
const ustrcpy_t = testlib.ustrcpy_t;
const testStrlen = testlib.testStrlen;
const testStrcmp = testlib.testStrcmp;
const testStrcat = testlib.testStrcat;
const testStrcpy = testlib.testStrcpy;

const progressFile = "progress.dat";

const LIMIT = 14;

const cc:[]const u8 = buildopts.compiler;


fn checkProgress() bool {
  var fileExist = true;

  std.fs.cwd().access(progressFile, .{}) catch |err| {
    fileExist = if (err == error.FileNotFound) false else true;
  };

  return fileExist;
}

fn resumeProgress() !u8 {
  var buffer:[4]u8 = undefined;
  const contents = try std.fs.cwd().readFile(progressFile, &buffer);
  const cleaned = std.mem.trim(u8, contents, "\n\r ");
  const ret = try std.fmt.parseInt(u8, cleaned, 10);
  try stdout.print("Resume from {d}\n", .{ret});

  return ret;
}

fn newProgress() !u8 {
  try stdout.print("{s}\n", .{intro});

  const file = try std.fs.cwd().createFile(progressFile, .{});
  defer file.close();

  try file.writeAll("0");

  return 0;
}

fn saveProgress(progress: u8) !void {
  const file = try std.fs.cwd().createFile(progressFile, .{});
  defer file.close();

  var buffer:[4]u8 = undefined;
  const contents = try std.fmt.bufPrint(&buffer, "{}", .{progress});

  try file.writeAll(contents);
}

fn compileProgram(allocator:std.mem.Allocator, filename: []const u8) !bool {
  var buffer:[64]u8 = undefined;
  var buffAlloc = std.heap.FixedBufferAllocator.init(&buffer);
  const alloc = buffAlloc.allocator();

  var file = try alloc.alloc(u8, 64);
  defer alloc.free(file);
  
  file = try std.fmt.bufPrint(file, "{s}.c", .{filename});
  
  var proc = std.process.Child.init(&[_][]const u8{cc, file, "-o", filename}, allocator);

  try proc.spawn();

  const exitCode = proc.wait() catch |err| {
    try stdout.print("Error is {}", .{err});
    return false;
  };

  if (exitCode.Exited != 0) {
    try stdout.print("Compilation failed.\n", .{});
    return false;
  }

  return true;
}

fn checkOutput(proc:std.process.Child, expected: []const u8) !bool {
  var stdoutBuff = std.ArrayList(u8).init(proc.allocator);

  var stdoutStream = proc.stdout.?;
  var reader = stdoutStream.reader();
  try reader.readAllArrayList(&stdoutBuff, 4096);

  const out = stdoutBuff.items;

  try stdout.print("{s}\n", .{out});

  try stdout.print("Expected:\n{s}\n", .{expected});
  
  return std.mem.eql(u8, out, expected);
}

fn runExercise(filename: []const u8, expected: []const u8) !bool {
  const allocator = std.heap.page_allocator;

  const compiled = try compileProgram(allocator, filename);

  if (!compiled) {
    return false;
  }
    
  var proc = std.process.Child.init(&[_][]const u8{filename}, allocator);
  
  proc.stdout_behavior = .Pipe;
  proc.stderr_behavior = .Inherit;

  try proc.spawn();

  const passed = try checkOutput(proc, expected);

  _ = try proc.wait();

  return passed;
}

fn compileLibrary(allocator:std.mem.Allocator) !bool {
  var libpath:[]const u8 = undefined;

  if (builtin.target.os.tag == .linux) {
    libpath = "./Module5_Project/libustring.so";
  } else if (builtin.target.os.tag == .windows) {
    libpath = "./Module5_Project/libustring.dll";
  } else { // macos
    libpath = "./Module5_Project/libustring.dylib";
  }

  const ccArgs = [_][]const u8 {
    cc,
    "-fPIC", "-shared",
    "./Module5_Project/libustring.c",
    "-o", libpath
  };

  var proc = std.process.Child.init(&ccArgs, allocator);
  try proc.spawn();

  const exitCode = proc.wait() catch |err| {
    try stdout.print("Error is {}", .{err});
    return false;
  };

  if (exitCode.Exited  != 0) {
    try stdout.print("Compilation failed.\n", .{});
    return false;
  }

  return true;
}

fn testLibrary() !bool {
  const compiled = try compileLibrary(std.heap.page_allocator);
  if (!compiled) {
    return false;
  }

  var libpath:[]const u8 = undefined;

  if (builtin.target.os.tag == .linux) {
    libpath = "./Module5_Project/libustring.so";
  } else if (builtin.target.os.tag == .windows) {
    libpath = "./Module5_Project/libustring.dll";
  } else { // macos
    libpath = "./Module5_Project/libustring.dylib";
  }
  var lib = try std.DynLib.open(libpath);
  defer lib.close();

  const ustrlen = lib.lookup(ustrlen_t, "ustrlen") orelse {
    try stdout.print("Function ustrlen not found!\n", .{});
    return error.SymbolNotFound;
  };

  const ustrcmp = lib.lookup(ustrcmp_t, "ustrcmp") orelse {
    try stdout.print("Function ustrcmp not found!\n", .{});
    return error.SymbolNotFound;
  };

  const ustrcat = lib.lookup(ustrcat_t, "ustrcat") orelse {
    try stdout.print("Function ustrcat not found!\n", .{});
    return error.SymbolNotFound;
  };

  const ustrcpy = lib.lookup(ustrcpy_t, "ustrcpy") orelse {
    try stdout.print("Function ustrcpy not found!\n", .{});
    return error.SymbolNotFound;
  };

  const strlenPass = try testStrlen(ustrlen);
  const strcmpPass = try testStrcmp(ustrcmp);
  const strcatPass = try testStrcat(ustrcat);
  const strcpyPass = try testStrcpy(ustrcpy);

  return strlenPass and strcmpPass and strcatPass and strcpyPass;
}

pub fn main() !void {
  const exists = checkProgress();

  var current:u8 = 0;
  
  if (exists) {
    current = try resumeProgress();
  } else {
    current = try newProgress();
  }

  var line:[]u8 = undefined;
  while (true) {
    if (current > LIMIT) break;

    // if (current % 5 == 0) try stdout.print("New Module start!\n{s}\n", .{moduleDescrips[current/5]});

    try stdout.print("Current exercise: {s}.c\n", .{exercises[current]});
    // try stdout.print("{s}\n", .{fileDescrips[current]});
    try stdout.print("Save and quit ('q'); Compile ('c'): ", .{});

    line = try stdin.readUntilDelimiterAlloc(std.heap.page_allocator, '\n', 2);

    if (std.mem.eql(u8, line, "q")) {
      try stdout.print("Quitting...\n", .{});
      try saveProgress(current);
      return;
    } else if (std.mem.eql(u8, line, "c")) {
      // Testing the library project requires different handling
      // The rest is the same
      var passed:bool = undefined;
      if (current == LIMIT) {
        passed = try testLibrary();
      } else {
        passed = try runExercise(exercises[current], expecteds[current]);
      }

      if (!passed) {
        try stdout.print("Failed!\n", .{});
        continue;
      } else {
        try stdout.print("Passed!\n", .{});
        current += 1;
        try saveProgress(current);
      }
    }
  }

  // Code here only means that seelings has been completed

  try stdout.print("Congrats on finish seelings! I hope you learned something!\n", .{});
}
