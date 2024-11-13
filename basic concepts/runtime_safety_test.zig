const expect = @import("std").testing.expect;


// zig safety is on by default, can be turned off 
// safety on has its speed penalties but its recommended to turn the safety on during tests

// out of bound(safety)
test "out of bounds" {
  const a = [3]u8{ 2, 2, 2 };
  var index: u8 = 6;
  const b = a[index];
  _ = b;
  _ = &index;
}

// without safety
test "out of bounds with no safety" {
  @setRuntimeSafety(false);
  const a = [3]u8{ 2, 2, 2 };
  var index: u8 = 6;
  const b = a[index];
  _ = b;
  _ = &index;
}


// Unreachable
// it is a assersion used to make a statement to not reach

test "unreachable"{
  const x: i32 = 5;
  const y: i32 = if(x == 3) 8 else unreachable;
  _ = y;
}

// using switch and unreachable
fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

test "unreachable switch" {
    try expect(asciiToUpper('a') == 'A');
    try expect(asciiToUpper('A') == 'A');
}