const expect = @import("std").testing.expect;
const eql = @import("std").mem.eql;

// payload captures are used to "capture" value from something
// syntax -> |value|
test "optional-if"{
  const num: ?usize = 12;
  if(num) |n|{
    try expect(@TypeOf(n) == usize);
    try expect(n == 12);
  } else{
    unreachable;
  }
}


// with if statements and err unions error capture is required
test "err union if"{
  const num: error{UnknownEntity}!u32 = 10;
  if(num) |entity|{
    try expect(@TypeOf(entity) == u32);
    try expect(entity == 10);
  } else |err|{
    _ = err catch {};
    unreachable;
  }
}


// while loops and optionals, may or may not have else block
test "while, optional"{
  var i: ?u32 = 12;
  while(i) |num| : (i.? -= 1){
    try expect(@TypeOf(num) == u32);
    if(num == 1){
      i = null;
      break;
    }
  }
  try expect(i == null);
}


// while loops and err unions, else with err capture required
var nums: u32 = undefined;

fn errSequence() !u32{
  return if(nums == 0) error.ReachedZero else blk: {
    nums -= 1;
    break :blk nums;
  };
}

test "while err union"{
  var sum: u32 = 0;
  nums = 5;
  while(errSequence()) |val|{
    sum += val;
  } else |err|{
    try expect(err == error.ReachedZero);
  }
}


// for loops
test "for"{
  const x = [_]i8{-25, 15, -15, 25};
  for(x) |v|  try expect(@TypeOf(v) == i8);
}


// switch cases
const Info = union(enum){
  a: u32,
  b: []const u8,
  c,
  d: u32
};

test "switch"{
  const b = Info{.a = 10};
  const x = switch(b){
    .b => |str| blk: {
      try expect(@TypeOf(str) == []const u8);
      break :blk 1;
    },
    .c => 2,
    // if they are of same type they can be captured in same grp
    .a, .d => |num| blk: {
      try expect(@TypeOf(num) == u32);
      break :blk num * 2;
    },
  };
  try expect(x == 20);
}


// as the values captured are immutable, if we use pointers to use the original values
// we can modify the value by derefencing it
test "pointers"{
  var data = [_]u8{4, 5, 6};
  for(&data) |*byte| byte.* += 1;
  try expect(eql(u8, &data, &[_]u8{5, 6, 7}));
}