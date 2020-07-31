

module yMux1(z, a, b, c);
output z;
input a, b, c;
wire notC, upper, lower;

not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower, c, b);
or my_or(z, upper, lower);

endmodule 

module yMux2(z, a, b, c);
    parameter SIZE = 2;
    output [SIZE-1:0] z;
    input [SIZE-1:0] a, b;
    input c;

    yMux1 min[SIZE-1:0](z, a, b, c);

endmodule

module yMux4to1(z, a0,a1,a2,a3, c);

    parameter SIZE = 2;
    output [SIZE-1:0] z;
    input [SIZE-1:0] a0, a1, a2, a3;
    input [1:0] c;
    wire [SIZE-1:0] zLo, zHi;

    yMux2 #(SIZE) lo(zLo, a0, a1, c[0]);
    yMux2 #(SIZE) hi(zHi, a2, a3, c[0]);
    yMux2 #(SIZE) final(z, zLo, zHi, c[1]);

endmodule

module labL;
parameter SIZE = 4;
reg [SIZE-1:0]a, b, x, y, expZ;
reg [1:0] c;
wire [SIZE-1:0]z;
integer i, j, k;

yMux4to1 #(SIZE) mux2(z, a, b, x, y, c);

initial
    repeat(500)
    begin
        a = $random; b = $random; c = $random; x = $random; y = $random;
        expZ = (a&~c)+(b&c);
        #1 if(!(expZ === z))
            $display("FAIL time=%2d a=%2b b=%2b c=%b z=%2b expZ=%2b", $time, a, b, c, z, expZ);
    end
endmodule
