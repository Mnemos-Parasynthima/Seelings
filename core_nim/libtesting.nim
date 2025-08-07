import std/strformat

const 
  RED* = "\x1b[31m"
  GREEN* = "\x1b[32m"
  RESET* = "\x1b[0m"
# const PURPLE = "\x1b[35m"

type 
  Test* = object
    name*:string
    iteration*:int8
    pass*:bool
    passed*:int8
    failed*:int8

proc Init*(name:string):Test =
  var test = Test(name: name, iteration: -1, pass: true, passed: 0, failed: 0)
  return test

proc NewTest*(self:var Test) =
  self.iteration += 1
  echo &"Test {self.name}::{self.iteration}"

proc Fail*(self:var Test, expected:auto, actual:auto) =
  echo &"Expected {expected}, Got {actual}! {RED}FAIL{RESET}"
  self.pass = false
  self.failed += 1

proc Pass*(self:var Test) =
  echo &"{GREEN}PASS{RESET}"
  self.passed += 1

proc ExpectNumber*(self:var Test, expected:auto, actual:auto) =
  if typeof(expected) is SomeNumber:
    if expected != actual: self.Fail(expected, actual)
    else: self.Pass()
  else: echo "Not an integer!"

proc ExpectString*(self:var Test, expected:string, actual:string) =
  if expected == actual: self.Pass()
  else: self.Fail(expected, actual)

proc Summarize*(self:var Test) =
  let status = if self.pass: "PASSED" else: "FAILED"
  let colorcode = if self.pass: GREEN else: RED
  echo &"Passing {self.passed}/{self.passed+self.failed} => {colorcode}{status}{RESET}"

proc Status*(self:var Test):bool =
  self.pass

proc show*(self:var Test) =
  echo &"Current test: {self.name} on {self.iteration}"