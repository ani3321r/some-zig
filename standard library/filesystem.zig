const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;

// create and open a file in the curr dir, read and write
test "create, read, write"{
  const file = try std.fs.cwd().createFile(
    "test.txt",
    .{.read = true}
    );
    defer file.close();

    const bytes_w = try file.writeAll("new file");
    _ = bytes_w;

    var buff: [100]u8 = undefined;
    try file.seekTo(0); // go back to the start of the file
    const bytes_r = try file.readAll(&buff);

    try expect(eql(u8, buff[0..bytes_r ], "new file"));
}


// using file stat
test "file stat"{
  const file = try std.fs.cwd().createFile(
    "test2.txt",
    .{.read = true}
  );
  defer file.close();
  const stat = try file.stat();
  try expect(stat.size == 0);
  try expect(stat.kind == .file);
  try expect(stat.ctime <= std.time.nanoTimestamp());
  try expect(stat.mtime <= std.time.nanoTimestamp());
  try expect(stat.atime <= std.time.nanoTimestamp());
}


// making directories and iterating over the contents
test "dir, iter"{
  try std.fs.cwd().makeDir("test-dir");
  var iter_dir = try std.fs.cwd().openDir(
    "test-dir",
    .{.iterate = true}
    );
    defer{
      iter_dir.close();
      std.fs.cwd().deleteTree("test-dir") catch unreachable;
    }

    _ = try iter_dir.createFile("x", .{});
    _ = try iter_dir.createFile("y", .{});
    _ = try iter_dir.createFile("z", .{});

    var file_cnt: usize = 0;
    var iter = iter_dir.iterate();
    while(try iter.next()) |entry|{
      if(entry.kind == .file) file_cnt += 1;
    }

    try expect(file_cnt == 3);
}