module main

import os
import dl.loader

// import consts

const progressFile = "progress.dat"
const LIMIT = 14


fn resumeProgress() !u8 {
	contents := os.read_file(progressFile)!
	cleaned := contents.trim("\n\r ")
	ret := cleaned.parse_int(10, 8)!
	println("Resume from ${ret}")	

	return u8(ret)
}

fn newProgress() !u8 {
	println("${intro}")

	mut file := os.create(progressFile)!
	defer {
		file.close()
	}

	_ := file.write_string("0")!

	return 0
}

fn saveProgress(progress int) ! {
	mut file := os.open_file(progressFile, "w", os.sys_open)!
	defer {
		file.close()
	}

	_ := file.write_string("${progress}")!
}

fn compileProgram(filename string) bool {
	res := os.execute("gcc ${filename}.c -o ${filename}")

	if res.exit_code != 0 {
		println("Compilation failed.")
		return false
	}

	return true
}

fn checkOutput(actual string, expected string) bool {
	println("${actual}")
	println("Expected:\n${expected}")

	return actual == expected
}

fn runExercise(filename string, expected string) !bool {
	compiled := compileProgram(filename)

	if !compiled { return false }

	res := os.execute(filename)

	passed := checkOutput(res.output, expected)

	return passed
}

fn compileLibrary() bool {
	mut libpath := ""

	$if linux {
		libpath = "./Module5_Project/libustring.so"
	} $else $if windows {
		libpath = "./Module5_Project/libustring.dll"
	} $else {
		libpath = "./Module5_Project/libustring.dylib"
	}

	res := os.execute("gcc -fPIC -shared ./Module5_Project/libustring.c -o ${libpath}")

	if res.exit_code != 0 {
		println("Complication failed")
		return false
	}

	return true
}

fn testLibrary() !bool {
	compiled := compileLibrary()
	if !compiled {
		return false
	}

	mut libpath := ""

	$if linux {
		libpath = "./Module5_Project/libustring.so"
	} $else $if windows {
		libpath = "./Module5_Project/libustring.dll"
	} $else {
		libpath = "./Module5_Project/libustring.dylib"
	}

	mut lib := loader.get_or_create_dynamic_lib_loader(
		key: "libustring",
		paths: [libpath]
	)!

	defer {
		lib.unregister()
	}

	ustrlen := lib.get_sym("ustrlen") or { 
		println("Function ustrlen not found!")
		return false
	}
	ustrcmp := lib.get_sym("ustrcmp") or {
		println("Function ustrcmp not found!")
		return false
	}
	ustrcat := lib.get_sym("ustrcat") or {
		println("Function ustrcat not found!")
		return false
	}
	ustrcpy := lib.get_sym("ustrcpy") or {
		println("Function ustrcpy not found!")
		return false
	}

	strlenPass := testStrlen(ustrlen)
	strcmpPass := testStrcmp(ustrcmp)
	strcatPass := testStrcat(ustrcat)
	strcpyPass := testStrcpy(ustrcpy)

	return strlenPass && strcmpPass && strcatPass && strcpyPass
}

fn main() {
	exists := os.exists(progressFile)

	mut current := 0

	if exists {
		current = resumeProgress() or {
			println("Could not resume progress.")
			exit(1)
		};
	} else {
		current = newProgress() or {
			println("Could not start new progress.")
			exit(1)
		};
	}

	mut line := ''
	for {
		if current > (LIMIT) { break }

		println("Current exercise: ${exercises[current]}.c")
		print("Save and quit ('q'); Compile ('c'): ")

		line = os.get_line()

		if line == "q" {
			println("Quitting...")
			saveProgress(current) or {
				println("Could not save progress.")
				exit(1)
			};
			return
		} else if line == "c" {
			mut passed := false
			if current == (LIMIT) {
				passed = testLibrary() or { 
					println("Could not test library.")
					exit(1)
				};
			} else {
				passed = runExercise(exercises[current], expecteds[current]) or {
					println("Could not run exercise ${exercises[current]}")
					exit(1)
				};
			}

			if !passed {
				println("Failed!")
				continue
			} else {
				println("Passed!")
				current++
				saveProgress(current) or {
					println("Could not save progress at ${current}")
					exit(1)
				};
			}
		}
	}

	println("Congrats on finish seeling! I hope you learned something!")
}