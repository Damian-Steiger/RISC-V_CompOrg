

module labK;

reg a, b, c, exp;
wire top, bot, z;
integer i, j, k;

not(notC, c);
and(top, a, notC);
and(bot, b, c);
or(z, top, bot);

initial
begin
    for(i = 0; i < 2; i++)
        begin
        for(j = 0; j < 2; j++)
            begin
            for(k = 0; k < 2; k++)
                begin
                a = i; b = j; c = k;
                exp = (a & ~c) + (c & b);
                #1 if(exp === {z})
                    $display("PASS time=%2d a=%b b=%b c=%b z=%b", $time, a, b, c, z);
                else
                    $display("FAIL time=%5d a=%b b=%b c=%b z=%b exp=%b", $time, a, b, c, z, exp);
                end
            end
        end
end
endmodule