// zig fmt: off

const std = @import("std");

// const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const GREEN = "\x1b[32m";
const RESET = "\x1b[30m";
const RED = "\x1b[31m";
const PURPLE = "\x1b[35m";

pub fn Test() type {
  return struct {
    name:[]const u8,
    iteration:i8,
    pass:bool,
    passed:i8,
    failed:i8,
    const Self = @This();

    pub fn Init(name:[]const u8) Self {
      return .{
        .name = name,
        .iteration = -1,
        .pass = true,
        .passed = 0,
        .failed = 0		
      };
    }

    pub fn NewTest(self:*Self) !void {
      self.iteration += 1;
      try stdout.print("Test {s}::{d}: ", .{self.name, self.iteration});
    }

    pub fn Fail(self:*Self, expected:anytype, actual:anytype) !void {
      // print("{}", .{@TypeOf(expected)});
      if (@TypeOf(expected) == []const u8) {
        try stdout.print("Expected {s}, Got {s}! {s}FAIL{s}\n", .{expected, actual, RED, RESET});
      } else {
        try stdout.print("Expected {any}, Got {any}! {s}FAIL{s}\n", .{expected, actual, RED, RESET});
      }
      self.pass = false;
      self.failed += 1;
    }

    pub fn Pass(self:*Self) !void {
      try stdout.print("{s}PASS{s}\n", .{GREEN, RESET});
      self.passed += 1;
    }

    pub fn ExpectNumber(self:*Self, comptime T:type, expected:T, actual:T) !void {
      switch (@typeInfo(T)) {
        .int => {
          if (expected != actual) {
            try self.Fail(expected, actual);
          } else {
            try self.Pass();
          }
        },
        else => {
          try stdout.print("Not an integer!\n", .{});
        }
      }
    }

    pub fn ExpectString(self:*Self, expected:[]const u8, actual:[]const u8) !void {
      if (std.mem.eql(u8, expected, actual)) {
        try self.Pass();
      } else {
        try self.Fail(expected, actual);
      }
    }

    pub fn Summarize(self:*Self) !void {
      const status = if (self.pass) "PASSED" else "FAILED";
      const colorcode = if (self.pass) GREEN else RED;
      try stdout.print("Passing {d}/{d} => {s}{s}{s}\n", .{self.passed, self.passed+self.failed, colorcode, status, RESET});
    }

    pub fn Status(self:*Self) bool {
      return self.pass;
    }

    pub fn show(self:*Self) void {
      try stdout.print("Current test: {s} on {d}\n", .{self.name, self.iteration});
    }
	};
}

pub fn CreateStringBuffer(allocator: std.mem.Allocator, buffsize:u8, comptime str:[]const u8) ![*c]u8 {
  var buffer = try allocator.alloc(u8, buffsize);
  const _dst = try std.fmt.bufPrint(buffer, str, .{});
  buffer[_dst.len] = 0;

  return buffer.ptr;
}

pub fn Normalize(cstr:[*c] u8) []u8 {
  return std.mem.span(cstr);
}