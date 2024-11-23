const expect = @import("std").testing.expect;
const meta = @import("std").meta;

// vectors only have child types of bools, ints, floats and ptrs
// operations can only take place if the child type and the length are equal
test "addition"{
  const x: @Vector(4, f32) = .{4, -5, 15, 6};
  const y: @Vector(4, f32) = .{6, 5, 15, -3};
  const z = x + y;
  try expect(meta.eql(z, @Vector(4, f32){10, 0, 30, 3}));
}


// are indexable
test "index"{
  const x: @Vector(4, i8) = .{-25, 25, 5, -5};
  try expect(x[2] == 5);
}


// @splat is used to initialize a vector with equal vals.
// multiplying a vector by a scalar
test "vector * scalar"{
  const x: @Vector(4, f32) = .{5.5, 1.5, 11.5, 9.5};
  const y = x * @as(@Vector(4, f32), @splat(2));
  try expect(meta.eql(y, @Vector(4, f32){11, 3, 23, 19}));
}


// vecs can be looped inspite of not having len field
test "looping"{
  const x = @Vector(4, u8){10, 25, 15, 20};
  const sum = blk: {
    var tmp: u8 = 0;
    var i: u8 = 0;
    while(i<4) : (i += 1) tmp += x[i];
    break :blk tmp;
  };
  try expect(sum == 70);
}

// vectors coerce to their respective arrays
const arr: [4]f32 = @Vector(4, f32){ 1, 2, 3, 4 };