const expect = @import("std").testing.expect;

// When a function suspends, control flow returns to wherever it was last resumed

// the async feature will not work on stable version of zig, we can use stage 1 compiler which is more feature complete

var foo: i32 = 1;

// the numbers in comments are order of execution
test "suspend, no resume" {
    const frame = async func(); //1
    _ = frame;
    try expect(foo == 2);     //4
}

fn func() void {
    foo += 1;                 //2
    suspend {}                //3
    foo += 1;                 //not executed
}

var bar: i32 = 1;

test "suspend, resume" {
    var frame = async func2();  //1
    resume frame;               //4
    try expect(bar == 3);       //6
}

fn func2() void {
    bar += 1;                   //2
    suspend {}                  //3
    bar += 1;                   //5
}