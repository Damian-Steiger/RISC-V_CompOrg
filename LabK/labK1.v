module labK;
reg [31:0] x; // a 32-bit register
reg one;
reg [1:0] two;
reg [2:0] three;

initial
begin

  one = &x;
  two = x[1:0];
  three = {one,two};

  $display("time = %5d, x = %b", $time, x);
  x = 32'd10;
  $display("time = %5d, x = %b", $time, x);
  x = x + 2;
  $display("time = %5d, x = %b", $time, x);
  $finish;
end

endmodule
