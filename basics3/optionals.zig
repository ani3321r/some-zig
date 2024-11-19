const expect = @import("std").testing.expect;

// used to store "null" or value of type T
test "optional"{
  var found_idx: ?usize = null;
  const data = [_]i32{2, 4, 6, 8, 12};
  for(data, 0..) |v, i|{
    if(v == 10) found_idx = i;
  }
  try expect(found_idx == null);
}

// the orelse expression acts when an optional is null
test "orelse"{
  const s: ?f32 = null;
  const val: f32 = 0;
  const b = s orelse val;
  try expect(b == 0);
  try expect(@TypeOf(b) == f32);
}

// when we know it is impossible for a optional value to be null we use
// orelse unnreachable -> .?(shorthand notation)
test "orelse unreachable"{
  const a: ?f32 = 8;
  const b = a orelse unreachable;
  const c = a.?;
  try expect(b == c);
  try expect(@TypeOf(c) == f32);
} // if and while are supported

// if optional payload capture
test "payload"{
  const a: ?i32 = 8;
  if(a != null){
    const val = a.?;
    _ = val;
  }

  var b: ?i32 = 8;
  if(b) |*val|{
    val.* += 1;
  }
  try expect(b.? == 9);
}

// using while
var num_left: u32 = 5;
fn nullSeq() ?u32{
  if(num_left == 0) return null;
  num_left -= 1;
  return num_left;
}

test "null capture"{
  var sum: u32 = 0;
  while(nullSeq()) |val|{
    sum += val;
  }
  try expect(sum == 10);
}