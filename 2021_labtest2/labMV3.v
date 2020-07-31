module rff(q, d, clk, enable, reset);
   /****************************
    An Edge-Triggerred Flip-flop 
    Written by H. Roumani, 2008.
    resaet added by M. Spetsakis, 2019
    ****************************/
   output q;
   input  d, clk, enable, reset;
   reg 	  q;

   always @(posedge reset)
     q<= 1'b0;
   always @(posedge clk)
     if (enable) q <= d; 
endmodule

module rregister(q, d, clk, enable, reset);
   /****************************
    An Edge-Triggerred Register.
    Written by H. Roumani, 2008.
    resaet added by M. Spetsakis, 2019
    ****************************/
   parameter SIZE = 2;
   output [SIZE-1:0] q;
   input [SIZE-1:0]  d;
   input 	     clk, enable, reset;

   rff myFF[SIZE-1:0](q, d, clk, enable, reset);
endmodule // rregister
	    
module yMux1(z, a, b, c); 
   output z; 
   input  a, b, c; 
   wire   notC, upper, lower; 
   not my_not(notC, c); 
   and upperAnd(upper, a, notC); 
   and lowerAnd(lower, c, b); 
   or my_or(z, upper, lower); 
endmodule // yMux1

module yMux(z, a, b, c); 
   parameter SIZE = 7; 
   output [SIZE-1:0] z; 
   input [SIZE-1:0]  a, b; 
   input 	     c; 
   yMux1 mine[SIZE-1:0](z, a, b, c); 
endmodule // yMux

module yMux4to1(z, a0,a1,a2,a3, c); 
   parameter SIZE = 2; 
   output [SIZE-1:0] z; 
   input [SIZE-1:0]  a0, a1, a2, a3; 
   input [1:0] 	     c; 
   wire [SIZE-1:0]   zLo, zHi; 
   yMux #(SIZE) lo(zLo, a0, a1, c[0]); 
   yMux #(SIZE) hi(zHi, a2, a3, c[0]); 
   yMux #(SIZE) final(z, zLo, zHi, c[1]); 
endmodule 

module yAdder1(z, cout, a, b, cin); 
   output z, cout; 
   input  a, b, cin; 
   xor left_xor(tmp, a, b); 
   xor right_xor(z, cin, tmp); 
   and left_and(outL, a, b); 
   and right_and(outR, tmp, cin); 
   or my_or(cout, outR, outL); 
endmodule

module yAdder(s, cout, a, b, cin);
   parameter SIZE = 2;
   output [SIZE-1:0] s; 
   output 	 cout; 
   input [SIZE-1:0]  a, b; 
   input 	 cin; 
   wire [SIZE-1:0] 	 in, out; 
   yAdder1 mine[SIZE-1:0](s, out, a, b, in); 
   assign {cout,in} = {out,cin};
endmodule // yAdder 

module sllreg(Q, dt, shl, ld, clk);

    parameter SIZE = 4;
    output [SIZE-1:0] Q;
    input ld, shl, clk;
    input [SIZE-1:0] dt;
    wire [SIZE-1:0] muxOut;

    yMux4to1 #(SIZE) mul1(muxOut, Q, { Q[SIZE-2:0], 1'b0 }, dt, {SIZE{1'b0}}, {ld, shl});
    rregister #(SIZE) reg1(Q, muxOut, clk, 1'b1, 1'b0);

endmodule

module labN;
   parameter SIZE = 4;
   reg shl, ld, clk;
   wire [SIZE-1:0] Q;
   reg [SIZE-1:0] dt;

   sllreg #(SIZE) sllreg1(Q, dt, shl, ld, clk);

   initial
      begin
         shl = 1'b0;
         ld  = 1'b1;
         repeat (6)
         #5 clk = ~clk;
         shl = 1'b1;
         ld  = 1'b0;
         repeat (6)
         #5 clk = ~clk;
         shl = 1'b0;
         ld  = 1'b0;
         repeat (6)
         #5 clk = ~clk;
         shl = 1'b1;
         ld  = 1'b1;
         repeat (6)
         #5 clk = ~clk;

         $finish;
         end

   initial
      begin
      #2
         shl = 1'b1;
         ld = 1'b1;
         clk = 1'b1;
      end

   initial
      #4 $monitor("%4d:  clk=%b, Q=%d shl=%b, ld=%b", $time, clk, Q, shl, ld);

endmodule

module cntr(Z, cnt, clk);

   parameter SIZE = 5;
   output reg Z;
   input cnt, clk;
   wire notCnt;
   wire [SIZE-1:0] regout;

   not(notCnt, cnt);
   sllreg #(SIZE) sllreg1(regout, {{(SIZE-1){1'b0}}, 1'b1}, cnt, notcnt, clk);
   always @(regout)
   Z = (regout==0)?1'b1:1'b0;

endmodule

module labN2;
   parameter SIZE = 4;
   reg cnt, clk;
   wire out;

   cntr #(SIZE) cntr(out, cnt, clk);

   initial
      begin
         cnt = 1'b0;
         clk  = 1'b1;
         repeat (6)
         #5 clk = ~clk;
         cnt = 1'b1;
         clk  = 1'b0;
         repeat (6)
         #5 clk = ~clk;
         cnt = 1'b0;
         clk  = 1'b0;
         repeat (6)
         #5 clk = ~clk;
         cnt = 1'b1;
         clk  = 1'b1;
         repeat (6)
         #5 clk = ~clk;

         $finish;
         end

   initial
      begin
      #2
         cnt = 1'b1;
         clk = 1'b1;
      end

   initial
      #4 $monitor("%4d:  clk=%b, cnt=%b out=%b", $time, clk, cnt, out);
endmodule