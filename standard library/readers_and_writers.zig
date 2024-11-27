const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;
const ArrList = std.ArrayList;
const test_allo = std.testing.allocator;
const fixedBuff = std.heap.FixedBufferAllocator;


// writer usage
test "writer"{
  var list = ArrList(u8).init(test_allo);
  defer list.deinit();
  const bytes_w = try list.writer().write(
    "hello raiden"
  );

  try expect(bytes_w == 12);
  try expect(eql(u8, list.items, "hello raiden"));
}


// copy the contents of allocated buffer
test "reader usage"{
  const msg = "hello file";
  const file = try std.fs.cwd().createFile(
    "test.txt",
    .{.read = true}
    );
    defer file.close();

    try file.writeAll(msg);
    try file.seekTo(0);

    const contents = try file.reader().readAllAlloc(
      test_allo,
      msg.len
    );
    defer test_allo.free(contents);

    try expect(eql(u8, contents, msg));
}


// common use case of readers
fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
  const line = (try reader.readUntilDelimiterOrEof(
    buffer,
    '\n',
  )) orelse return null;
  if (@import("builtin").os.tag == .windows) {
    return std.mem.trimRight(u8, line, "\r");
  } else {
    return line;
  }
}

test "read next line"{
  const stdout = std.io.getStdOut();
  const stdin = std.io.getStdIn();

  try stdout.writeAll(
    \\ Enter ur name:
  );

  var buff: [100]u8 = undefined;
  const input = (try nextLine(stdin.reader(), &buff)).?;
  try stdout.writer().print(
    "Welcome: \"{s}\"\n",
    .{input},
  );
}


// implementing writer
pub fn MyByteList(comptime cap: usize) type{
  return struct{
    buff: [cap]u8 = undefined,
    allo: fixedBuff,
    list: ArrList(u8),

    const Self = @This();

    pub fn init() Self{
      var self = Self{
        .buff = undefined,
        .allo = fixedBuff.init(&Self.buff),
        .list = undefined,
      };
      self.list = ArrList(u8).init(self.allo.allocator());
      return self;
    }

    pub fn writer(self: *Self) std.io.Writer(*Self, error{OutOfMem}, appendW){
      return .{.context = self};
    }

    pub fn appendW(self: *Self, data: []const u8) error{OutOfMem}!usize{
      try self.list.appendSlice(data);
      return data.len;
    }

    pub fn getItems(self: *const Self) []const u8{
      return self.list.items;
    }

    pub fn deinit(self: *Self) void{
      self.list.deinit();
    } 
  };
}

test "custom writer" {
    var byteList = MyByteList(100).init();
    defer byteList.deinit();

    const writer = byteList.writer();
    try writer.writeAll("Hello, Raiden!");

    const items = byteList.getItems();
    try std.testing.expectEqualStrings("Hello, Raiden!", items);
}