module labL5;
reg a, b, cin, expect;
output cout;
wire z;
integer i, j, k;
yAdder1 test(z, cout, a, b, cin);

initial
begin
        for (i = 0; i < 2; i = i + 1)
        begin
          for (j = 0; j < 2; j = j + 1)
          begin
            for (k = 0; k < 2; k = k + 1)
            begin
              a = i; b = j; cin = k;
              expect = (~(cin &(~(a&b))));
              #1; // wait for z
              if (expect === z)
                $display("PASS: a=%b b=%b z=%b", a, b, z);
              else
                $display("FAIL: a=%b b=%b z=%b - EXPECTED: z=%b", a, b, z, expect);
            end
          end
        end
        $finish;

end
endmodule
