const expect = @import("std").testing.expect;

// can store one value of many possible types, one field may be active
const Res = union{
  int: i64,
  float: f64,
  bool: bool
};

test "union eg"{
  const res = Res{.int = 1133};
  res.float = 11.33; // it is a inactive field so it will cause an error
}


// tagged unions are used to detect which field is active
const Tag = enum { a, b, c };

const Tagged = union(Tag) { a: u8, b: f32, c: bool };

test "switch on tagged union" {
    var value = Tagged{ .b = 1.5 };
    switch (value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b.*,
    }
    try expect(value.b == 3);
}

// the tag type can be ignored using this syntax
// const Tagged = union(enum) { a: u8, b: f32, c: bool };

// void members are also available
// const Tagged2 = union(enum) { a: u8, b: f32, c: bool, none };