// AHB Master module
module ahb_master (
    input wire HCLK,          // Clock
    input wire HRESETn,       // Reset (active low)
    input wire HREADY,        // Ready signal from the slave
    input wire [31:0] HRDATA, // Data read from the slave
    output reg HWRITE,        // Write enable
    output reg [1:0] HTRANS,  // Transfer type
    output reg [31:0] HADDR,  // Address
    output reg [31:0] HWDATA  // Data to write
);

    // Define transfer types
    parameter IDLE   = 2'b00;
    parameter BUSY   = 2'b01;
    parameter NONSEQ = 2'b10;
    parameter SEQ    = 2'b11;

    reg [1:0] state; // Current state of the transfer

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            state <= IDLE;
            HWRITE <= 0;
            HTRANS <= IDLE;
            HADDR <= 32'b0;
            HWDATA <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Example condition to start a transaction
                    if (/* some condition */) begin
                        state <= NONSEQ;
                        HWRITE <= 1; // Set to 1 for write, 0 for read
                        HTRANS <= NONSEQ;
                        HADDR <= /* target address */;
                        HWDATA <= /* data to write */;
                    end
                end
                NONSEQ: begin
                    if (HREADY) begin
                        state <= IDLE;
                        HTRANS <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule

// AHB Slave module
module ahb_slave (
    input wire HCLK,           // Clock
    input wire HRESETn,        // Reset (active low)
    input wire HSEL,           // Slave select
    input wire HWRITE,         // Write enable from master
    input wire [1:0] HTRANS,   // Transfer type from master
    input wire [31:0] HADDR,   // Address from master
    input wire [31:0] HWDATA,  // Data from master
    output reg [31:0] HRDATA,  // Data to master
    output reg HREADY          // Ready signal to master
);

    reg [31:0] memory [0:255]; // Example memory array

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            HREADY <= 1;
            HRDATA <= 32'b0;
        end else begin
            if (HSEL && HTRANS != IDLE) begin
                HREADY <= 0;
                if (HWRITE) begin
                    memory[HADDR[9:2]] <= HWDATA; // Write data to memory
                    HREADY <= 1;
                end else begin
                    HRDATA <= memory[HADDR[9:2]]; // Read data from memory
                    HREADY <= 1;
                end
            end else begin
                HREADY <= 1;
            end
        end
    end
endmodule

// AHB Arbiter module
module ahb_arbiter (
    input wire HCLK,           // Clock
    input wire HRESETn,        // Reset (active low)
    input wire req_master0,    // Request from master 0
    input wire req_master1,    // Request from master 1
    output reg grant_master0,  // Grant signal to master 0
    output reg grant_master1   // Grant signal to master 1
);

    reg current_master; // Current master

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            current_master <= 0;
            grant_master0 <= 1;
            grant_master1 <= 0;
        end else begin
            case (current_master)
                0: begin
                    if (req_master1) begin
                        current_master <= 1;
                        grant_master0 <= 0;
                        grant_master1 <= 1;
                    end else begin
                        grant_master0 <= 1;
                        grant_master1 <= 0;
                    end
                end
                1: begin
                    if (req_master0) begin
                        current_master <= 0;
                        grant_master0 <= 1;
                        grant_master1 <= 0;
                    end else begin
                        grant_master0 <= 0;
                        grant_master1 <= 1;
                    end
                end
            endcase
        end
    end
endmodule

// Top-level module
module ahb_top (
    input wire HCLK,       // Clock
    input wire HRESETn     // Reset (active low)
);
    wire HREADY;
    wire [31:0] HRDATA;
    wire HWRITE;
    wire [1:0] HTRANS;
    wire [31:0] HADDR;
    wire [31:0] HWDATA;
    
    wire grant_master0;
    wire grant_master1;
    wire req_master0;
    wire req_master1;

    // Instantiate AHB Master
    ahb_master master0 (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HREADY(HREADY),
        .HRDATA(HRDATA),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HADDR(HADDR),
        .HWDATA(HWDATA)
    );

    // Instantiate AHB Slave
    ahb_slave slave0 (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSEL(grant_master0),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        .HRDATA(HRDATA),
        .HREADY(HREADY)
    );

    // Instantiate AHB Arbiter
    ahb_arbiter arbiter0 (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .req_master0(req_master0),
        .req_master1(req_master1),
        .grant_master0(grant_master0),
        .grant_master1(grant_master1)
    );

    // Example requests for master
    assign req_master0 = 1; // Example: always requesting
    assign req_master1 = 0; // Example: never requesting

endmodule
