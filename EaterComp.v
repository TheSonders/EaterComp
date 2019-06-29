// Modular Verilog implementation of
// Ben Eater's 8bit breadboard computer
// Antonio Sanchez


`define HLT  15	//Halt
`define MI   14	//Memory address IN
`define RI   13	//RAM IN
`define RO   12	//RAM OUT
`define IO   11	//Instruction Register OUT
`define II   10	//Instruction Register IN
`define AI   9		//Register A IN
`define AO   8		//Register A OUT
`define EO   7		//SUM OUT
`define SU   6		//ALU Substract
`define BI   5		//Register B IN
`define OI   4		//Display IN
`define CE   3		//Program Counter Enable
`define CO   2		//Program Counter OUT
`define J    1		//Program Counter IN
`define FI   0		//ALU Flags LOAD


module EaterComp
  (input clr,
   input clk,cont_enable,manual_pulse,
   input disp_mode,
	input switch_bus,switch_PC,switch_A,switch_Display,
   output [3:0] cc,
   output [7:0] anode,
	output [7:0] leds
  );
  
  tri [7:0] bus;
  wire out_clock;
  wire [2:0] clock_decoder;
  wire [15:0] control_word;
  wire [7:0] A;
  wire [7:0] B;
  wire [7:0] IR;
  wire ZF,CF;

	assign leds=(switch_bus)?bus:(switch_PC)?PC_Copy:(switch_A)?A:(switch_Display)?Display_Copy:control_word[7:0];

	//Common anode
	wire [3:0] intcc;
	wire [7:0] intanode;
	reg [15:0] clkpres;
	wire [3:0] PC_Copy;
	wire [7:0]Display_Copy;
	assign cc=intcc;
	assign anode=~intanode;
	assign intclk=clkpres[15];
	
	always @(posedge clk) clkpres=clkpres+1'b1;
	
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
  (.system_clock(intclk),
   .cont_enable(cont_enable),
   .manual_pulse(manual_pulse),
   .clr(clr),
   .halt(control_word[`HLT]),
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
	,.int_reg(PC_Copy)
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
   .clk(out_clock),
   .fi(control_word[`FI])
  );
  
  as_reg16b MICROCODE
  (.address({ZF,CF,IR[7:4],clock_decoder}),
   .result(control_word)
  );
  
 outdisplay OUTPUT
  (.disp_mode(disp_mode),
   .clk(out_clock),
   .clr(clr),
   .bus(bus),
   .oi(control_word[`OI]),
   .cc(intcc),
   .anode(intanode)
	,.int_reg(Display_Copy)
  );
  
  ram RAM
  (.bus(bus),
   .address_load(control_word[`MI]),
   .out(control_word[`RO]),
   .load(control_word[`RI]),
   .clr(clr),
   .clk(out_clock)
  );
  
  
endmodule