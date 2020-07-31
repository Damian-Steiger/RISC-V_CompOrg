
module yAdder1(z, cout, a, b, cin);

    output z, cout;
    input a, b, cin;

    xor left_xor(tmp, a, b);
    xor right_xor(z, cin, tmp);
    and left_and(outL, a, b);
    and right_and(outR, tmp, cin);
    or my_or(cout, outR, outL);

endmodule

module labL5;

reg  a, b, cin, exp;
wire cout, z;

yAdder1 add(z, cout, a, b, cin);

initial
    begin
    a=0; b=0; cin=0;
        repeat(8)
        begin
            a++; b++; cin++;
            exp = a + b + cin;
            #1 if((z === exp))
                $display("PASS | a=%b b=%b cin=%b z=%b", a, b, cin, z);
            else
                $display("FAIL | a=%b b=%b cin=%b z=%b exp=%b", a, b, cin, z, exp);
        end
    end

endmodule

