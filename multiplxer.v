`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:45:11 05/30/2024 
// Design Name: 
// Module Name:    ahb_multiplexer 
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

module multiplexer(
  input [31:0] hrdata1,
  input [31:0] hrdata2,
  input [31:0] hrdata3,
  input [2:0] sel,
  output reg [31:0] hrdata
);

  always @(*) begin
  //if (!rdata_iv1 || !rdata_iv2 || !rdata_iv3 ) begin
    case(sel)
      3'b000: hrdata = hrdata1; // No slave selected
      3'b001: hrdata = hrdata2;
      3'b010: hrdata = hrdata3;
      3'b011: hrdata = 32'b0; // No slave selected
      default: hrdata = 32'b0;
    endcase
	//end
  end
endmodule

