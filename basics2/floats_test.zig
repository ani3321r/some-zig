const expect = @import("std").testing.expect;

// zig's floats strictly IEEE-complaint
test "float"{
  const a: f16 = 0;
  const b: f32 = a;
  const c: f128 = b;
  try expect(c == @as(f128, a));
}
// @setFloatMode(.Optimized) is eqv to GCC's ffast-math


// different types of literals
const floating_point: f64 = 123.0E+77;
const another_float: f64 = 123.0;
const yet_another: f64 = 123.0e+77;

const hex_floating_point: f64 = 0x103.70p-5;
const another_hex_float: f64 = 0x103.70;
const yet_another_hex_float: f64 = 0x103.70P-5;

// underscore acts same as ints
const lightspeed: f64 = 299_792_458.000_000;
const nanosecond: f64 = 0.000_000_001;
const more_hex: f64 = 0x1234_5678.9ABC_CDEFp-10;

// int float conversion is possible using built-in funcs
// @floatFromInt -> this is safe
// @intFromFloat -> detectable illegal if value can't fit

test "int-float" {
    const a: i32 = 0;
    const b = @as(f32, @floatFromInt(a));
    const c = @as(i32, @intFromFloat(b));
    try expect(c == a);
}