

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

module labL;
parameter SIZE = 32;
reg [SIZE-1:0]a, b, expZ;
reg c;
wire [SIZE-1:0]z;
integer i, j, k;

yMux2 #(SIZE) mux2(z, a, b, c);

initial
    begin
        for(i = 0; i < 4; i++)
            begin
                for(j = 0; j < 4; j++)
                    begin
                        for(k = 0; k < 2; k++)
                            begin
                            a = i; b = j; c = k;
                            expZ = (a&~c)+(b&c);
                            #1 if(expZ === z)
                                $display("PASS time=%2d a=%2b b=%2b c=%b z=%2b", $time, a, b, c, z);
                            else
                                $display("FAIL time=%2d a=%2b b=%2b c=%b z=%2b expZ=%2b", $time, a, b, c, z, expZ);
                            end
                    end
            end
    end

endmodule
