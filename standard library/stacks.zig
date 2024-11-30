const std = @import("std");
const test_allo = std.testing.allocator;
const expect = std.testing.expect;

// to use a stack like data structure  we use arraylists
test "stack"{
  const str1 = "(()())";
  var stack = std.ArrayList(usize).init(
    test_allo
  );
  defer stack.deinit();

  const Pair = struct{open: usize, close: usize};
  var pairs = std.ArrayList(Pair).init(
    test_allo
  );
  defer pairs.deinit();

  for(str1, 0..) |char, i|{
    if(char == '(') try stack.append(i);
    if(char == ')')
      try pairs.append(.{
        .open = stack.pop(),
        .close = i 
      });
  }

  for(pairs.items, 0..) |pair, i|{
    try expect(std.meta.eql(pair, switch(i){
      // order of brackets
      0 => Pair{ .open = 1, .close = 2},
      1 => Pair{ .open = 3, .close = 4},
      2 => Pair{ .open = 0, .close = 5},
      else => unreachable
    }));
  }
}