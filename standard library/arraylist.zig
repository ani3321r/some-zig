const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;
const arrList = std.ArrayList;
const test_allo = std.testing.allocator; // only used in test, can detect mem leaks


// arraylist acts as a buffer that can change its size
// eqv to rust's Vec<T>
test "arrlist"{
  var list = arrList(u8).init(test_allo);
  defer list.deinit();
  try list.append('H');
  try list.append('e');
  try list.append('l');
  try list.append('l');
  try list.append('o');
  try list.appendSlice(" Raiden");

  try expect(eql(u8, list.items, "Hello Raiden"));
}