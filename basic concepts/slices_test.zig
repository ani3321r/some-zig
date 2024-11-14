const expect = @import("std").testing.expect;

// syntax of slices []a, a being the child
// slices have the same attributes as pointers
// for loops can iterrate over slices

fn total(val: []const u8) usize{
  var sum: usize = 0;
  for (val) |v| sum += v;
  return sum;
}

test "slice"{
  const arr = [_]u8{2, 4, 6, 8, 10};
  const slice = arr[0..2];
  try expect(total(slice) == 6);
}

// slicing produces a pointer to an array i.e. *[n]a coerce to []a
test "slice2"{
  const arr = [_]u8{2, 4, 6, 8, 10};
  const slice = arr[0..2];
  try expect(@TypeOf(slice) == *const [2]u8);
}

// to slice to the end we use the syntax
test "slice3"{
  var arr = [_]u8{2, 4, 6, 8, 10};
  const slice = arr[2..];
  _ = slice;
}