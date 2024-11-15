const expect = @import("std").testing.expect;

// declaration
const direc = enum {N, S, E, W};

// specific int type can be assigned
const val = enum(u8) {sum, multi, div};

// ordinal value starts at 0
test "enum ordinal"{
  try expect(@intFromEnum(val.sum) == 0);
  try expect(@intFromEnum(val.multi) == 1);
  try expect(@intFromEnum(val.div) == 2);
}

// sequence of vals can be overridden using "next"
const val2 = enum(u32){
  hundred = 100,
  thousand = 1000,
  lakh = 100000,
  next
};

test "using next to set ordinal"{
  try expect(@intFromEnum(val2.hundred) == 100);
  try expect(@intFromEnum(val2.thousand) == 1000);
  try expect(@intFromEnum(val2.lakh) == 100000);
  try expect(@intFromEnum(val2.next) == 100001);
}

// enums can be given methods
const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

test "methods" {
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

// var, const in enums
const Mode = enum {
    var count: u32 = 0;
    on,
    off,
};

test "var_const" {
    Mode.count += 1;
    try expect(Mode.count == 1);
}