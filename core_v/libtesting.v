// module libtesting
module main

const GREEN = "\x1b[32m"
const RESET = "\x1b[30m"
const RED = "\x1b[31m"
const PURPLE = "\x1b[35m"

// type any = voidptr
interface Any {}

pub struct Test {
pub mut:
	name string
	iteration i8
	pass bool
	passed i8
	failed i8
}

pub fn Test.new() Test {
	return Test{}
}

pub fn (mut t Test) Init(name string) {
	t.name = name
	t.iteration = -1
	t.pass = false
	t.passed = 0
	t.failed = 0
}

pub fn (mut t Test) NewTest() {
	t.iteration++
	println("Test ${t.name}::${t.iteration}")
}

pub fn (mut t Test) Fail(expected Any, actual Any) {
	println("Expected ${expected}, Got ${actual}")
	t.pass = false
	t.failed++
}

pub fn (mut t Test) Pass() {
	println("${GREEN}PASS${RESET}")
	t.pass = true
	t.passed++
}

pub fn (mut t Test) ExpectNumber(expected Any, actual Any) {
	match expected {
		int {
			match actual {
				int {
					if expected != actual {
						t.Fail(expected, actual)
					} else {
						t.Pass()
					}
				} else {
					println("`actual` is not number!")
				}
			}
		} else {
			println("`expected` is not a number!")
		}
	} 
}

pub fn (mut t Test) ExpectString(expected string, actual string) {
	if expected == actual {
		t.Pass()
	} else {
		t.Fail(expected, actual)
	}
}

pub fn (mut t Test) Summarize() {
	status := if t.pass { "PASSED" } else { "FAILED" }
	colorcode := if t.pass { GREEN } else { RED }
	println("Passing ${t.passed}/${t.passed+t.failed} => ${colorcode}${status}${RESET}")
}

pub fn (mut t Test) Status() bool {
	return t.pass
}

pub fn (mut t Test) show() {
	println("Current test: ${t.name} on ${t.iteration}")
}