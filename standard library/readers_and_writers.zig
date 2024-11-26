const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;
const ArrList = std.ArrayList;
const test_allo = std.testing.allocator;


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