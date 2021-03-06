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

module sllreg(Q, dt, shl, ld, clk, reset);
   parameter SIZE = 3;		// I like to put weird numbers to make
   output [SIZE-1:0] Q;		// verilog give warnings if not all is not OK
   input [SIZE-1:0]  dt;
   input 	     shl, ld, clk, reset;
   wire [SIZE-1:0]   inp;
   
   rregister #(SIZE) myreg(Q, inp, clk, 1'b1, reset);
   yMux4to1 #(SIZE) mymux(inp, 
			  Q, 
			  { Q[SIZE-2:0], 1'b0 },
			  dt,
			  {SIZE{1'b0}},
			  {ld, shl});
endmodule

module cntr(Z, cnt, clk, reset);
   parameter SIZE = 10;
   output reg Z;
   input      cnt, clk, reset;
   wire       notcnt;
   wire [SIZE-1:0] regout;

   not(notcnt,cnt);
   
   sllreg #(SIZE) cntreg(regout, 
			 {{(SIZE-1){1'b0}}, 1'b1}, 
			 cnt, notcnt, clk, reset);
   always @(regout)
     Z = (regout==0)?1'b1:1'b0;
endmodule   

module itmult(HM, LM, fin, A, B, clk, start, reset);

    parameter SIZE = 4;
    output [SIZE-1:0] HM, LM;
    input [SIZE-1:0] A, B;
    output fin;
    input start, clk, reset;
    wire cout;
    wire [SIZE-1:0] addout, gA;
    wire [2*SIZE-1:0] muxout, accum;

    and gatedA[SIZE-1:0] (gA, A, accum[0]);
    rregister #(2*SIZE) reg1(accum, muxout, clk, 1'b1, reset);
    yMux #(2*SIZE) mult1(muxout, {{SIZE{1'b0}},B},{cout,addout,accum[SIZE-1:1]}, start);
    yAdder #(SIZE) add1(addout, cout, gA, accum[2*SIZE-1:SIZE], 1'b0);
    cntr #(SIZE) count1(fin, start, clk, reset);
    
    assign {HM, LM} = accum;    

endmodule

module labN;

    parameter SIZE = 4;
    reg [SIZE-1:0] A, B;
    wire [SIZE-1:0] HM, LM;
    wire fin;
    reg clk, start, reset;
    integer i, j;

    itmult #(SIZE) multEx(HM, LM, fin, A, B, clk, start, reset);

    initial
        begin
           repeat(5)
            begin
                i = $random; j = $random;
                clk = 1'b0;
                #2;
                reset = 1'b1;
                #2;
                reset = 1'b0;
                #2;
                start = 1'b0;
                A = i;
                B = j;
                #2;
                clk = 1'b1; #2 clk = 1'b0; #2;
                start = 1'b1;
                repeat(SIZE)
                    begin
                        #2 $display("%4d: {HM,LM}=%d, HM=%d, LM=%d, A=%d, B=%d, fin=%b", $time, {HM,LM}, HM, LM, A, B, fin);
                        clk = 1'b1; #2 clk = 1'b0; #2;
                        if (fin==1'b1 && start==1'b1) 
                            begin
                                $display("RESULT at %4d: {HM,LM}=%d", $time, {HM,LM});
                                start =1'b0;
                            end
                    end
            end  
        end

endmodule