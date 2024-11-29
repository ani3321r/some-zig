const std = @import("std");

// prng -> pseudorandom number generator
// default prng -> Xoroshiro128
// creating a prng using 64 bit rand seed
test "random num"{
  var prng = std.rand.DefaultPrng.init(blk:{
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));
    break :blk seed;
  });
  const rand = prng.random();

  const a = rand.float(f128);
  const b = rand.boolean();
  const c = rand.int(i16);

  _ = .{a, b, c};
}


// crypto secure random nums
test "crypto"{
  const rand = std.crypto.random;

  const a = rand.int(u8);
  const b = rand.float(f32);
  const c = rand.boolean();

  _ = .{a, b, c};
}