`timescale 1ns / 1ps

module ram
#(
    parameter DATA_BITWIDTH = 8,
    parameter ADDR_BITWIDTH = 8,
    parameter DEPTH = 1 << ADDR_BITWIDTH
)
(
    input   [ADDR_BITWIDTH-1:0] addr_wr,
    input   [DATA_BITWIDTH-1:0] data_wr,
    input   wr,

    input   [ADDR_BITWIDTH-1:0] addr_rd,
    output  [DATA_BITWIDTH-1:0] data_rd
);

    reg [DATA_BITWIDTH-1:0] data [0:DEPTH-1];
    
    assign data_rd = data[addr_rd];

    always @(posedge wr) begin
        data[addr_wr] <= data_wr;
    end

    initial begin : block_initial
        integer i;
        for ( i = 0 ; i < DEPTH ; i = i + 1 ) begin
            data[i] <= 0;
        end
    end
    
endmodule
