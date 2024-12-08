const expect = @import("std").testing.expect;

// all alignments are powerr of 2
// the cpu can read only certain multiples of memory, like f32 can have a multiple value of 4(alignment)
// therefore the natural alignment of the data types depends on the cpu architecture

// in zig we can make data specially alligned acc to our need
const a: u8 align(4) = 100;
const b align(4) = @as(u8, 100);

// we can also create data with less alignment
const c: u64 align(1) = 100;
const d align(1) = @as(u64, 100);

// pointers has the property align
test "align ptrs"{
  const a1: u32 align(8) = 20;
  try expect(@TypeOf(&a1) == *align(8) const u32);
}

// func expecting as a aligned ptr
fn total(a2: *align(64) const [64]u8) u32 {
    var sum: u32 = 0;
    for (a2) |elem| sum += elem;
    return sum;
}

test "align data"{
  const x align(64) = [_]u8{10} ** 64;
  try expect(total(&x) == 640);
}