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

module mult4(HM, LM, a, b);
    parameter SIZE = 4;
    output [SIZE-1:0] HM, LM;
    input [SIZE-1:0] a, b;
    wire [SIZE-1:0] s0, s1, s2, s3, gA1, gA2, gA3;
    wire cout1, cout2, cout3;

    // 4 gated statements
    and and0[SIZE-1:0](s0, a, b[0]);
    and and1[SIZE-1:0](gA1, a, b[0]);
    and and1[SIZE-1:0](gA2, a, b[1]);
    and and1[SIZE-1:0](gA3, a, b[2]);

    // 4 adders
    yAdder #(SIZE) addq(s1, cout1, {1'b0, s0[3:1]}, gA1, 1'b0);
    yAdder #(SIZE) add2(s2, cout2, {cout1,s1[3:1]}, gA2, 1'b0);
    yAdder #(SIZE) add3(s3, cout3, {cout2,s2[3:1]}, gA3, 1'b0);

    // assign high and low values
    assign LM = {s3[0], gA3[0], gA2[0], gA1[0]};
    assign HM = {cout3, s3[3], s3[2], s3[1]};

endmodule

module labL;
    parameter SIZE = 4;
    reg [SIZE-1:0]a, b;
    wire [SIZE-1:0]HM, LM;

    mult4 #(SIZE) mult1(HM, LM, a, b);

    initial
        begin
            repeat(5)
            begin
                a=$random; b=$random;
                #2
                $display("a=%d b=%d ANS=%d", a, b, {HM, LM});
            end
        end


endmodule