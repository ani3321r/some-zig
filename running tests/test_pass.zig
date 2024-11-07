const std = @import("std");
const expect = std.testing.expect;

test "always succeeds" {
    try expect(true);
}

// to test in zig we use the command
// zig test test_pass.zig