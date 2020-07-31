

module labKTest;
    parameter SIZE = 10;
    reg [31:0] x, y, z;

    initial
        begin
            #(SIZE) x = 5;
            //$display("%2d: x=%1d y=%1d z=%1d", $time, x, y, z);
            #(SIZE) y = x + 1;
            //$display("%2d: x=%1d y=%1d z=%1d", $time, x, y, z);
            #(SIZE) z = y + 1;
            //$display("%2d: x=%1d y=%1d z=%1d", $time, x, y, z);
        #1 $finish;
    end

    initial
        $monitor("%2d: x=%1d y=%1d z=%1d", $time, x, y, z);

    always
        #7 x++;

    /*initial
        begin
        repeat(4)
            #7 x++;
        end
    */

endmodule