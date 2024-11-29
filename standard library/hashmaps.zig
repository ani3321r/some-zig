const std = @import("std");
const expect = std.testing.expect;
const test_allo = std.testing.allocator;

// the autohashmap in zig lets us create hash maps easily
test "hash"{
  const Pnt = struct{x: i8, y: i8};

  var map = std.AutoHashMap(u32, Pnt).init(
    test_allo
  );
  defer map.deinit();

  try map.put(200, .{.x = 1, .y = 10});
  try map.put(300, .{.x = 2, .y = 20});
  try map.put(400, .{.x = 3, .y = 30});
  try map.put(500, .{.x = 4, .y = 40});

  try expect(map.count() == 4);

  var sum = Pnt{.x = 0, .y = 0};
  var iter = map.iterator();

  while(iter.next()) |entry|{
    sum.x += entry.value_ptr.x;
    sum.y += entry.value_ptr.y;
  }

  try expect(sum.x == 10);
  try expect(sum.y == 100);
}


// fetchput either puts a value in a hashmap or return prev val for the key
test "fetchput"{
  var map = std.AutoHashMap(u8, f32).init(
    test_allo
  );
  defer map.deinit();

  try map.put(255, 10);
  const old = try map.fetchPut(255, 50);

  try expect(old.?.value == 10);
  try expect(map.get(255).? == 50);
}


// to use string as a key we use stringhashmap
test "str hashmap"{
  var map = std.StringHashMap(enum{dog, cat}).init(
    test_allo
  );
  defer map.deinit();

  try map.put("chester", .dog);
  try map.put("sofia", .cat);

  try expect(map.get("chester").? == .dog);
  try expect(map.get("sofia").? == .cat);
}

// stringhashmap and autohashmap are just wrappers around hashmap
// std.hashmap gives us more control

// arrayhashmap and autoarrayhashmaps are also available for elements backed by array