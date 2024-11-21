const expect = @import("std").testing.expect;

// inline loops are unrolled
// they allow some actions at compile time only
test "inline for"{
  const types = [_]type{i8, f16, bool, u8};
  var sum: usize = 0;
  inline for (types) |T| sum += @sizeOf(T);
  try expect(sum == 5);
}

// the while works in a similar way