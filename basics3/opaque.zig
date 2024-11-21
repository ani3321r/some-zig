// opaque types are of unknown size and alignment
// they cannot be stored directly
// they are used to maintain type safety with ptrs of unknown types

const Window = opaque{};
const Button = opaque{};

extern fn show_window(*Window) callconv(.C) void;

test "opaque"{
  // var main_win: *Window = undefined;
  // show_window(main_win);

  // var ok_button: *Button = undefined;
  // show_window(ok_button);
}


// opaque types have declarations
const Window2 = opaque{
  fn show(self: *Window2) void{
    show_window(self);
  }
};

extern fn show_window2(*Window2) callconv(.C) void;

test "opaque with declaration"{
  var main_win: *Window2 = undefined;
  main_win.show();
}