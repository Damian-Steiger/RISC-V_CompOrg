

module yMux1(z, a, b, c);
output z;
input a, b, c;
wire notC, upper, lower;

not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower, c, b);
or my_or(z, upper, lower);

endmodule 

module labL;
reg a, b, c, expZ, expC;
wire z, cout;
integer i, j, k;

yMux1 mux1(z, a, b, c);

initial
    begin
        for(i = 0; i < 2; i++)
            begin
                for(j = 0; j < 2; j++)
                    begin
                        for(k = 0; k < 2; k++)
                            begin
                            a = i; b = j; c = k;
                            expZ = (a&~c)+(b&c);
                            #1 if(expZ === z)
                                $display("PASS time=%2d a=%b b=%b c=%b z=%b", $time, a, b, c, z);
                            else
                                $display("FAIL time=%2d a=%b b=%b c=%b z=%b expZ=%b", $time, a, b, c, z, expZ);
                            end
                    end
            end
    end

endmodule
