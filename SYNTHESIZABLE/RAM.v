// 16 bytes RAM with address load enable, bus in & bus out
// Antonio Sanchez

module ram
  (inout [7:0]bus/* synthesis syn_tristate = 1 */,
   input address_load,
   input out,
   input load,
   input clr,
   input clk
  );
  reg [7:0]ram [16] /*synthesis syn_noprune=1*/;
  reg [3:0]mar;
  reg [7:0]int_reg/*synthesis syn_noprune=1*/;
  
  assign bus=out?int_reg:8'bzzzzzzzz;
  
  initial
  $readmemh ("example.txt",ram);
  
  always @(posedge clk)begin 
  mar<=(clr)?4'H0:(address_load)?bus[3:0]:mar;
  int_reg<=(clr)?8'H00:ram[mar]; end
  
  always @(posedge clk)
  ram[mar]<=(load)?bus:ram[mar];
endmodule