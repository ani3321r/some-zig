const expect = @import("std").testing.expect;

// when we want to have a struch layout of "C ABI" we use extern structs

const Data = extern struct { a: i32, b: u8, c: f32, d: bool, e: bool };

test "extern" {
    const x = Data{
        .a = 65900,
        .b = 89,
        .c = -10.5,
        .d = false,
        .e = true,
    };
    const z = @as([*]const u8, @ptrCast(&x));

    try expect(@as(*const i32, @ptrCast(@alignCast(z))).* == 65900);
    try expect(@as(*const u8, @ptrCast(@alignCast(z + 4))).* == 89);
    try expect(@as(*const f32, @ptrCast(@alignCast(z + 8))).* == -10.5);
    try expect(@as(*const bool, @ptrCast(@alignCast(z + 12))).* == false);
    try expect(@as(*const bool, @ptrCast(@alignCast(z + 13))).* == true);
}

// we have to run the test with x86_64 with gnu ABI, so we are gonna use the command
// zig test extern_struct.zig -target x86_64-native-gnu

// inside the memory of the x value there are some gaps between some of the bytes
// they are called padding, the padding data is undefined memory