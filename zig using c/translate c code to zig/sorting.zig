const sort = @import("int_sort.zig");
const meta = @import("std").meta;
const expect = @import("std").testing.expect;

test "sorting"{
  const x: @Vector(5, f32) = .{ 4, 8, 1, 7, 5 };

  const y: @Vector(5, f32)  = sort(x);

  try expect(meta.eql(y, @Vector(5, f32){ 1, 4, 5, 7, 8 }));
}

// command to translate the code
// zig translate-c main.c > int_sort.zig

// this here will not work properly as the translation make the zig code idiomatic
// but atleast there is a option to translate c code to zig