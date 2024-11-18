const expect = @import("std").testing.expect;

// break accepts a value just like return
fn rangeNum(begin: usize, end: usize, num: usize) bool {
    var i = begin;
    return while (i < end) : (i += 1) {
        if (i == num) {
            break true;
        }
    } else false; // executed when not exited with break
}

test "loop expression" {
    try expect(rangeNum(0, 10, 3));
}