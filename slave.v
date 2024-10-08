`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:35:08 05/29/2024 
// Design Name: 
// Module Name:    slave 
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

module ahb_slave(
  input hclk,
  input hresetn,
  input hsel,
  input [31:0] haddr,
  input hwrite,
  input [2:0] hsize,
  input [2:0] hburst,
  input [3:0] hprot,
  input [1:0] htrans,
  input hmastlock,
  input hready,
  input [31:0] hwdata,
  output reg hreadyout,
  output reg hresp,
  output reg [31:0] hrdata);

//----------------------------------------------------------------------
// The definitions for internal registers for data storage
//----------------------------------------------------------------------
reg [31:0] mem [31:0];
reg [4:0] waddr;
reg [4:0] raddr;

//----------------------------------------------------------------------
// The definition for state machine
//----------------------------------------------------------------------
reg [1:0] state;
reg [1:0] next_state;
localparam idle = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;

//----------------------------------------------------------------------
// Memory initialization
//----------------------------------------------------------------------

  initial begin
    mem[0]  = 32'h00000000;
    mem[1]  = 32'h00000001;
    mem[2]  = 32'h00000002;
    mem[3]  = 32'h00000003;
    mem[4]  = 32'h00000004;
    mem[5]  = 32'h00000005;
    mem[6]  = 32'h00000006;
    mem[7]  = 32'h00000007;
    mem[8]  = 32'h00000008;
    mem[9]  = 32'h00000009;
    mem[10] = 32'h0000000A;
    mem[11] = 32'h0000000B;
    mem[12] = 32'h0000000C;
    mem[13] = 32'h0000000D;
    mem[14] = 32'h0000000E;
    mem[15] = 32'h0000000F;
    mem[16] = 32'h00000010;
    mem[17] = 32'h00000011;
    mem[18] = 32'h00000012;
    mem[19] = 32'h00000013;
    mem[20] = 32'h00000014;
    mem[21] = 32'h00000015;
    mem[22] = 32'h00000016;
    mem[23] = 32'h00000017;
    mem[24] = 32'h00000018;
    mem[25] = 32'h00000019;
    mem[26] = 32'h0000001A;
    mem[27] = 32'h0000001B;
    mem[28] = 32'h0000001C;
    mem[29] = 32'h0000001D;
    mem[30] = 32'h0000001E;
    mem[31] = 32'h0000001F;
  end

//----------------------------------------------------------------------
// The state machine
//----------------------------------------------------------------------

always @(posedge hclk or posedge hresetn) begin
  if(hresetn) begin
    state <= idle;
  end
  else begin
    state <= next_state;
  end
end

always @(*) begin
next_state = state; 
  case(state)
    idle: begin
      if(hsel == 1'b1) begin
        if(hwrite == 1'b1)
          next_state = s2;
        else
          next_state = s1;
      end
      else begin
        next_state = idle;
      end
    end
    s1: begin
      if((hwrite == 1'b1) && (hready == 1'b1)) begin
        next_state = s2;
      end
      else if((hwrite == 1'b0) && (hready == 1'b1)) begin
        next_state = s3;
      end
      else begin
        next_state = s1;
      end
    end
    s2: begin
      next_state = idle;
    end
    s3: begin
      next_state = idle;
    end
    default: begin
      next_state = idle;
    end
  endcase
end

always @(posedge hclk or posedge hresetn) begin

  if(hresetn) begin
    hreadyout <= 1'b0;
    hresp <= 1'b0;
    hrdata <= 32'h0000_0000;
    waddr <= 5'b00000;
    raddr <= 5'b00000;
  end
  else begin
    case(next_state)
      idle: begin
        hreadyout <= 1'b0;
        hresp <= 1'b0;
        hrdata <= hrdata;
        waddr <= waddr;
        raddr <= raddr;
      end
      s1: begin
        hreadyout <= 1'b0;
        hresp <= 1'b0;
        hrdata <= hrdata;
        waddr <= haddr[4:0];
        raddr <= haddr[4:0];
      end
      s2: begin
        hreadyout <= 1'b1;
        hresp <= 1'b0;
        mem[waddr] <= hwdata;
		  end

      s3: begin
        if(!hwrite && hready)begin
			hrdata <= mem[raddr];
        hreadyout <= 1'b1;
        hresp <= 1'b0; end
		  
      end
      default: begin
        hreadyout <= 1'b0;
        hresp <= 1'b0;
        hrdata <= hrdata;
        waddr <= waddr;
        raddr <= raddr;
      end
    endcase
  end
end

endmodule
