// 16 bytes RAM with address load enable, bus in & bus out
// Antonio Sanchez
module ram
  (inout [7:0]bus,
   input address_load,
   input out,
   input load,
   input clr,
   input clk
  );
  reg [7:0]ram [16];
  reg [3:0]mar;
  
  assign bus=out?ram[mar]:8'bzzzzzzzz;
  
  initial
  $readmemh ("example.txt",ram);
  
  always @(posedge clk or posedge clr)
  mar<=(clr)?4'H0:(address_load)?bus:mar;
  
  always @(posedge clk)
  ram[mar]<=(load)?bus:ram[mar];
endmodule