`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:40:45 05/29/2024
// Design Name:   ahb_top
// Module Name:   G:/Academics/CSA/Projects/AHB_practice/tb_Tmodule.v
// Project Name:  AHB_practice
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ahb_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_ahb_top;

  // Inputs
  reg hclk;
  reg hresetn;
  reg enable;
  reg [31:0] dina;
  reg [31:0] addr;
  reg wr;
  reg [2:0] sel;

  // Outputs
  wire [31:0] dout;

  // Instantiate the top module
  ahb_top uut (
    .hclk(hclk),
    .hresetn(hresetn),
    .enable(enable),
    .dina(dina),
    .addr(addr),
    .wr(wr),
    .sel(sel),
    .dout(dout)
  );

  // Clock generation
  initial begin
    hclk = 0;
    forever #5 hclk = ~hclk;  // 10ns period
  end

  // Stimulus
  initial begin
    // Initialize inputs
    hresetn = 1;
    enable = 0;
    dina = 0;
    addr = 0;
    wr = 0;
    sel = 2'b000;
//------------------------------------------------------------------------------
// Slave 01
//------------------------------------------------------------------------------
    // Reset the system
    #20;
    hresetn = 0;

    // Wait for reset de-assertion
    #10;
    hresetn = 0;

    // Write transaction to address 0x0000_0000
    @(posedge hclk);
	 sel = 3'b000;
    enable = 1;
    addr = 32'd0;
	 wr = 1;
	 @(posedge hclk);
    dina = 32'hDEADBEEF;
    wr = 1;
     // Select slave 1
	 
	 @(posedge hclk);
	 enable = 1;
    addr = 32'd3;
	 @(posedge hclk);
    wr = 0;
    sel = 3'b000;
	 
//------------------------------------------------------------------------------
// Slave 02
//------------------------------------------------------------------------------
	 
	 #20 
	 #20
	 hresetn = 1;
	 sel=3'b100;
	 dina = 32'hDEADC0DE;
	 
	 #20
	 #20
	 #20
	 #20
	 hresetn = 0;
	 
	 
	 @(posedge hclk);
	 sel = 3'b001;
    enable = 1;
    addr = 32'd0;
	 wr = 1;
	 @(posedge hclk);
    dina = 32'hDEADC0DE;
    wr = 1;
	 
	 
	 @(posedge hclk);
	 enable = 1;
    addr = 32'd11;
	 wr = 0;
	 @(posedge hclk);
    wr = 0;
    sel = 3'b001;
	 
	 
//------------------------------------------------------------------------------
// Slave 03
//------------------------------------------------------------------------------
	 
	 #20 
	 #20
	 hresetn = 1;
	 sel=3'b100;
	 dina = 32'hFEEDFACE;
	 
	 #20
	 #20
	 #20
	 #20
	 hresetn = 0;
	 
	 
	 @(posedge hclk);
	 sel = 3'b010;
    enable = 1;
    addr = 32'd0;
	 wr = 1;
	 @(posedge hclk);
    dina = 32'hFEEDFACE;
    wr = 1;
	 
	 
	 @(posedge hclk);
	 enable = 1;
    addr = 32'd23;
	 wr=0;
	 @(posedge hclk);
    wr = 0;
    sel = 3'b010;
	 addr = 32'd2;


//------------------------------------------------------------------------------
// Slave 03
//------------------------------------------------------------------------------
	 
	 #20 
	 #20
	 hresetn = 1;
	 sel=3'b100;
	 dina = 32'hDEADFACE;
	 
	 #20
	 #20
	 #20
	 #20
	 hresetn = 0;
	 
	 
	 @(posedge hclk);
	 sel = 3'b011;
    enable = 1;
    addr = 32'd5;
	 wr = 1;
	 @(posedge hclk);
    dina = 32'hDEADFACE;
    wr = 1;



  end

  // Monitor
  initial begin
    $monitor("Time = %t, hclk = %b, hresetn = %b, enable = %b, addr = %h, dina = %h, wr = %b, sel = %b, dout = %h",
             $time, hclk, hresetn, enable, addr, dina, wr, sel, dout);
  end

endmodule
