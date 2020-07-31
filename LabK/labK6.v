module labk;
reg a, b, c;
wire z;

not not1(tmp, c);
and and1(x,a,tmp);
and and2(y,b,c);
or or1(z,x,y);

initial
begin
  a = 1;
  b = 0;
  c = 0;
  #1 $display("z=%b", z);
  end

endmodule
