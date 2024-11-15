const expect = @import("std").testing.expect;

// it has fixed set of named fields
const Vec = struct { x: f32, y: f32, z: f32 };

test "struct exp" {
    const vec = Vec{
        .x = 1.1,
        .y = 1.2,
        .z = 1.3,
    };
    _ = vec;
}

// fields can't be implicitly uninitialized
test "missing field"{
  const vec = Vec{
    .x = 2.2,
    .z = 2.3 // an error will occur due to the missing field
  };
  _ = vec;
}

// we can avoid the error by initializing default values for the fields
const Vec2 = struct{x: f32 = 0, y: f32 = 0, z: f32 = 0};

test "defaults"{
  const vec = Vec2{
    .x = 2.2,
    .z = 2.3 
  };
  _ = vec;
} // this time there will be no error

// like enums structs also have funcs and declarations

// without needing to derefernce the self ptr, it is done automatically
const Deref = struct {
    x: i32,
    y: i32,
    fn swap(self: *Deref) void {
        const tmp = self.x;
        self.x = self.y;
        self.y = tmp;
    }
};

test "automatic deref"{
  var a = Deref{.x = 5, .y = 7};
  a.swap();
  try expect(a.x == 7);
  try expect(a.y == 5);
}