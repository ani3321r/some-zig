const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;
const test_allo = std.testing.allocator;

const Place = struct{lat: f32, lon: f32};

// parse json str into struct type
test "json parse"{
  const parsed = try std.json.parseFromSlice(
    Place, 
    test_allo, 
    \\{ "lat": 23.15135, "lon": -56.36435 }
    ,
    .{}
  );
  defer parsed.deinit();

  const place = parsed.value;

  try expect(place.lat == 23.15135);
  try expect(place.lon == -56.36435);
}


// stringify to turn arbitary values into a str
test "stringify"{
  const x = Place{
    .lat = 23.15135,
    .lon = -56.36435
  };

  var buff: [100]u8 = undefined;
  var fba = std.heap.FixedBufferAllocator.init(&buff);
  var str1 = std.ArrayList(u8).init(fba.allocator());
  try std.json.stringify(x, .{}, str1.writer());

  try expect(eql(u8, str1.items,
    \\{"lat":23.15135,"long":-56.36435}
  ));
}


// json parser for js str, arr, and maps
test "parser"{
  const User = struct{name: []u8, age: u16};

  const parsed = try std.json.parseFromSlice(User, test_allo, 
    \\{ "name": "raiden", "age": "150"}
    , .{});
    defer parsed.deinit();

    const usr = parsed.value;

    try expect(eql(u8, usr.name, "raiden"));
    try expect(usr.age == 150);
}