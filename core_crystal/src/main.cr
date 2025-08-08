require "./consts"
require "./testlibustr"

module Core
	extend self

	PROGRESS_FILE = "progress.dat"
	LIMIT = 14

	def resumeProgress : UInt8
		contents = File.read(PROGRESS_FILE)
		cleaned = contents.chomp("\n\r ")
		ret = cleaned.to_u8?

		if ret == nil
			puts
			raise "Could not convert #{cleaned} to UInt8!"
		end

		puts "Resume from #{ret}"

		ret.not_nil!
	end

	def newProgress : UInt8
		puts Consts::INTRO

		File.write(PROGRESS_FILE, "w")

		0_u8
	end

	def compileProgram(filename : String) : Bool
		begin
			status = Process.run("gcc", args: ["#{filename}-sol.c", "-o", "#{filename}"]).exit_code?
		rescue ex
			puts "Could not run compiler!"
			raise ex
		end

		if status.not_nil! != 0
			puts "Compilation failed."
			false
		else
			true
		end
	end

	private def getFnPtr(libname, name : String)
		ptr = LibC.dlsym(libname, name)
		if ptr.null?
			raise "Could not find function `#{name}`!"
		end
		ptr
	end

	def runExercise(filename : String, expected : String) : Bool
		compiled = false
		begin
			compiled = compileProgram(filename)
		rescue ex
			raise ex
		end

		return false unless compiled
		# if !compiled
		# 	return false
		# end

		stdout = IO::Memory.new
		stderr = IO::Memory.new

		status = nil
		begin
			status = Process.run(filename, input: Process::Redirect::Inherit, output: stdout, error: stderr).exit_code?
		rescue ex
			puts "Could not run program!"
			raise ex
		end

		if status.not_nil! == 0
			actual = stdout.to_s
			puts actual
			puts "Expected:\n#{expected}"

			actual == expected
		else
			puts stderr.to_s
			false
		end
	end

	def compileLibrary : Bool
		begin
			gccargs = [
				"-fPIC",
				"-shared",
				"./Module5_Project/libustring-sol.c",
				"-o",
				"./Module5_Project/libustring.so"
			]

			status = Process.run("gcc", args: gccargs).exit_code?
		rescue ex
			puts "Could not run compiler!"
			raise ex
		end

		if status.not_nil! != 0
			puts "Compilation failed."
			false
		else
			true
		end
	end

	def testLibrary : Bool
		compiled = false
		begin
			compiled = compileLibrary()
		rescue ex
			raise ex
		end

		return false unless compiled
		# if !compiled
		# 	return false
		# end

		libustring = LibC.dlopen("./Module5_Project/libustring.so", LibC::RTLD_NOW)
		if LibC.dlerror
			raise "Error opening libustring.so"
		end

		begin
			ustrlen = Testlibustr::Ustrlen_t.new(getFnPtr(libustring, "ustrlen"), Pointer(Void).null)
			ustrcmp = Testlibustr::Ustrcmp_t.new(getFnPtr(libustring, "ustrcmp"), Pointer(Void).null)
			ustrcat = Testlibustr::Ustrcat_t.new(getFnPtr(libustring, "ustrcat"), Pointer(Void).null)
			ustrcpy = Testlibustr::Ustrcpy_t.new(getFnPtr(libustring, "ustrcpy"), Pointer(Void).null)

			strlenPass = Core::Testlibustr.testStrlen(ustrlen)
			strcmpPass = Core::Testlibustr.testStrcmp(ustrcmp)
			strcatPass = Core::Testlibustr.testStrcat(ustrcat)
			strcpyPass = Core::Testlibustr.testStrcpy(ustrcpy)

			strlenPass && strcmpPass && strcatPass && strcpyPass
		ensure
			LibC.dlclose(libustring)
		end
	end

	def self.main
		exists = File.exists?(PROGRESS_FILE)

		current = 0

		if exists
			begin
				current = resumeProgress()
			rescue 
				puts "Could not resume progress!"
				return
			end
		else
			begin
				current = newProgress()
			rescue
				puts "Could not start new progress!"
				return
			end
		end

		while true
			if current > LIMIT
				break
			end

			puts "Current exercise: #{Consts::EXERCISES[current]}.c"
			print "Save and quit ('q'); Compile ('c'): "

			line = gets()

			if line == "q"
				puts "Quitting..."
				begin
					File.write(PROGRESS_FILE, "#{current}")
				rescue
					puts "Could not save progress!"
				end
				return
			elsif line == "c"
				passed = false

				if current == LIMIT
					begin
						passed = testLibrary()
					rescue ex
						puts ex.message
						next
					end
				else
					begin
						passed = runExercise(Consts::EXERCISES[current], Consts::EXPECTED[current])
					rescue ex
						puts ex.message
						next
					end
				end

				if !passed
					puts "Failed!"
					next
				else
					puts "Passed!"
					current += 1
					File.write(PROGRESS_FILE, "#{current}")
				end
			end
		end

		puts "Congrats on finish seelings! I hope you learned something!"
	end
end

Core.main