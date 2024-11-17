const expect = @import("std").testing.expect;

// in order to impliment break or continue loops are given labels

test "nested"{
  var cnt: usize = 0;
  outer: for([_]i32{1, 2, 3, 4, 5, 6, 7, 8}) |_|{
    for ([_]i32{ 1, 2, 3, 4, 5 }) |_| {
      cnt += 1;
      continue :outer;
    }
  }
  try expect(cnt == 8);
}