module Core
	module Consts
		INTRO = "Welcome to Seelings!
Authored by Me!
This program is to help you apply the basic concepts of C,
such as pointers, structs, unions, and memory.
The exercises are divided into modules, with a 'project' at the end.
Each module consists of exercise files that you have to:
	fix an issue, and/or
	complete the program
Since this assumes some knowledge of C and it is just to apply, there will not be much explanation.
Each file has some TODO comments indicate what to do at a general level.
It is highly encouraged to NOT use any form of AI. Not only because the exercises are rather easy,
but by not thinking and knowing the fundamentals, any more complex topics will not be properly registered
and will cause issues down the road.
"

		EXERCISES = [
			"./Module1_Basics/basics0",
			"./Module1_Basics/basics1",
			"./Module1_Basics/basics2",
			"./Module1_Basics/basics3",

			"./Module2_Memory/memory0",
			"./Module2_Memory/memory1",
			"./Module2_Memory/memory2",
			"./Module2_Memory/memory3",
			"./Module2_Memory/memory4",

			"./Module3_Derived-Types/derived0",
			"./Module3_Derived-Types/derived1",
			"./Module3_Derived-Types/derived2",
			"./Module3_Derived-Types/derived3",
			"./Module3_Derived-Types/derived4",

			"./Module5_Project/libustring"
		]

		EXPECTED = [
			"Print me!\nPrint me!\n",
			"330\n",
			"0\n6, 12\n",
			"CONZ flags: 0xa\nEncoded instruction is: 0x900050a2\nOpcode is: 0x48\n",

			"Stack string: I'm in the stack!\nHeap string: I'm in the heap!\n",
			"25\n",
			"Res is -1; evaled: 0\n",
			"[5, 10, 5, 10, 5, 10, 5, 10, 5, 10]\n",
			"Name is: Chi\nTheir quote is: \"And then there were none\"\nAllocated 11 for name and 31 for quote\n",

			"Symbols:\n\
			Name (obj): Value (0xfe20)\n\
			Name (len): Value (0xf)\n\
			Name (_sy): Value (0xa0)\n\
			Name (buffer): Value (0xfe40)\n\
			Name (_init): Value (0xfe50)\n\
			",

			"Data word is 0xffefafe\nData byte is 0x20\n",
			"Data entry:\n" \
			"\tType: string\n" \
			"\tAddr: 0xff00\n" \
			"\tSize: 0x5\n" \
			"\tSource: \n" \
			"Data entry:\n" \
			"\tType: bytes\n" \
			"\tAddr: 0xfe00\n" \
			"\tSize: 0x8\n" \
			"\tSource: \n" \
			"Data entry:\n" \
			"\tType: halfwords\n" \
			"\tAddr: 0xfe10\n" \
			"\tSize: 0x2\n" \
			"\tSource: \n",
			"Data Table (3 entries):\n" \
			"Data entry:\n" \
			"\tType: string\n" \
			"\tAddr: 0xee00\n" \
			"\tSize: 0x5\n" \
			"\tSource: \n" \
			"Data entry:\n" \
			"\tType: bytes\n" \
			"\tAddr: 0xff00\n" \
			"\tSize: 0x8\n" \
			"\tSource: \n" \
			"Data entry:\n" \
			"\tType: halfwords\n" \
			"\tAddr: 0xff10\n" \
			"\tSize: 0x2\n" \
			"\tSource: \n",
			"Symbol table size of 2:\n" \
			"Entry 0:\n" \
			"\tname: _sy\n" \
			"\tvalue: 32\n" \
			"\tflags: 0x0\n" \
			"Entry 1:\n" \
			"\tname: _lab\n" \
			"\tvalue: 0xfee0\n" \
			"\tflags: 0x10\n",
		]
	end
end