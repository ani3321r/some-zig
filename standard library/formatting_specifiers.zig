const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;
const bufPrt = std.fmt.bufPrint;

// "X" and "x" are used for formatting ints into hex
// fmtSliceHexLower and fmtSliceHexUpper are used for formatting strings
test "hex"{
  var a: [8]u8 = undefined;

  _ = try bufPrt(&a, "{X}", .{1122445689});
  try expect(eql(u8, &a, "42E72979")); // all upprercase due to "X"

  _ = try bufPrt(&a, "{x}", .{2356891470});
  try expect(eql(u8, &a, "8c7b4f4e")); // all lowercase for obvious reasons

  _ = try bufPrt(&a, "{}", .{std.fmt.fmtSliceHexLower("oops")});
  try expect(eql(u8, &a, "6f6f7073"));
}


// {d} is used for dec formatting for num type
test "dec float"{
  var a: [4]u8 = undefined;
  try expect(eql(
    u8,
    try bufPrt(&a, "{d}", .{55.5}),
    "55.5"
  ));
}


// {c} is used to format a byte into ascii
test "ascii fmt"{
  var a: [1]u8 = undefined;
  _ = try bufPrt(&a, "{c}", .{82});
  try expect(eql(u8, &a, "R"));
}


// output memory sizes
// fmtIntSizeDec -> metric(1000)
// fmtIntSizeBin -> power-of-2(1024)
test "dec bi"{
  var a: [32]u8 = undefined;

  try expect(eql(u8, try bufPrt(&a, "{}", .{std.fmt.fmtIntSizeDec(10)}), "10B"));
  try expect(eql(u8, try bufPrt(&a, "{}", .{std.fmt.fmtIntSizeBin(10)}), "10B"));
  
  try expect(eql(u8, try bufPrt(&a, "{}", .{std.fmt.fmtIntSizeDec(1024)}), "1.024kB"));
  try expect(eql(u8, try bufPrt(&a, "{}", .{std.fmt.fmtIntSizeBin(1024)}), "1KiB"));

  try expect(eql(
    u8,
    try bufPrt(&a, "{}", .{std.fmt.fmtIntSizeDec(1024*1024*1024)}),
    "1.073741824GB"
  ));

  try expect(eql(
    u8,
    try bufPrt(&a, "{}", .{std.fmt.fmtIntSizeBin(1024*1024*1024)}),
    "1GiB"
  ));
}


// {b} output ints in binary and {o} in octal
test "bin oct fmt"{
  var a: [8]u8 = undefined;

  try expect(eql(
    u8,
    try bufPrt(&a, "{b}", .{169}),
    "10101001"
  ));

  try expect(eql(
    u8,
    try bufPrt(&a, "{o}", .{169}),
    "251"
  ));
}


// {*} does ptr formatting, prints the address
test "ptr fmt"{
  var a: [16]u8 = undefined;
  try expect(eql(
    u8,
    try bufPrt(&a, "{*}", .{@as(*u8, @ptrFromInt(0xAED))}),
    "u8@aed"
  ));
}


// {s} output strs
test "str fmt"{
  var a: [8]u8 = undefined;
  const rai: [*:0]const u8 = "raiden!!";

  try expect(eql(
    u8,
    try bufPrt(&a, "{s}", .{rai}),
    "raiden!!"
  ));
}