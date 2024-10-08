`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:43:21 05/30/2024 
// Design Name: 
// Module Name:    ahb_decoder 
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

module decoder(
  input [2:0] sel,
  output reg [3:0] slave_sel
);

  always @(*) begin
    case(sel)
      3'b000: slave_sel = 4'b0001;
      3'b001: slave_sel = 4'b0010;
      3'b010: slave_sel = 4'b0100;
      3'b011: slave_sel = 4'b1000;
		3'b100: slave_sel = 4'b0000;
    endcase
  end
endmodule

