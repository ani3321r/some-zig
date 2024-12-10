const std = @import("std");
const expect = std.testing.expect;
const eql = std.meta.eql;

// The bit aligned ptrs stores more info like how to access the data
// sometimes data is not byte-aligned, so it is used there.
// Accessing fields inside packed structs needs to be bit aligned

const isGod = packed struct {
    raiden: bool,
    liu: bool,
    cage: bool,
    katana: bool,
};

test "bit aligned pointers" {
    var x = isGod{
        .raiden = false,
        .liu = false,
        .cage = false,
        .katana = false,
    };

    const raiden = &x.raiden;
    raiden.* = true;

    const liu = &x.liu;
    liu.* = true;

    try expect(@TypeOf(raiden) == *align(1:0:1) bool);
    try expect(@TypeOf(liu) == *align(1:1:1) bool);

    try expect(eql(x, .{
        .raiden = true,
        .liu = true,
        .cage = false,
        .katana = false,
    }));
}