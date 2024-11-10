const expect = @import("std").testing.expect;

// used to execute something while exiting the block
test "defer"{
  var x: i16 = 3;
  {
    defer x += 2;
    try expect(x == 3);
  }
  try expect(x == 5);
}

// the defers execute in reverse order when more than one defer in a block
test "multi defer"{
  var x: f32 = 8.0;
  {
    defer x += 4.0;
    defer x /= 4.0;
  }
  try expect(x == 6);
}

// to make the efficient use of resources we use defer, instead of manually cleaning up
// the resources clean up automatically when not required