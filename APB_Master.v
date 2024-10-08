`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:06 05/31/2024 
// Design Name: 
// Module Name:    APB_Master 
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
 module APB_Master (
  input [31:0] apb_write_paddr,
    input [831:0] apb_read_paddr,
    input [31:0] apb_write_data,
    input [31:0] PRDATA,
    input PRESETn,
    input PCLK,
    input READ_WRITE,
    input transfer,
    input PREADY,
    output PSEL1,
    output PSEL2,
    output reg PENABLE,
    output reg [31:0] PADDR,
    output reg PWRITE,
    output reg [31:0] PWDATA,
    output reg [31:0] apb_read_data_out,
    output PSLVERR
);

    reg [1:0] state, next_state;
    reg invalid_setup_error, setup_error, invalid_read_paddr, invalid_write_paddr, invalid_write_data;

    localparam IDLE = 3'b00, SETUP = 3'b01, ENABLE = 3'b10;

    // State transition
    always @(posedge PCLK) begin
        if (PRESETn)
            state <= IDLE;
        else
            state <= next_state;
    end

    // State machine logic
    always @(posedge PCLK) begin
            PWRITE <= ~READ_WRITE;
            case (state)
                IDLE: begin
                    PENABLE <= 0;
                    if (!transfer)
                        next_state <= IDLE;
                    else
                        next_state <= SETUP;
                end

                SETUP: begin
                    PENABLE <= 0;
                    if (READ_WRITE) begin
                        PADDR <= apb_read_paddr;
								PWRITE<=READ_WRITE; end
                    else begin
                        PADDR <= apb_write_paddr;
                        PWDATA <= apb_write_data;
								PWRITE<=READ_WRITE;
                    end

                    if (transfer && !PSLVERR)
                        next_state <= ENABLE;
                    else
                        next_state <= IDLE;
                end

                ENABLE: begin
                    if (PSEL1 || PSEL2)
                        PENABLE <= 1;
                    if (transfer && !PSLVERR) begin
                        if (PREADY) begin
                            if (READ_WRITE) begin
                                apb_read_data_out <= PRDATA;
										  PWRITE<=READ_WRITE;

                                next_state <= SETUP;
                            end else
                                next_state <= SETUP;
                        end else
                            next_state <= ENABLE;
                    end else
                        next_state <= IDLE;
                end

                default: next_state <= IDLE;
            endcase
    end

    // PSEL signals assignment
    assign {PSEL1, PSEL2} = (state != IDLE) ? (PADDR[8] ? 2'b01 : 2'b10) : 2'b00;

    // PSLVERR logic
    always @(posedge PCLK) begin
        if (!PRESETn) begin
            setup_error <= 0;
            invalid_read_paddr <= 0;
            invalid_write_paddr <= 0;
            invalid_write_data <= 0;
        end else begin
            setup_error <= (state == IDLE && next_state == ENABLE);
            invalid_write_data <= (apb_write_data === 8'dx) && (!READ_WRITE) && (state == SETUP || state == ENABLE);
            invalid_read_paddr <= (apb_read_paddr === 9'dx) && READ_WRITE && (state == SETUP || state == ENABLE);
            invalid_write_paddr <= (apb_write_paddr === 9'dx) && (!READ_WRITE) && (state == SETUP || state == ENABLE);

            if (state == SETUP) begin
                if (PWRITE) begin
                    setup_error <= !(PADDR == apb_write_paddr && PWDATA == apb_write_data);
                end else begin
                    setup_error <= !(PADDR == apb_read_paddr);
                end
            end else begin
                setup_error <= 0;
            end
        end

        invalid_setup_error <= setup_error || invalid_read_paddr || invalid_write_data || invalid_write_paddr;
    end

    assign PSLVERR = invalid_setup_error;

endmodule
