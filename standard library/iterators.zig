const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;

// we might have a struct with a next func with optional in return type
// the func may return null to indicate the end of iteration
test "split iter" {
  const text = "raiden, is, the, god, ";
  var iter = std.mem.split(u8, text, ", ");
  try expect(eql(u8, iter.next().?, "raiden"));
  try expect(eql(u8, iter.next().?, "is"));
  try expect(eql(u8, iter.next().?, "the"));
  try expect(eql(u8, iter.next().?, "god"));
  try expect(eql(u8, iter.next().?, ""));
  try expect(iter.next() == null);
}


// in order to unpack the error that might happen while iterating we have the return type "!?T"
// for this kind of ops cwd has to opened with iter permission
test "iter looping"{
  var iter = (try std.fs.cwd().openDir(
    ".",
    .{ .iterate = true}
  )).iterate();

  var file_cnt: usize = 0;
  while(try iter.next()) |entry|{
    if(entry.kind == .file) file_cnt += 1;
  }

  try expect(file_cnt > 0);
}


// making a custom iterator, iterating over strs to find a particular str
const containsIter = struct {
  strs: []const []const u8,
  needle: []const u8,
  idx: usize = 0,
  fn next(self: *containsIter) ?[]const u8{
    const idx = self.idx;
    for(self.strs[idx..]) |str|{
      self.idx += 1;
      if(std.mem.indexOf(u8, str, self.needle)) |_|{
        return str;
      }
    }
    return null;
  }
};

test "custom iter"{
  var iter = containsIter{
    .strs = &[_][]const u8{ "raiden", "is", "god"},
    .needle = "i"
  };

  try expect(eql(u8, iter.next().?, "raiden"));
  try expect(eql(u8, iter.next().?, "is"));
  try expect(iter.next() == null);
}