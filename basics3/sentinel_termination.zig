const expect = @import("std").testing.expect;

// arrs, ptrs and slices are terminated be a value of child type
// syntax -> [n:t]T, [:t]T, [*:t]T 
// t -> val, T -> type
test "sentinel"{
  const terminate = [3:0]u8{4, 5, 6};
  try expect(terminate.len == 3);
  try expect(@as(*const [4]u8, @ptrCast(&terminate))[3] == 0);
}

test "string literals"{
  try expect(@TypeOf("raiden") == *const [6:0]u8);
}


// C's string([*:0]u8  [*:0]const u8)
test "C string" {
  const c_string: [*:0]const u8 = "raiden";
  var array: [6]u8 = undefined;

  var i: usize = 0;
  while (c_string[i] != 0) : (i += 1) {
    array[i] = c_string[i];
  }
}


// sentinel terminated coerce to non sentinel
test "coercion" {
    const a: [*:0]u8 = undefined;
    const b: [*]u8 = a;

    const c: [5:0]u8 = undefined;
    const d: [5]u8 = c;

    const e: [:0]f32 = undefined;
    const f: []f32 = e;

    _ = .{ b, d, f };
}


// slicing
// assertion for memory is terminated where it should be
test "slicing" {
  var x = [_:0]u8{255} ** 3;
  const y = x[0..3 :0];
  _ = y;
}