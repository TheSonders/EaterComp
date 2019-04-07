// 8bit adder ALU with subtract and carry and zero flags
// Antonio Sanchez
module alu8b
  (output [7:0]bus,
   output carry,
   output zero,
   input [7:0]a,
   input [7:0]b,
   input sub,
   input out,
   input clr,
   input clk
  );
  wire [7:0]int_reg;
  assign {carry,int_reg}=a+(b^{8{sub}})+sub;
  assign zero=(int_reg==0);
  assign bus=out?int_reg:8'Bzzzzzzzz;
  
endmodule