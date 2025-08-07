type ustrlen_t* = proc(str:cstring):csize_t {.gcsafe, stdcall.}
type ustrcmp_t* = proc(str0:cstring, str1:cstring):cint {.gcsafe, stdcall.}
type ustrcat_t* = proc(dst:cstring, str:cstring):cstring {.gcsafe, stdcall.}
type ustrcpy_t* = proc(dst:cstring, str:cstring):cstring {.gcsafe, stdcall.}

from std/strformat import `&`

import libtesting

proc testStrlen*(strlen:ustrlen_t):bool =
  var test = Init("ustrlen")

  test.NewTest()
  let str0 = "Hello"
  var expected:csize_t = 5
  var res = strlen(cstring(str0))
  test.ExpectNumber(expected, res)

  test.NewTest()
  let str1 = ""
  expected = 0
  res = strlen(cstring(str1))
  test.ExpectNumber(expected, res)

  test.Summarize()
  return test.Status()

proc testStrcmp*(strcmp:ustrcmp_t):bool =
  var test = Init("ustrcmp")

  test.NewTest()
  let str1 = "Hello"
  let str2 = "Chii"
  var expected:int32 = 5
  var res = strcmp(cstring(str1), cstring(str2))
  test.ExpectNumber(expected, res)

  test.NewTest()
  let str3 = "Chii"
  expected = 0
  res = strcmp(cstring(str2), cstring(str3))
  test.ExpectNumber(expected, res)

  test.NewTest()
  expected = -5
  res = strcmp(cstring(str2), cstring(str1))
  test.ExpectNumber(expected, res)

  test.Summarize()
  return test.Status()

proc testStrcat*(strcat:ustrcat_t):bool =
  var test = Init("strcat")

  test.NewTest()
  let src = "Aruel"
  var dst = newString(64)
  copyMem(addr dst[0], cstring("Chii "), 6)
  let res:cstring = strcat(cstring(dst), cstring(src))
  test.ExpectString("Chii Aruel", $(res))

  test.NewTest()
  let src1 = "Worker"
  let res1:cstring = strcat(res, cstring(src1))
  test.ExpectString("Chii AruelWorker", $(res1))

  test.Summarize()
  return test.Status()

proc testStrcpy*(strcpy:ustrcpy_t):bool =
  var test = Init("strcpy")

  test.NewTest()
  var dst = newString(64)
  copyMem(addr dst[0], cstring("Chii"), 5)
  let res:cstring = strcpy(cstring(dst), cstring("Nya"))
  test.ExpectString("Nya", $(res))

  test.NewTest()
  let res1:cstring = strcpy(res, cstring("Aurlenya"))
  test.ExpectString("Aurlenya", $(res1))

  test.Summarize()
  return test.Status()