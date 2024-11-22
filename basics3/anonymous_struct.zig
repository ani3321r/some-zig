const expect = @import("std").testing.expect;

// when using struct literals the struct type may be ommmited
// but the literals must corece to other struct types
test "struct literals"{
  const Pnt = struct{x:i32, y:i32};

  const pt: Pnt = .{
    .x = 12,
    .y = 24
  };

  try expect(pt.x == 12);
  try expect(pt.y == 24);
}


// for anonymous structs, the corecing is not required meaning it can be fully anonymous
test "anonymous struct"{
  try scam(.{
    .int = @as(u32, 2244),
    .float = @as(f64, 22.45),
    .b = true,
    .s = "raiden",
  });
}

fn scam(args: anytype) !void{
  try expect(args.int == 2244);
  try expect(args.float == 22.45);
  try expect(args.b);
  try expect(args.s[0] == 'r');
  try expect(args.s[1] == 'a');
  try expect(args.s[2] == 'i');
  try expect(args.s[3] == 'd');
  try expect(args.s[4] == 'e');
  try expect(args.s[5] == 'n');
}


// tuples -> anonymous structs without field names
// they have many of the properties that arrays have(indexing, iterated...)
// numbered field names -> "0" , accessed with -> @"0" (acts as escape)
test "tuple" {
  const values = .{
    @as(u32, 2244),
    @as(f64, 22.45),
    true,
    "raiden",
  } ++ .{false} ** 2;
  try expect(values[0] == 2244);
  try expect(values[4] == false);
  inline for (values, 0..) |v, i| { // inline loops are used to iterate over tuple
    if (i != 2) continue;
    try expect(v);
  }
  try expect(values.len == 6);
  try expect(values.@"3"[0] == 'r');
}