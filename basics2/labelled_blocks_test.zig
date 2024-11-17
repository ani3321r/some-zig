const expect = @import("std").testing.expect;

// blocks can be given labels which yield values
// empty block is a value of type void
test "label block" {
    const cnt = blk: {
        var sum: u32 = 0;
        var i: u32 = 0;
        while (i < 10) : (i += 1) sum += i;
        break :blk sum;
    };
    try expect(cnt == 45);
    try expect(@TypeOf(cnt) == u32);
}

// example of a block representing c's i++
// blk: {
//     const tmp = i;
//     i += 1;
//     break :blk tmp;
// }