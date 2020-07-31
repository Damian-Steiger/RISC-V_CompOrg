

module LabK;
   reg a, b, c;
   reg [2:0] expected;
   wire x, y, z;
   wire nota, notb, notc, notab, notac, anotb, notbc, bnotc;
   integer i, j, k;

   assign x = a;
   not(nota,a);
   not(notb,b);
   not(notc,c);
   or(y, notab, anotb);
   or(z, notbc, bnotc);
   and(notab, nota, b);
   and(anotb, a, notb);
   and(notbc, notb, c);
   and(bnotc, b, notc);

    initial
    begin
        for (i = 0; i < 2; i = i + 1)
            for (j = 0; j < 2; j = j + 1)
                for (k = 0; k < 2; k = k + 1)
                begin
                    a = i; b = j; c = k;
                    expected = {a, a^b, b^c};
                    #1 if (expected === {x, y, z})
                        $display("PASS a=%b b=%b c=%b | x=%b y=%b z=%b", a, b, c, x, y, z);
                    else
                        $display("FAILED a=%b b=%b c=%b | x=%b y=%b z=%b | Expected =%3b", a, b, c, x, y, z, expected);
                end
        $finish;
    end
endmodule
