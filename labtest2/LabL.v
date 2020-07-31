module yMux1(z, a, b, c); 
   output z; 
   input  a, b, c; 
   wire   notC, upper, lower; 
   not my_not(notC, c); 
   and upperAnd(upper, a, notC); 
   and lowerAnd(lower, c, b); 
   or my_or(z, upper, lower); 
endmodule // yMux1

module yMux(z, a, b, c); 
   parameter SIZE = 2; 
   output [SIZE-1:0] z; 
   input [SIZE-1:0]  a, b; 
   input 	     c; 
   yMux1 mine[SIZE-1:0](z, a, b, c); 
endmodule // yMux

module yMux4to1(z, a0,a1,a2,a3, c); 
   parameter SIZE = 2; 
   output [SIZE-1:0] z; 
   input [SIZE-1:0]  a0, a1, a2, a3; 
   input [1:0] 	     c; 
   wire [SIZE-1:0]   zLo, zHi; 
   yMux #(SIZE) lo(zLo, a0, a1, c[0]); 
   yMux #(SIZE) hi(zHi, a2, a3, c[0]); 
   yMux #(SIZE) final(z, zLo, zHi, c[1]); 
endmodule 

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

module mult4(HM,LM,A,B);
   output [3:0] HM, LM;
   input [3:0]  A, B;
   wire [3:0]   interm[0:3], cout, HMtmp;
   wire [3:0] 	gA0, tmp0; // gated A
   wire [3:0] 	gA1, tmp1; // gated A
   wire [3:0] 	gA2, tmp2; // gated A
   wire [3:0] 	gA3, tmp3; // gated A

   assign cout[0] = 1'b0;
   and and0[3:0](interm[0],A,B[0]);
   assign LM[0] = interm[0][0];
   
   ////
   assign LM[1] = interm[1][0];
   and and1[3:0](gA1, A, B[1]);
   yAdder #(.SIZE(4)) yadder1(interm[1],
				  cout[1],
				  {cout[0],interm[0][3:1]},
				  gA1,1'b0);
   ///
   assign LM[2] = interm[2][0];
   and and1[3:0](gA2, A, B[2]);
   yAdder #(.SIZE(4)) yadder2(interm[2],
			       cout[2],
			       {cout[1],interm[1][3:1]},
			       gA2,1'b0);
   ///
   assign LM[3] = interm[3][0];
   and and1[3:0](gA3, A, B[3]);
   yAdder #(.SIZE(4)) m_yadder3(interm[3],
			       cout[3],
			       {cout[2],interm[2][3:1]},
			       gA3,1'b0);
   
   assign HMtmp = interm[3];
   assign HM = { cout[3], HMtmp[3:1]};
endmodule

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

module LabL;
   parameter TSTSIZE = 4;
   
   reg  [TSTSIZE-1:0] a, b;
   reg [2*TSTSIZE-1:0] expM;
   wire [TSTSIZE-1:0]  HM, LM;
   
   integer 	      tmp;
   integer 	      i, j;
   mult #(.SIZE(TSTSIZE)) tstmult(HM,LM,a,b);
//   mult4  tstmult(HM,LM,a,b);
   
   initial
     begin
	repeat(200)
	  begin
	     a   = $random % (2^TSTSIZE);
	     b   = $random % (2^TSTSIZE);
	     expM = a*b;
	     #1;
	     if (expM!=={HM,LM})
	       $display("FAIL: a=%d, b=%d, expM=%d, {HM,LM} = %d\n",a,b,expM,{HM,LM});
	     
	     if (expM==={HM,LM})
	       $display("PASS: a=%d, b=%d, expM=%d, {HM,LM} = %d\n",a,b,expM,{HM,LM});
	     else
	       $display("FAIL: a=%d, b=%d, expM=%d, {HM,LM} = %d\n",a,b,expM,{HM,LM});
	  end // repeat (20)
	#1 $finish;

     end // initial begin
endmodule // LabL

	   