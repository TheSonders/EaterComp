// Auto/manual clock with manual pulse debounce
// Antonio Sanchez
module clock
  (input system_clock,
   input cont_enable,
   input manual_pulse,
   input clr,
   input halt,
   output out_clock,
   output reg [2:0] deco_out 
  );
  
  reg [5:0] debounce;
  reg pulse;
  assign out_clock=(~halt) & ((system_clock & cont_enable)  | pulse);
  
  always @(posedge system_clock)
  debounce<=debounce+((manual_pulse)?(debounce<6'h3F)?6'h01:6'h00:(debounce>6'h00)?6'h3F:6'h00);
  
  always @(posedge system_clock)
  pulse<=(debounce==6'h3F)?1:(debounce==6'h00)?0:pulse;
  
  always @(negedge out_clock, posedge clr) begin
	deco_out<=clr?3'H00:((deco_out==4)?0:deco_out+3'H1);end
 
endmodule
