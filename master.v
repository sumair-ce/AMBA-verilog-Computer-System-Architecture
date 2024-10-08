`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:33:56 05/29/2024 
// Design Name: 
// Module Name:    master 
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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:33:56 05/29/2024 
// Design Name: 
// Module Name:    master 
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
//----------------------------------------------------------------
//----------------------------------------------------------------
// Date: 2020-11-4
// Debug
//----------------------------------------------------------------
module ahb_master(
    input hclk,
    input hresetn,
    input enable,
    input [31:0] dina,
    input [31:0] addr,
    input wr,
    input hreadyout,
    input hresp,
    input [31:0] hrdata,
    input [1:0] slave_sel,
  
    input [2:0] sel,
    output reg [31:0] haddr,
    output reg hwrite,
    output reg hready,
    output reg [31:0] hwdata,
    output reg [31:0] dout
);

//----------------------------------------------------
// The definitions for state machine
//----------------------------------------------------

reg [1:0] state, next_state;
parameter IDLE = 2'b00, ADDR_PHASE = 2'b01, DATA_PHASE = 2'b10, RESPONSE_PHASE = 2'b11;

//----------------------------------------------------
// The state machine
//----------------------------------------------------

always @(posedge hclk or posedge hresetn) begin
    if (hresetn)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    next_state = state; // Default to current state

    case (state)
        IDLE: begin
            if (enable)
                next_state = ADDR_PHASE;
        end
        ADDR_PHASE: begin
            if (wr)
                next_state = DATA_PHASE;
            else
                next_state = RESPONSE_PHASE;
        end
        DATA_PHASE: begin
            next_state = IDLE; // Assuming single-cycle data phase
        end
        RESPONSE_PHASE: begin
            next_state = IDLE; // Assuming single-cycle response phase
        end
        default: next_state = IDLE;
    endcase
end

//----------------------------------------------------
// Output assignment based on state
//----------------------------------------------------

always @(posedge hclk or posedge hresetn) begin
    if (hresetn) begin
        // Initialize outputs on reset
       // sel <= 2'b00;
        haddr <= 32'h0000_0000;
        hwrite <= 1'b0;
        hready <= 1'b0;
        hwdata <= 32'h0000_0000;
        dout <= 32'h0000_0000;
    end
    else begin
        // Assign outputs based on current state
        case (state)
            IDLE: begin 
                //sel <= slave_sel;
                haddr <= addr;
                hwrite <= 1'b0;
                hready <= 1'b0;
                hwdata <= 32'h0000_0000;
                dout <= 32'h0000_0000;
            end
            ADDR_PHASE: begin 
                //sel <= slave_sel;
                haddr <= addr;
                hwrite <= wr;
                hready <= 1'b1;
                hwdata <= dina;
                dout <= hrdata;
            end
            DATA_PHASE, RESPONSE_PHASE: begin 
                // Assign outputs without changing them
                //sel <= sel;
                haddr <= haddr;
                hwrite <= hwrite;
                hready <= 1'b1;
                hwdata <= hwdata;
                dout <= hrdata;
            end
            default: begin 
                // Default state assignment
                //sel <= slave_sel;
                haddr <= haddr;
                hwrite <= hwrite;
                hready <= 1'b0;
                hwdata <= hwdata;
                dout <= hrdata;
            end
        endcase
    end
end

endmodule
