module labk;
reg flag, a, b, c;
wire z;

not not1(tmp, c);
and and1(x,a,tmp);
and and2(y,b,c);
or or1(z,x,y);

initial
begin
  flag = $value$plusargs("a=%b", a);
  flag = $value$plusargs("b=%b", b);
  flag = $value$plusargs("c=%b", c);
  #1 $display("z=%b", z);
  end

endmodule
