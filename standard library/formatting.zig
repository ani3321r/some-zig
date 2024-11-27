const std = @import("std");
const test_allo = std.testing.allocator;
const expect = std.testing.expect;
const eql = std.mem.eql;
const test_alloc = std.testing.allocator;

test "fmt"{
  const str1 = try std.fmt.allocPrint(
    test_allo,
    "{d} + {d} = {d}", // here "d" denotes decimal value
    .{5, 10, 15}
  );
  defer test_allo.free(str1);
  try expect(eql(u8, str1, "5 + 10 = 15"));
}


// similarly writers have "print" method
test "print"{
  var list = std.ArrayList(u8).init(test_allo);
  defer list.deinit();
  try list.writer().print(
    "{} + {} = {}", // using print we dont need to specify the type
    .{6, 10, 16}
  );
  try expect(eql(u8, list.items, "6 + 10 = 16"));
}


// using any for default formatting
test "array printing" {
  const string = try std.fmt.allocPrint(
    test_allo,
    "{any} + {any} = {any}",
    .{
      @as([]const u8, &[_]u8{ 1, 4 }),
      @as([]const u8, &[_]u8{ 2, 5 }),
      @as([]const u8, &[_]u8{ 3, 9 }),
    },
  );
  defer test_allo.free(string);

  try expect(eql(
    u8,
    string,
    "{ 1, 4 } + { 2, 5 } = { 3, 9 }",
  ));
}


// custom formatting, marked as pub sso that it can be accessed
const Person = struct{
  name: []const u8,
  birth: i32,
  death: ?i32,
  pub fn format(
    self: Person,
    comptime fmt: []const u8,
    options: std.fmt.FormatOptions,
    writer: anytype
  ) !void{
    _ = fmt;
    _ = options;

    try writer.print("{s} ({}-", .{ //{s} format specifier for string
      self.name, self.birth
    });

    if (self.death) |year| {
      try writer.print("{}", .{year});
    }

    try writer.writeAll(")");
  }
};

test "custom fmt" {
    const raiden = Person{
        .name = "raid Carmack",
        .birth = 1970,
        .death = null,
    };

    const raid_string = try std.fmt.allocPrint(
        test_alloc,
        "{s}",
        .{raiden},
    );
    defer test_alloc.free(raid_string);

    try expect(eql(
        u8,
        raid_string,
        "raid Carmack (1970-)",
    ));

    const claude = Person{
        .name = "Claude Shannon",
        .birth = 1976,
        .death = 2021,
    };

    const claude_string = try std.fmt.allocPrint(
        test_alloc,
        "{s}",
        .{claude},
    );
    defer test_alloc.free(claude_string);

    try expect(eql(
        u8,
        claude_string,
        "Claude Shannon (1976-2021)",
    ));
}