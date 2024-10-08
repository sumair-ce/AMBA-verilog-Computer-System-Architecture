`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:49 06/03/2024 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
  input hclk,
  input hresetn,
  input hsel,
  input [31:0] haddr,
  input hwrite,
  input hready,
  input [31:0] hwdata,
  output reg [31:0] out_addr,
  output reg [31:0] out_writeData,
  output reg out_transferSignal,
  output reg out_hwrite,
  output reg hreadyout,
  output reg hresp
);

/*always @(posedge hclk or negedge hresetn) begin
  if (!hresetn) begin
    out_addr <= 32'b0;
    out_writeData <= 32'b0;
    hreadyout <= 1'b0;
    hresp <= 1'b0;
  end else begin
    if (hsel == 1'b1 && hwrite == 1'b1) begin
      out_addr <= haddr;
      out_writeData <= hwdata;
      hreadyout <= 1'b1;
      hresp <= 1'b0; // Assuming no error response
    end else begin
      hreadyout <= 1'b0;
      hresp <= 1'b1; // Assuming error response or not ready
    end
  end
end*/


//----------------------------------------------------------------------
// The definition for state machine
//----------------------------------------------------------------------
reg [1:0] state;
reg [1:0] next_state;
localparam idle = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;


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
next_state = state; //
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
  out_addr <= 32'b0;
    out_writeData <= 32'b0;
    hreadyout <= 1'b0;
    hresp <= 1'b0;
	 out_transferSignal<=1'b1;
	 out_hwrite<=hwrite;
  end
  else begin
    case(next_state)
      idle: begin
        out_addr <= 32'b0;
        out_writeData <= 32'b0;
        hreadyout <= 1'b0;
        hresp <= 1'b0;
		  out_transferSignal<=1'b1;
		  	 out_hwrite<=hwrite;

      end
      s1: begin
        out_addr <= haddr;
		  out_writeData <= hwdata;
        hreadyout <= 1'b1;
        hresp <= 1'b0; 
		  out_transferSignal<=1'b1;
		  	 out_hwrite<=hwrite;

      end
      s2: begin
        out_addr <= haddr;
		  out_writeData <= hwdata;
        hreadyout <= 1'b1;
        hresp <= 1'b0;
        out_transferSignal<=1'b1;
	 out_hwrite<=hwrite;
		  
		  end

      s3: begin
        if(!hwrite && hready)begin
			out_addr <= haddr;
		  out_writeData <= hwdata;
        hreadyout <= 1'b1;
        hresp <= 1'b0; 
		  	 out_hwrite<=hwrite;

		  end
      end
		
    endcase
  end
end

endmodule

