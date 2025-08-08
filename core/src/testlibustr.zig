// zig fmt: off

const std = @import("std");
const T = @import("libtesting.zig");

// const print = std.debug.print;

pub const ustrlen_t = *const fn(str:[*c]const u8) callconv(.C) usize;
pub const ustrcmp_t = *const fn(str1:[*c]const u8, str2:[*c]const u8) callconv(.C) c_int;
pub const ustrcat_t = *const fn(dst:[*c]const u8, str:[*c]const u8) callconv(.C) [*c] u8;
pub const ustrcpy_t = *const fn(dst:[*c]const u8, str:[*c]const u8) callconv(.C) [*c] u8;


pub fn testStrlen(strlen:ustrlen_t) !bool {
  const _Test = T.Test();
  var Test = _Test.Init("ustrlen");

  try Test.NewTest();
  const str0 = "Hello";
  var expected:usize = 5;
  var res = strlen(str0);
  try Test.ExpectNumber(usize, expected, res);

  try Test.NewTest();
  const str1 = "";
  expected = 0;
  res = strlen(str1);
  try Test.ExpectNumber(usize, expected, res);

  try Test.Summarize();
  return Test.Status();
}

pub fn testStrcmp(strcmp:ustrcmp_t) !bool {
  const _Test = T.Test();
  var Test = _Test.Init("ustrcmp");

  try Test.NewTest();
  const str1 = "Hello";
  const str2 = "Chii";
  var expected:i32 = 5;
  var res = strcmp(str1, str2);
  try Test.ExpectNumber(i32, expected, res);

  try Test.NewTest();
  const str3 = "Chii";
  expected = 0;
  res = strcmp(str2, str3);
  try Test.ExpectNumber(i32, expected, res);

  try Test.NewTest();
  expected = -5;
  res = strcmp(str2, str1);
  try Test.ExpectNumber(i32, expected, res);

  try Test.Summarize();
  return Test.Status();
}

pub fn testStrcat(strcat:ustrcat_t) !bool {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const allocator = arena.allocator();

  const _Test = T.Test();
  var Test = _Test.Init("ustrcat");

  try Test.NewTest();
  const src = "Aruel";
  const dst = try T.CreateStringBuffer(allocator, 64, "Chii ");
  const res_ = strcat(dst, src);
  const res = T.Normalize(res_);
  try Test.ExpectString("Chii Aruel", res);

  try Test.NewTest();
  const src1 = "Worker";
  const res1 = T.Normalize(strcat(res_, src1));
  try Test.ExpectString("Chii AruelWorker", res1);

  try Test.Summarize();
  return Test.Status();
}

pub fn testStrcpy(strcpy:ustrcpy_t) !bool {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const allocator = arena.allocator();

  const _Test = T.Test();
  var Test = _Test.Init("ustrcpy");

  try Test.NewTest();
  const dst = try T.CreateStringBuffer(allocator, 64, "Chii");
  const res_ = strcpy(dst, "Nya");
  const res = T.Normalize(res_);
  try Test.ExpectString("Nya", res);

  try Test.NewTest();
  const res1_ = strcpy(res_, "Aurlenya");
  const res1 = T.Normalize(res1_);
  try Test.ExpectString("Aurlenya", res1);

  try Test.Summarize();
  return Test.Status();
}