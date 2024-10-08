`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:11 05/31/2024 
// Design Name: 
// Module Name:    APB_Slave2 
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
module APB_Slave2(
  input PCLK,
    input PRESETn,
    input PSEL,
    input PENABLE,
    input PWRITE,
    input [7:0] PADDR,
    input [7:0] PWDATA,
    output [7:0] PRDATA2,
    output reg PREADY
);

    reg [7:0] reg_addr;
    reg [7:0] mem2 [0:63]; // 64 locations of 8-bit wide memory

    // Output data read from memory
    assign PRDATA2 = mem2[reg_addr];

    // Ready signal and memory operations
    always @(posedge PCLK or posedge PRESETn) begin
        if (PRESETn) begin
            PREADY <= 0;
        end else begin
            if (PSEL && PENABLE) begin
                if (PWRITE) begin
                    // Write operation
                    mem2[PADDR] <= PWDATA;
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