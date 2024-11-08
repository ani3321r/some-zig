const std = @import("std");
const print = @import("std").debug.print;

pub fn main() void{
// Variable assignment
// const abc:  i32 = 6;
// var efg: u32 = 200;

// to perform explicit type coercion we use "@as"
// const inf_const = @as(i32, 5);
// var inf_var = @as(u32, 200);

// if we don't want to assign a value to a const or variable
// const a: i32 = undefined; // we can give type as we want
// var b: u32 = undefined; 

// it is preffered to use const over var values
// unused variables and consts seems to be error in this so i am commenting everything out


// Arrays
const a = [5]u8{'h','e','l','l','o'};
const b = [_]u8{'r','a','i','d','e','n'};
// we can either give the actual size of the array or give a '_' to denote the size of array

const len1 = a.len;
const len2 = b.len;

// jsut used so that the compiler do not show unused const error
const total: i32 = len1 + len2;
print("{}\n", .{total});

}