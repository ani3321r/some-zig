const std =  @import("std");

pub fn main() void {
  std.io.getStdOut().writeAll(
    "Hello Raiden"
  ) catch unreachable;
}

// the structure of the command to generate a basic bin for the code
// zig build-exe hello.zig -O ReleaseSmall -fstrip -fsingle-threaded


// there are four build modes
// debug -> default because it produces shortest compile time
// ReleaseSafe -> it is runtime safe and has speed optimization
// ReleaseSmall -> not runtime safe but size optimized
// ReleaseFast -> not runtime safe but has speed optimization


// to output executables, libraries, objects we use
// zig build-exe, zig build-lib, zig build-obj


// some common arguments
// -fsingle-threaded -> asserts bin which is single-threaded. Thread safe(mutexes into no-ops)
// -fstrip -> remove debug info from bin
// --dynamic -> used with "zig build-lib", outputs a shared lib


// zig can compile for combination of different cpu and os
// it can be done with "-target"
// by default zig compiles  for the specific cpu