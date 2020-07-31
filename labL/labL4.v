module labL4;
reg [31:0] a0, a1, a2, a3, expect;
reg [1:0] c;
wire [31:0] z;
yMux4t01 #(32) my_mux(z, a0, a1, a2, a3, c);

initial
repeat (10)
begin

 a0 = $random;
 a1 = $random;
 a2 = $random;
 a3 = $random;
 c = $random % 2;
 #1;

 expect = ((a0 & ~a2) | (a2 & a1)) | ((a1 & ~a3) | (a3 & a2));
 #1; // wait for z
 if (expect === z)
   $display("PASS");
 else
   $display("FAIL: a0=%b a1=%b a2=%b a3=%b", a0, a1, a2, a3, expect);
end

endmodule
