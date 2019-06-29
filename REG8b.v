// 8 bits register with asyncronous clear and bus inout
// Antonio Sanchez
module reg8b
  (inout [7:0]bus,
   input in,
   input out,
   input clr,
   input clk,
   output reg [7:0]int_reg 
  );
  
  assign bus=out?int_reg:8'bzzzzzzzz;
  
  always @(posedge clk,posedge clr)
  int_reg<=clr?8'h00:in?bus:int_reg;
  
endmodule