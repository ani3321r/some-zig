const expect = @import("std").testing.expect;

// to execute a block of code forcebly at compile time the "comptime" keyword is used
fn fibonacci(n: u16) u16{
  if(n == 0 or n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

test "comptime"{
  const x = comptime fibonacci(10);
  const y = comptime blk: {
    break : blk fibonacci(8);
  };
  try expect(y == 21);
  try expect(x == 55);
}


// integer literals are of type comptime_int, they have no proper size so they have arbitary precision
test "comptime_int"{
  const a = 8;
  const b = a + 2;

  const c: u4 = a;
  const d: f32 = b;

  try expect(c == 8);
  try expect(d == 10);
}


// comptime_float acts internally as f128
// the types in zig are values of type "type"
test "branching types"{
  const a = 6;
  const b: if(a < 10) f32 else i32 = a;
  try expect(b == 6);
  try expect(@TypeOf(b) == f32);
}


// some func params can be tagged as comptime
fn Matrix(
  comptime T: type,
  comptime width: comptime_int,
  comptime height: comptime_int,
) type{
  return [height][width]T;
}

test "returning type"{
  try expect(Matrix(f32, 5, 5) == [5][5]f32);
}


// @typeInfo takes in type and returns a tagged union
fn addSmallInts(comptime T: type, a: T, b: T) T{
  return switch(@typeInfo(T)){
    .ComptimeInt => a + b,
    .Int => |info| if (info.bits <= 16)
      a + b
  else
    @compileError("int too large"),
  else => @compileError("only int accpeted"),
  };
}

test "type info switch"{
  const x = addSmallInts(u16, 16, 14);
  try expect(@TypeOf(x) == u16);
  try expect(x == 30);
}


// @Type func is used to create type from @typeInfo
// unimplimented for enums, unions, funcs, structs
fn getBiggerInt(comptime T: type) type{
  return @Type(.{
    .Int = .{
      .bits = @typeInfo(T).Int.bits + 1,
      .signedness = @typeInfo(T).Int.signedness,
    },
  });
} 

test "Type"{
  try expect(getBiggerInt(u8) == u9);
  try expect(getBiggerInt(i30) == i31);
}

// we make generic data structures by returning struct types
// std.mem.eql compares two slices
fn Vec(
  comptime cnt: comptime_int,
  comptime T: type,
) type{
  return struct{
    data: [cnt]T,
    const Self = @This();

    fn abs(self: Self) Self{
      var tmp = Self{.data = undefined};
      for(self.data, 0..) |elem, i|{
        tmp.data[i] = if(elem < 0)
          -elem
        else
          elem;
      }
      return tmp;
    }
    fn init(data: [cnt]T) Self{
      return Self{.data = data};
    }
  };
}

const eql = @import("std").mem.eql;

test "generic vec"{
  const x = Vec(3, f32).init([_]f32{6, -6, -2});
  const y = x.abs();
  try expect(eql(f32, &y.data, &[_]f32{6, 6, 2}));
}


// the type of func param can also be inferred using "anytype"
fn plusOne(x: anytype) @TypeOf(x){
  return x + 1;
}

test "inferred func param"{
  try expect(plusOne(@as(u16, 20)) == 21);
}


// comptime introduces some operators
// ++ -> concatenating
// ** -> repeating arrs and slices
test "++"{
  const x: [5]u8 = undefined;
  const y = x[0..];

  const a: [10]u8 = undefined;
  const b = a[0..];

  const new = y ++ b;
  try expect(new.len == 15);
}


test "**"{
  const pattern = [_]u8{0xCC, 0xBB};
  const mem = pattern ** 2;
  try expect(eql(u8, &mem, &[_]u8{0xCC, 0xBB, 0xCC, 0xBB}));
}