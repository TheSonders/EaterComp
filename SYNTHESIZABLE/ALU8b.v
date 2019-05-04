// 8bit adder ALU with subtract and carry and zero flags
// Antonio Sanchez
module alu8b
  (output [7:0]bus,
   output reg carry,
   output reg zero /*synthesis syn_noprune=1*/,
   input [7:0]a,
   input [7:0]b,
   input sub,
   input out,
   input clr,
   input clk,
   input fi
  );
  wire [7:0]int_reg /*synthesis syn_noprune=1*/;
  wire int_carry,int_zero;
  assign {int_carry,int_reg}=a+(b^{8{sub}})+sub;
  assign int_zero=~|{int_carry, int_reg};
  assign bus=out?int_reg:8'Bzzzzzzzz;
  
  always @ (posedge clk,posedge clr) begin
	carry<=(clr)?0:(fi)?int_carry:carry;
	zero<=(clr)?0:(fi)?int_zero:zero; end
endmodule
