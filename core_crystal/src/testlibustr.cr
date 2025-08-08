require "./libtesting"

module Core
	module Testlibustr
		extend self

		alias Ustrlen_t = Proc(LibC::Char*, LibC::SizeT)
		alias Ustrcmp_t = Proc(LibC::Char*, LibC::Char*, LibC::Int)
		alias Ustrcat_t = Proc(LibC::Char*, LibC::Char*, LibC::UChar)
		alias Ustrcpy_t = Proc(LibC::Char*, LibC::Char*, LibC::UChar)

		def testStrlen(strlen : Ustrlen_t) : Bool
			test = Libtesting::Test.new "ustrlen"

			test.newTest()
			str0 = "Hello"
			expected = 5_u64
			res = strlen.call(str0.to_unsafe)
			test.expectNumber(expected, res)

			test.newTest()
			str1 = ""
			expected = 0_u64
			res = strlen.call(str1.to_unsafe)
			test.expectNumber(expected, res)

			test.summarize()
			test.status()
		end

		def testStrcmp(strcmp : Ustrcmp_t) : Bool
			test = Libtesting::Test.new "ustrcmp"

			test.newTest()
			str1 = "Hello"
			str2 = "Chii"
			expected = 5_i32
			res = strcmp.call(str1.to_unsafe, str2.to_unsafe)
			test.expectNumber(expected, res)

			test.newTest()
			str3 = "Chii"
			expected = 0_i32
			res = strcmp.call(str2.to_unsafe, str3.to_unsafe)
			test.expectNumber(expected, res)

			test.newTest()
			expected = -5_i32
			res = strcmp.call(str2.to_unsafe, str1.to_unsafe)
			test.expectNumber(expected, res)

			test.summarize()
			test.status()
		end

		def testStrcat(strcat : Ustrcat_t) : Bool
			test = Libtesting::Test.new "ustrcat"

			test.newTest()
			src = "Aruel"
			dst = Bytes.new(64, 0)
			"Chii ".to_unsafe.copy_to(dst.to_unsafe, "Chii ".bytesize)
			res = strcat.call(dst.to_unsafe, src.to_unsafe)
			test.expectString("Chii Aruel", String.new(dst.to_unsafe.as(LibC::Char*)))

			test.newTest()
			src1 = "Worker"
			res1 = strcat.call(dst.to_unsafe, src1.to_unsafe)
			test.expectString("Chii AruelWorker", String.new(dst.to_unsafe.as(LibC::Char*)))

			test.summarize()
			test.status()
		end

		def testStrcpy(strcpy : Ustrcpy_t) : Bool
			test = Libtesting::Test.new "ustrcpy"

			test.newTest()
			dst = Bytes.new(64, 0)
			"Chii ".to_unsafe.copy_to(dst.to_unsafe, "Chii ".bytesize)
			res = strcpy.call(dst.to_unsafe, "Nya".to_unsafe)
			test.expectString("Nya", String.new(dst.to_unsafe.as(LibC::Char*)))

			test.newTest()
			res = strcpy.call(dst.to_unsafe, "Aurlenya".to_unsafe)
			test.expectString("Aurlenya", String.new(dst.to_unsafe.as(LibC::Char*)))

			test.summarize()
			test.status()
		end
	end
end