// module testlibustr
module main

import strings


pub type Ustrlen_t = fn (&char) u64
pub type Ustrcmp_t = fn (&char, &char) int
pub type Ustrcat_t = fn (&char, &char) &char
pub type Ustrcpy_t = fn (&char, &char) &char


pub fn testStrlen(strlen Ustrlen_t) bool {
	mut test := Test.new()
	test.Init("ustrlen")

	test.NewTest()
	str0 := "Hello"
	mut expected := 5
	mut res := int(strlen(&char(str0.str)))
	test.ExpectNumber(expected, res)

	test.NewTest()
	str1 := ""
	expected = 0
	res = int(strlen(&char(str1.str)))
	test.ExpectNumber(expected, res)

	test.Summarize()
	return test.Status()
}

pub fn testStrcmp(strcmp Ustrcmp_t) bool {
	mut test := Test.new()
	test.Init("ustrcmp")

	test.NewTest()
	str1 := "Hello"
	str2 := "Ch"
	mut expected := 5
	mut res := strcmp(&char(str1.str), &char(str2.str))
	test.ExpectNumber(expected, res)

	test.NewTest()
	str3 := "Ch"
	expected = 0
	res = strcmp(&char(str2.str), &char(str3.str))
	test.ExpectNumber(expected, res)

	test.NewTest()
	expected = -5
	res = strcmp(&char(str2.str), &char(str1.str))
	test.ExpectNumber(expected, res)

	test.Summarize()
	return test.Status()
}

pub fn testStrcat(strcat Ustrcat_t) bool {
	mut test := Test.new()
	test.Init("strcat")

	test.NewTest()
	src := "Aru"
	mut dst := strings.new_builder(64)
	dst.write_string("Chi ")
	res := strcat(&char(dst.data), &char(src.str))
	test.ExpectString("Chi Aru", unsafe { cstring_to_vstring(res) })

	test.NewTest()
	src1 := "Wo"
	res1 := strcat(res, &char(src1.str))
	test.ExpectString("Chi AruWo", unsafe { cstring_to_vstring(res1) })

	test.Summarize()
	return test.Status()
}

pub fn testStrcpy(strcpy Ustrcpy_t) bool {
	mut test := Test.new()
	test.Init("strcpy")

	test.NewTest()
	mut dst := strings.new_builder(64)
	dst.write_string("Chi")
	res := strcpy(&char(dst.data), &char("Ny".str))
	test.ExpectString("Ny", unsafe { cstring_to_vstring(res) })

	test.NewTest()
	res1 := strcpy(res, &char("Aurlenya".str))
	test.ExpectString("Aurlenya", unsafe { cstring_to_vstring(res1) })

	test.Summarize()
	return test.Status()
}