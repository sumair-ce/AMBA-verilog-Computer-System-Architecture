`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:18 05/31/2024 
// Design Name: 
// Module Name:    APB_Slave1 
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
module APB_Slave1(
 input PCLK,
    input PRESETn,
    input PSEL,
    input PENABLE,
    input PWRITE,
    input [31:0] PADDR,
    input [31:0] PWDATA,
    output [31:0] PRDATA1,
    output reg PREADY
);

    reg [31:0] reg_addr;
    reg [31:0] mem [10:0]; // 16 locations of 8-bit wide memory
	 
	 
initial
	begin
	mem[0]=32'd0;
	mem[1]=32'd5;
	mem[2]=32'd10;
	mem[3]=32'd15;
	mem[4]=32'd20;
	mem[5]=32'd25;
	mem[6]=32'd30;
	mem[7]=32'd35;
	mem[8]=32'd40;
	mem[9]=32'd45;
	mem[10]=32'd50;
end
    // Output data read from memory
    assign PRDATA1 = mem[reg_addr];

    // Ready signal and memory operations
    always @(posedge PCLK) begin
        if (PRESETn) begin
            PREADY <= 0;
        end else begin
            if (PSEL && PENABLE) begin
                if (PWRITE) begin
                    // Write operation
                    mem[PADDR] <= PWDATA;
                    PREADY <= 1;
                end else begin
                    // Read operation
                    reg_addr <= PADDR;
                    PREADY <= 1;
                end
            end else if (PSEL && !PENABLE) begin
                PREADY <= 0;
            end else begin
                PREADY <= 0;
            end
        end
    end

endmodule