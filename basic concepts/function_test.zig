const expect = @import("std").testing.expect;

// functions in zig are in camel case
// all functions are immutable
fn addFive(x: u32) u32{
  return x + 5;
}

test "func5"{
  const y = addFive(0);
  try expect(@TypeOf(y) == u32);
  try expect(y == 5);
}


// recursion is allowed in zig
fn fibonacci(n: u16) u16{
  if(n == 0 or n == 1) return n;
  return fibonacci(n-1) + fibonacci(n - 2);
}

test "func recur"{
  const x = fibonacci(7);
  try expect(x == 13);
}