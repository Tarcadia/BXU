`timescale 1ns / 1ps

module rom_uart_bxu_echo
#(
    parameter DATA_BITWIDTH = 8,
    parameter ADDR_BITWIDTH = 16
)
(
    input   [ADDR_BITWIDTH-1:0] addr_rd,
    output  [DATA_BITWIDTH-1:0] data_rd
);

    wire [DATA_BITWIDTH-1:0] data [0:3];
    assign data_rd = data[addr_rd[1:0]];

    assign data[0] = {12'h000, 4'b1011};    // in   >> d[]
    assign data[1] = {12'h200, 4'b0011};    // out  << d[]
    assign data[2] = {12'h02C, 4'b0011};    // out  << #','
    assign data[3] = {12'h020, 4'b0011};    // out  << #' '
    
endmodule
