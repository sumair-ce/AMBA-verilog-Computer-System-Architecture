`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:36:02 06/04/2024 
// Design Name: 
// Module Name:    SevenSegment 
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:33:21 03/19/2024 
// Design Name: 
// Module Name:    SevenSegment 
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
module SevenSegment (
 input clk,
 input [31:0] address,
 input [31:0] data,
 input [31:0] coming_data,
 input [1:0] switch,
 output reg [3:0] enable,
 output reg [6:0] LED_out
);

 reg [3:0] sseg;
 reg [3:0] dig0, dig1, dig2, dig3;
 
 localparam N = 21; //local parameter to save size
 reg [N-1:0] count2 = 0; //counter that will count 400000
 reg [1:0] count = 0; //counter that will count till 4
 
 always @(posedge clk) begin //slicing of 16 bits in 4 parts
	case (switch)
	
		2'b00: begin dig0 <= address[3:0]; dig1 <= address[7:4]; dig2 <= address[11:8]; dig3 <= address[15:12]; end
		
		2'b01: begin dig0 <= data[3:0]; dig1 <= data[7:4]; dig2 <= data[11:8]; dig3 <= data[15:12]; end
		
		2'b10: begin dig0 <= coming_data[3:0]; dig1 <= coming_data[7:4]; dig2 <= coming_data[11:8]; dig3 <= coming_data[15:12]; end
		
	endcase
 end
 
 always @(posedge clk) //counter increment using clock
begin
 if (count2 == 21'd400000)
 begin
 if(count==4) begin count<=0; count2<=0;end
 else begin count <= count + 1; count2 <= 0; end
 end
 else
 begin count2 <= count2 + 1; end
 end
 
 always @(*) begin
 case (count)
 2'b00: begin
 enable <= 4'b1110; //7 segment A0 will turn on
 sseg <= dig0;
 end
 2'b01: begin
 enable <= 4'b1101; //7 segment A1 will turn on
 sseg <= dig1;
 end
 2'b10: begin
 enable <= 4'b1011; //7 segment A2 will turn on
 sseg <= dig2;
 end
 2'b11: begin
 enable <= 4'b0111; //7 segment A3 will turn on
 sseg <= dig3;
 end
 endcase
 end
 always @(*) begin //selection of bits for 7 segment depending on number
 case(sseg)
 4'b0000: LED_out <= 7'b0000001; // "0" 
 4'b0001: LED_out <= 7'b1001111; // "1" 
 4'b0010: LED_out <= 7'b0010010; // "2" 
 4'b0011: LED_out <= 7'b0000110; // "3" 
 4'b0100: LED_out <= 7'b1001100; // "4" 
 4'b0101: LED_out <= 7'b0100100; // "5" 
 4'b0110: LED_out <= 7'b0100000; // "6" 
 4'b0111: LED_out <= 7'b0001111; // "7" 
 4'b1000: LED_out <= 7'b0000000; // "8" 
 4'b1001: LED_out <= 7'b0000100; // "9" 
 4'b1010: LED_out <= 7'b0001000; // "A" 
 4'b1011: LED_out <= 7'b0000000; // "B" 
 4'b1100: LED_out <= 7'b0110001; // "C" 
 4'b1101: LED_out <= 7'b0000001; // "D"
 4'b1110: LED_out <= 7'b0110000; // "E" 
 4'b1111: LED_out <= 7'b0111000; // "F" 
 default: LED_out <= 7'b0000001; // "0"
 endcase
 end
 
endmodule
