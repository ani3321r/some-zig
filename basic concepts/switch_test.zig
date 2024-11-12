const expect = @import("std").testing.expect;

// statement
// while using switch any branch cannot be left out, and the types must coerce
test "statement"{
  var x: i16 = 15;
  switch (x) {
    -1...1 =>{
      x = -x;
    },
    15, 255 => {
      // when dividing signed integers
      x = @divExact(x, 15);
    },
    else => {},
  }
  try expect(x == 1);
}


// expression
test "expression"{
  var x: i16 = 15;
  x = switch(x){
    -1...1 => -x,
    15, 255 => @divExact(x, 15),
    else => x,
  };
  try expect(x == 1);
}