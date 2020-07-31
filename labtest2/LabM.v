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
   parameter SIZE = 2; 
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

module sllreg(dt, shl, ld, clk);
    parameter SIZE = 4;
    output [SIZE-1:0]Q;
    reg [SIZE-1:0] dt;
    reg shl, ld, clk;
    wire [SIZE-1:0]inp;

    register #(SIZE) reg1(Q, inp, clk, 1'b1);
    yMux4to1 #(SIZE) mul1(inp, Q, {Q[SIZE-2], 1'b0}, dt, {SIZE{1'b0}}, {ld, shl});

endmodule

module register();


endmodule

module cntr(Z, cnt, clk);
    parameter SIZE = 4;
    output reg Z;
    input cnt, clk;
    wire notcnt;

    not(notcnt, cnt);
    sllreg #(SIZE) cntreg(regout, {{(SIZE-1){1'b0}}, 1'b1}, cnt, notcnt, clk);
    always @(regout)
        Z = (regout==0)?1'b1:1'b0;

endmodule 

module LabM;
    parameter SIZE = 4;
    reg clk, cnt;
    wire Z;

    cntr #(SIZE) mycntr(Z,cnt, clk);

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
                clk = 0;
                #2000 $finish;
            end
        initial
            $monitor("%4d:  clk=%b, Z=%d, cnt=%b", $time, clk, Z, cnt);
endmodule