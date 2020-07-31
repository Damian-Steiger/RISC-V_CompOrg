
module yAdder1(z, cout, a, b, cin); 
   output z, cout; 
   input  a, b, cin; 
   xor left_xor(tmp, a, b); 
   xor right_xor(z, cin, tmp); 
   and left_and(outL, a, b); 
   and right_and(outR, tmp, cin); 
   or my_or(cout, outR, outL); 
endmodule

module yAdder(s, cout, a, b, cin);
   parameter SIZE = 2;
   output [SIZE-1:0] s; 
   output 	 cout; 
   input [SIZE-1:0]  a, b; 
   input 	 cin; 
   wire [SIZE-1:0] 	 in, out; 
   yAdder1 mine[SIZE-1:0](s, out, a, b, in); 
   assign {cout,in} = {out,cin};
endmodule // yAdder

module mult(HM,LM,A,B);
   parameter SIZE = 4;
   output [SIZE-1:0] HM, LM;
   input [SIZE-1:0]  A, B;
   wire [SIZE-1:0]   interm[0:SIZE-1], cout, HMtmp;

   genvar 	     i;
   assign cout[0] = 1'b0;
   and and0[SIZE-1:0](interm[0],A,B[0]);
   assign LM[0] = interm[0][0];
   
   for (i=1; i<SIZE; i=i+1) begin
      wire [SIZE-1:0] gA, tmp; // gated A

      assign LM[i] = interm[i][0];
      
      and and1[SIZE-1:0](gA, A, B[i]);
      yAdder #(.SIZE(SIZE)) m_yadder(interm[i],
				     cout[i],
				     {cout[i-1],interm[i-1][SIZE-1:1]},
				     gA,1'b0);
   end // for (i=1; i<SIZE; i=i+1)
   assign HMtmp = interm[SIZE-1];
   assign HM = { cout[SIZE-1], HMtmp[SIZE-1:1]};
endmodule