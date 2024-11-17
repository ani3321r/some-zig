const expect = @import("std").testing.expect;

// zig suppoorts hex, octal and binary
const decimal_int: i32 = 98222;
const hex_int: u8 = 0xff;
const another_hex_int: u8 = 0xFF;
const octal_int: u16 = 0o755;
const binary_int: u8 = 0b11110000;

// we can use "_" b/w digits as visual seperator
const one_billion: u64 = 1_000_000_000;
const binary_mask: u64 = 0b1_1111_1111;
const permissions: u64 = 0o7_5_5;
const big_address: u64 = 0xFF80_0000_0000_0000;

// integer widening is allowed, if a new type fit the value there will be no errors
test "integer widening" {
    const a: u8 = 255;
    const b: u16 = a;
    const c: u32 = b;
    try expect(c == a);
}

// we can use @intCast to convert one type to another(must be in range)
test "@intCast" {
    const x: u64 = 200;
    const y = @as(u8, @intCast(x));
    try expect(@TypeOf(y) == u8);
}

// overflow are illegal behavior but sometimes it is required
// some overflow operators
// normal -> overflow 
// +   ->  +%
// -   ->  -%
// *   ->  *%
// +=  ->  +%=
// -=  ->  -%=
// *=  ->  *%=

test "overflow" {
    var a: u8 = 255;
    a +%= 1;
    try expect(a == 0);
}