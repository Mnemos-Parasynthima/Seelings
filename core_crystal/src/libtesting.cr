module Core
	module Libtesting
		GREEN = "\x1b[32m";
		RESET = "\x1b[0m";
		RED = "\x1b[31m";
		PURPLE = "\x1b[35m";

		class Test
			def initialize(@name : String)
				@iteration = -1_i8
				@pass = true
				@passed = 0_u8
				@failed = 0_u8
			end

			def newTest
				@iteration += 1
				puts "Test #{@name}::#{@iteration}"
			end

			def fail(expected, actual)
				puts "Expected #{expected}, Got #{actual}! #{RED}FAIL#{RESET}"
				@pass = false
				@failed += 1
			end

			def pass
				puts "#{GREEN}PASS#{RESET}"
				@passed += 1
			end

			def expectNumber(expected, actual)
				if expected.is_a?(Int32|UInt64) && actual.is_a?(Int32|UInt64)
					if expected != actual
						self.fail(expected, actual)
					else
						self.pass()
					end
				else
					puts "Not an integer!"
				end
			end

			def expectString(expected : String, actual : String)
				if expected == actual
					self.pass()
				else
					self.fail(expected, actual)
				end
			end

			def summarize
				status = @pass ? "PASSED" : "FAILED"
				colorcode = @pass ? GREEN : RED
				puts "Passing #{@passed}/#{@passed + @failed} => #{colorcode}#{status}#{RESET}"
			end

			def status : Bool
				@pass
			end

			def show
				puts "Current test: #{@name} on #{@iteration}"
			end
		end
	end
end