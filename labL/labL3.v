module labL2;
reg [31:0] a, b, expect;
reg c;
wire [31:0] z;
integer i, j, k;
yMux #(32) my_mux(z, a, b, c);

initial
begin
        for (i = 0; i < 32; i = i + 1)
        begin
          for (j = 0; j < 32; j = j + 1)
          begin
            for (k = 0; k < 32; k = k + 1)
            begin
              a = i; b = j; c = k;
              expect = (a & ~c) | (c & b);
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
