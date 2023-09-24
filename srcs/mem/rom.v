`timescale 1ns / 1ps

module rom
#(
    parameter DATA_BITWIDTH = 8,
    parameter ADDR_BITWIDTH = 8,
    parameter DEPTH = 1 << ADDR_BITWIDTH,
    parameter ROM_HEX_FILE = "rom.hex"
)
(
    input   [ADDR_BITWIDTH-1:0] addr_rd,
    output  [DATA_BITWIDTH-1:0] data_rd
);

    wire [DATA_BITWIDTH-1:0] data [0:DEPTH-1];
    assign data_rd = data[addr_rd];

endmodule
