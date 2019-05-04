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
  
  reg [7:0] debounce;
  reg pulse;
  assign out_clock=~halt & ((system_clock & cont_enable)  | pulse);
  
  always @(posedge system_clock)
  debounce<=debounce+((manual_pulse)?(debounce<8'HFF)?8'H01:8'H00:(debounce>8'H00)?8'HFF:8'H00);
  
  always @(posedge system_clock)
  pulse<=(debounce==8'HFF)?1:(debounce==8'H00)?0:pulse;
  
  always @(negedge out_clock, posedge clr)
  deco_out<=clr?3'H00:((deco_out==4)?0:deco_out+3'H1);
 
endmodule
