const std = @import("std");
const expect = std.testing.expect;

// std lib in zig provides pattern for allocating memory
// no allocations happen in the back other than the user alocated
// here we are gonna syscall the os to allocate some memory
test "allocation"{
  const allocator = std.heap.page_allocator;
  const mem = try allocator.alloc(u8, 50);
  defer allocator.free(mem); // common pattern for mem management
  try expect(mem.len == 50);
  try expect(@TypeOf(mem) == []u8);
}


// to allocate memory into a fixed buffer we do the following
// we use it when heap allocation is not required, also considered for performance
test "fixed buffer"{
  var buff: [1000]u8 = undefined;
  var fba = std.heap.FixedBufferAllocator.init(&buff);
  const allo = fba.allocator();

  const mem = try allo.alloc(u8, 500); // allocating mem in the buffer
  defer allo.free(mem);

  try expect(mem.len == 500);
  try expect(@TypeOf(mem) == []u8);
}


// now we are gonna allocate memory many times but only free once
// we are using .deinit() here as .free will be of no use here
// .deinit() frees all memory
test "deinit test"{
  var ar = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer ar.deinit();
  const allo = ar.allocator();

  _ = try allo.alloc(u8, 1);
  _ = try allo.alloc(u8, 10);
  _ = try allo.alloc(u8, 100);
}


// for slices we use alloc and free
// for single items we use create and destroy
test "create"{
  const byte = try std.heap.page_allocator.create(u8);
  defer std.heap.page_allocator.destroy(byte);
  byte.* = 128;
}


// zig also has gpa which is used to detect leaks
// the safety can also be turned off by keeping the config struct empty
// the gpa is used for safety over performance
test "gpa"{
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  const allo = gpa.allocator();
  defer{
    const deinit_stat = gpa.deinit();
    if(deinit_stat == .leak) expect(false) catch @panic("Test failed");
  }

  const bytes = try allo.alloc(u8, 100);
  defer allo.free(bytes);
}