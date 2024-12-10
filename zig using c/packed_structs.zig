const expect = @import("std").testing.expect;

// all types of structs in zig are aligned to the ABI size, without defined layout

// sometimes we need to have structs with defined layouts(not accordance with c ABI)
// here we use packed structs to have precise control over the struct(bit-by-bit control)

const MovementState = packed struct {
    running: bool,
    crouching: bool,
    jumping: bool,
    in_air: bool,
};

test "packed struct size" {
    try expect(@sizeOf(MovementState) == 1);
    try expect(@bitSizeOf(MovementState) == 4); // as bools have 1 bit size, the struct take up only 4 bit
    const state = MovementState{
        .running = true,
        .crouching = true,
        .jumping = true,
        .in_air = true,
    };
    _ = state;
}