// EEPROM for microcode logic
// Antonio Sanchez

`define HLT  15	//Halt
`define MI   14	//Memory address IN
`define RI   13	//RAM IN
`define RO   12	//RAM OUT
`define IO   11	//Instruction Register OUT
`define II   10	//Instruction Register IN
`define AI   9	//Register A IN
`define AO   8	//Register A OUT
`define EO   7	//SUM OUT
`define SU   6	//ALU Substract
`define BI   5	//Register B IN
`define OI   4	//Display IN
`define CE   3	//Program Counter Enable
`define CO   2	//Program Counter OUT
`define J    1	//Program Counter IN
`define FI   0	//ALU Flags LOAD


module as_reg16b
  (input [8:0]address,
   output [15:0]result
  );
  reg [15:0]int_reg[511:0];
  assign result=int_reg[address];
  
initial 
	$readmemh ("microcode.txt",int_reg);
endmodule
