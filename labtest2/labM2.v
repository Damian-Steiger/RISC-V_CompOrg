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

module sllreg(Q, dt, shl, ld, clk);

    parameter SIZE = 3;
    output [SIZE-1:0] regout, Q;
    input [SIZE-1:0] dt;
    input shl, ld, clk;
    wire [SIZE-1:0] inp;

    rregister #(SIZE) reg1(regout, inp, clk, 1'b1, 1'b0);
    yMux4to1 #(SIZE) mul1(inp, Q, {Q[SIZE-2:0], 1'b0}, dt, {SIZE{1'b0}}, {ld, shl});

    assign Q = regout;

endmodule

module LabM;

    parameter SIZE = 4;
    wire [SIZE-1:0] Q;
    reg [SIZE-1:0] dt;
    reg shl, ld, clk;
    integer i, j;

    sllreg #(SIZE) sllreg1(Q, dt, shl, ld, clk);

    initial
        begin
            repeat(4)
                begin
                    repeat(4)
                        begin
                        #1
                            shl = $random %2; ld = $random %2; clk = 1'b1; dt = 1'b1;
                        end
                end
                
        end

    initial
    repeat(16)
        #1 $display("time=%4d ld=%b shl=%b Q=%4b", $time, ld, shl, Q);

endmodule