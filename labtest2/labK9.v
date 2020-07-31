

module labK;

reg a, b, cin, expZ, expC;
wire z, cout, topA, botA, topB;
integer i, j, k;

not(notA, a);
not(notB, b);
not(notC, c);
not(notCIN, cin);
not(notTOPA, topA);

or(temp1, a, b);
or(temp2, notA, notB);
and(topA, temp1, temp2);

and(botA, a, b);

or(temp3, cin, topA);
or(temp4, notCIN, notTOPA);
and(z, temp3, temp4);

and(topB, cin, topA);

or(cout, topB, botA);


initial
    begin
        for(i = 0; i < 2; i++)
            begin
                for(j = 0; j < 2; j++)
                    begin
                        for(k = 0; k < 2; k++)
                            begin
                            a = i; b = j; cin = k;
                            //wrong expZ = a;
                            //wrong expC = a;
                            #1 if(expZ === z && expC === cout)
                                $display("PASS time=%2d a=%b b=%b c=%b z=%b", $time, a, b, c, z);
                            else
                                $display("FAIL time=%2d a=%b b=%b c=%b z=%b expZ=%b expC=%b", $time, a, b, c, z, expZ, expC);
                            end
                    end
            end
    end

endmodule