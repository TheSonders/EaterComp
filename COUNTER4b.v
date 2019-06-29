// 4bit counter with load,clear a count enable and tristate output
// Antonio Sanchez
module counter4b
  (inout [3:0]bus,
   input load,
   input out,
   input enable,
   input clr,
   input clk
  );
	
  reg [3:0] int_reg	
  assign bus=out?int_reg:4'bzzzz;
    
  always @(posedge clk, posedge clr)
  int_reg<=(clr)?4'H0:(load)?bus:(enable)?(int_reg+4'H1):int_reg;
  
endmodule
