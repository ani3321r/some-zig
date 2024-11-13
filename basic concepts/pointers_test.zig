const expect = @import("std").testing.expect;

// pointer asterix syntax is same as c (*a)
// referencing is also same (&a)
// deferencing is diff (a.*)

// normal pointers cannot have null or 0 value
fn incri(num: *u8) void{
  num.* += 1;
}

test "ptrs"{
  var x: u8 = 3;
  incri(&x);
  try expect(x == 4);
}

// setting *a to the value 0 is detachable illegal behaviour

// test "illegal"{
//   var x: u16 = 0;
//   var y: *u8 = @ptrFromInt(x);
//   _ = y;
// }


// const ptrs do not allow to modify referenced data

// test "const"{
//   const x: u8 = 5;
//   var y = &x;
//   y.* += 1;
// }

// usize and isize are given as unsigned and signed integers which are the same size as pointers
test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}