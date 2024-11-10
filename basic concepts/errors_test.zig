const expect = @import("std").testing.expect;

// error set
// it is in the form of a enum, each error is a set of value, errors are basically values in zig
const FileErr = error{
  AccessDenied,
  FileNotFound
};

