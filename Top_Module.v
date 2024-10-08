`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:57 05/31/2024 
// Design Name: 
// Module Name:    Top_Module 
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
module Top_Module(
    input PCLK,
    input PRESETn,
    input transfer,
    input READ_WRITE,
    input [31:0] apb_write_paddr,
    input [31:0] apb_write_data,
    input [31:0] apb_read_paddr,
    output PSLVERR,
    output [31:0] apb_read_data_out
);

    wire [31:0] PWDATA, PRDATA, PRDATA1, PRDATA2;
    wire [31:0] PADDR;
    wire PREADY, PREADY1, PREADY2, PENABLE, PSEL1, PSEL2, PWRITE , PWRITE2;

    // Select the appropriate PREADY and PRDATA based on the address
    assign PREADY = PADDR[8] ? PREADY2 : PREADY1;
    assign PRDATA = READ_WRITE ? (PADDR[8] ? PRDATA2 : PRDATA1) : 8'dx;

    // Instantiate the master bridge
    APB_Master dut_mas(
        .apb_write_paddr(apb_write_paddr),
        .apb_read_paddr(apb_read_paddr),
        .apb_write_data(apb_write_data),
        .PRDATA(PRDATA),
        .PRESETn(PRESETn),
        .PCLK(PCLK),
        .READ_WRITE(READ_WRITE),
        .transfer(transfer),
        .PREADY(PREADY),
        .PSEL1(PSEL1),
        .PSEL2(PSEL2),
        .PENABLE(PENABLE),
        .PADDR(PADDR),
        .PWRITE(PWRITE2),
        .PWDATA(PWDATA),
        .apb_read_data_out(apb_read_data_out),
        .PSLVERR(PSLVERR)
    );

    // Instantiate slave 1
    APB_Slave1 dut1(
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL1),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE2),
        .PADDR(PADDR[31:0]),
        .PWDATA(PWDATA),
        .PRDATA1(PRDATA1),
        .PREADY(PREADY1)
    );

    // Instantiate slave 2
    APB_Slave2 dut2(
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL2),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR[31:0]),
        .PWDATA(PWDATA),
        .PRDATA2(PRDATA2),
        .PREADY(PREADY2)
    );

endmodule
