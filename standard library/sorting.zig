const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;

// the std library has utils for sorting
test "sort"{
  var data = [_]u8{ 25, 35, 15, 5, 0, 45, 55 };
  std.mem.sort(u8, &data, {}, comptime std.sort.asc(u8)); // sorting in ascending order
  try expect(eql(u8, &data, &[_]u8{ 0, 5, 15, 25, 35, 45, 55 }));

  std.mem.sort(u8, &data, {}, comptime std.sort.desc(u8)); // sorting in descending order
  try expect(eql(u8, &data, &[_]u8{55, 45, 35, 25, 15, 5, 0}));
}

// sort.asc and sort.desc are basically comparison functions
// if we wanna sort non-numerical types we have to make our own comp funcs

// about the time complexity, best case = O(n), worst case = O(n*log(n))