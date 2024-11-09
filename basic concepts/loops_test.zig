const expect = @import("std").testing.expect;

// while loops
test "while"{
  var i: u8 = 2;
  while(i < 64){
    i *= 2;
  }
  try expect(i == 64);
}

test "while with continue expression"{
  var sum: u8 = 0;
  var i: u8 = 1;
  while(i <= 14) : (i += 1){ // continue expression, handeling two conditions
    sum += 1;
  }
  try expect(sum == 10);
}

test "while with continue"{
  var sum: u8 = 0;
  var i: u8 = 0;
  while(i <= 4) : (i += 1){
    if(i == 2) continue;
    sum += i;
  }
  try expect(sum == 8);
}

test "while with break"{
  var sum: u8 = 0;
  var i: u8 = 0;
  while(i <= 5) : (i += 1){
    if(i == 3) break;
    sum += i;
  }
  try expect(sum == 3);
}


// for loops
test "for"{
  const str1 = [_]u8{'q', 'w', 'e'};

  // different syntax's
  for(str1, 0..) |char1, ind1|{
    _ = char1;
    _ = ind1; // zig doesn't allow unused value, used "_"
  }

  for(str1) |char1|{
    _ = char1;
  }

  for(str1, 0..) |_, ind1|{
    _ = ind1;
  }

  for(str1) |_| {}
}
// the rest break and continue are same as the while loop