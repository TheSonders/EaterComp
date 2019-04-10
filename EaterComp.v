// Modular Verilog implementation of
// Ben Eater's 8bit breadboard computer
// Antonio Sanchez

`define HLT  0
`define MI   1
`define RI   2
`define RO   3
`define IO   4
`define II   5
`define AI   6
`define AO   7
`define EO   8
`define SU   9
`define BI  10
`define OI  11
`define CE  12
`define CO  13
`define J   14
`define FI  15

module EaterComp
  (inout [7:0] bus,
   input clr,
   input clk,cont_enable,manual_pulse,halt
  );
  
  wire out_clock;
  wire [2:0] clock_decoder;
  wire [15:0] control_word;
  wire [7:0] A;
  wire [7:0] B;
  wire [7:0] IR;
  
  reg8b REGA
  (.bus(bus),
   .in(control_word[`AI]),
   .out(control_word[`AO]),
   .clr(clr),
   .clk(out_clock),
   .int_reg (A)
  );
   reg8b REGB
  (.bus(bus),
   .in(control_word[`BI]),
   .out(1'b0),
   .clr(clr),
   .clk(out_clock),
   .int_reg (B)
  );

  reg8b I_R
  (.bus(bus),
   .in(control_word[`II]),
   .out(control_word[`IO]),
   .clr(clr),
   .clk(out_clock),
   .int_reg (IR)
  );
  
	clock CLOCK
  (.system_clock(clk),
   .cont_enable(cont_enable),
   .manual_pulse(manual_pulse),
   .halt(halt),
   .out_clock(out_clock),
   .deco_out (clock_decoder)
  );
  
  counter4b PC
  (.bus(bus[3:0]),
   .load(control_word[`J]),
   .out(control_word[`CO]),
   .enable(control_word[`CE]),
   .clr(clr),
   .clk(out_clock)
  );
  
  alu8b ALU
  (.bus(bus),
   .carry(CF),
   .zero(ZF),
   .a(A),
   .b(B),
   .sub(control_word[`SU]),
   .out(control_word[`EO]),
   .clr(clr),
   .clk(out_clock)
  );
  
  as_reg16b MICROCODE
  (.address({ZF,CF,IR[7:4],clock_decoder}),
   .result(control_word)
  );
  
endmodule