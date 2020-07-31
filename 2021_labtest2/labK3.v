

module labK;
    
    reg a, b, exp; // reg without size means 1-bit
    wire tmp, z;
    integer i, j;

    not my_not(tmp, b);
    and my_and(z, a, tmp);
    
    initial
    begin
        for(i = 0; i < 2; i = i + 1)
            begin
            for(j = 0; j < 2; j = j + 1)
                begin
                a = i; b = j;
                exp = a & ~b;
                #1
                if(exp === z)
                    $display("PASS | a=%b b=%b z=%b", a, b, z);
                else
                    $display("FAIL | a=%b b=%b z=%b", a, b, z);
                end
            end
        $finish;
    end
endmodule