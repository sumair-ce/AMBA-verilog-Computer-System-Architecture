`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:46:06 06/04/2024 
// Design Name: 
// Module Name:    dataholder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dataholder(input clk, output reg [31:0] place_address,
output reg [31:0] place_data
    );
	 
	 reg [31:0]a [31:0];
	 reg [31:0]d [31:0];
	 
	 (*RAM_STYLE = "BLOCK" *)
initial begin
$readmemh("datamem.txt", d, 0,1);
end

(*RAM_STYLE = "BLOCK" *)
initial begin
$readmemh("addmem.txt", a, 0 ,1);
end

	 
	 always @(posedge clk) begin
	 place_address <= a[0];
	 place_data <= d[0];
	 end


endmodule
