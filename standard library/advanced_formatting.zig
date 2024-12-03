const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;
const bufPrt = std.fmt.bufPrint;

// in advanced formatting there are a whole lot of parameters we have to deal with
// position -> idx of the arg
test "position"{
  var a: [4]u8 = undefined;

  try expect(eql(
    u8,
    try bufPrt(&a, "{0s}{0s}{1s}{2s}", .{"a", "d", "s"}),
    "aads"
  ));
}
// specifier -> type dependent fmt

// fill -> single char used for padding
// alignment -> '<' left '^' middle '>' right alignment
// width -> total width of char
test "fill, align, width"{
  var a: [7]u8 = undefined;

  try expect(eql(
    u8,
    try bufPrt(&a, "{s: <6}", .{"hola"}),
    "hola  "
  ));

  try expect(eql(
    u8,
    try bufPrt(&a, "{s:_^7}", .{"hola"}),
    "_hola__"
  ));

  try expect(eql(
    u8,
    try bufPrt(&a,"{s:!>5}", .{"hola"}),
    "!hola"
  ));
}
// precision -> decimal formatting
test "precision"{
  var a: [4]u8 = undefined;
  try expect(eql(
    u8,
    try bufPrt(&a, "{d:.2}", .{3.14159}),
    "3.14"
  ));
}