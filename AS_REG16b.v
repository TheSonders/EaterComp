// EEPROM for microcode logic
// Antonio Sanchez

module as_reg16b
  (input [8:0]address,
   output [15:0]result
  );
  reg [15:0]int_reg[511:0];
  assign result=int_reg[address];
  
initial 
	$readmemh ("microcode.txt",int_reg);
endmodule
