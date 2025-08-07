from std/paths import Path
from std/files import fileExists
from std/osproc import execCmd, execCmdEx
from std/syncio import readFile
import std/rdstdin as rd
import std/strformat
import std/strutils
import std/dynlib

import consts
import testlibustr

const progressFile = "progress.dat"
const LIMIT = 14


proc resumeProgress():uint8 =
  let contents = readFile(progressFile)
  let cleaned = strip(contents, false, true, Whitespace)
  let ret = parseInt(cleaned)
  echo &"Resume from {ret}"

  return uint8(ret)

proc newProgress():uint8 =
  echo intro

  writeFile(progressFile, "0")

  return 0

proc saveProgress(progress:uint8) =
  writeFile(progressFile, &"{progress}")

proc compileProgram(filename:string):bool =
  let exitCode = execCmd(&"gcc {filename}-sol.c -o {filename}")

  if exitCode != 0:
    echo "Compilation failed."
    return false

  return true

proc runExercise(filename:string, expected:string):bool =
  let compiled = compileProgram(filename)

  if not compiled: return false

  let procStdout = execCmdEx(filename).output

  echo &"{procStdout}"
  echo &"Expected:\n{expected}"

  return expected == procStdout

proc compileLibrary():bool =
  let exitCode = execCmd("gcc -fPIC -shared ./Module5_Project/libustring-sol.c -o ./Module5_Project/libustring.so")

  if exitCode != 0:
    echo "Compilation failed."
    return false

  return true

type SymbolNotFound = object of Defect
proc testLibrary():bool =
  let compiled = compileLibrary()
  if not compiled: return false

  let lib = loadLib("./Module5_Project/libustring.so")
  defer: unloadLib(lib)

  let ustrlen = cast[ustrlen_t](lib.symAddr("ustrlen"))
  if ustrlen == nil: raise newException(SymbolNotFound, "Could not find symbol 'ustrlen'")

  let ustrcmp = cast[ustrcmp_t](lib.symAddr("ustrcmp"))
  if ustrcmp == nil: raise newException(SymbolNotFound, "Could not find symbol 'ustrcmp'")

  let ustrcat = cast[ustrcat_t](lib.symAddr("ustrcat"))
  if ustrcat == nil: raise newException(SymbolNotFound, "Could not find symbol 'ustrcat'")

  let ustrcpy = cast[ustrcpy_t](lib.symAddr("ustrcpy"))
  if ustrcpy == nil: raise newException(SymbolNotFound, "Could not find symbol 'ustrcpy'")

  let strlenPass = testStrlen(ustrlen)
  let strcmpPass = testStrcmp(ustrcmp)
  let strcatPass = testStrcat(ustrcat)
  let strcpyPass = testStrcpy(ustrcpy)

  return strlenPass and strcmpPass and strcatPass and strcpyPass

proc main() =
  var current:uint8 = 0

  if fileExists(Path(progressFile)):
    try: current = resumeProgress()
    except:
      echo "Could not resume progress"
      return
  else:
    try: current = newProgress()
    except:
      echo "Could not start new progress"
      return
  
  var line:string
  while true:
    if current > LIMIT: break

    echo(&"Current exercise: {exercises[current]}.c")
    try: line = rd.readLineFromStdin("Save and quit ('q'); Compile ('c'): ")
    except:
      echo "Bad readLineFromStdin"
      return

    if line == "q":
      echo "Quitting..."
      try: saveProgress(current)
      except: echo "Could not save progress"
      return
    elif line == "c":
      var passed:bool

      if current == LIMIT:
        try: passed = testLibrary()
        except SymbolNotFound: return
        except: 
          echo "Could not test library."
          return
      else:
        try: passed = runExercise(exercises[current], expecteds[current])
        except: 
          echo &"Could not run exercise {current}"
          return

      if not passed:
        echo "Failed!"
        continue
      else:
        echo "Passed!"
        current += 1
        saveProgress(current)

  echo "Congrats on finish seelings! I hope you learned something!"


main()