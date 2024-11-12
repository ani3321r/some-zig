const expect = @import("std").testing.expect;

// error set
// it is in the form of a enum, each error is a set of value, errors are basically values in zig
const FileErr = error{
  AccessDenied,
  FileNotFound
};

// applications
const NoAccess = error{AccessDenied};

test "subset to superset"{
  const err: FileErr = NoAccess.AccessDenied;
  try expect(err == FileErr.AccessDenied);
}


// union error type
// combining error set with another type of error can be achieved
// using the union error type 

test "error union"{
  const prob_err: NoAccess!u16 = 15;
  const no_err = prob_err catch 0;

  try expect(@TypeOf(no_err) == u16);
  try expect(no_err == 15);
}


// payload capturing
// funcs often return err unions, |err| receives the value of the error
fn failingFunc() error{scam}!void{
  return error.scam;
}

test "return err"{
  failingFunc() catch |err|{
    try expect(err == error.scam);
    return;
  };
}

// the try catch in zig is different from 'try catch' chain in other languages
fn failFunc() error{scam}!i32{
  try failingFunc();
  return 15;
}

test "try"{
  const s = failFunc() catch |err|{
    try expect(err == error.scam);
    return;
  };
  try  expect(s == 15);
}


// errdefer is jsut like defer, exec only if func returned with err in the block
var issue: u32 =  36;

fn failFuncCnt() error{scam}!void{
  errdefer issue += 1;
  try failingFunc();
}

test "errdefer"{
  failFuncCnt() catch |err|{
    try expect(err == error.scam);
    try expect(issue == 37);
    return;
  };
}