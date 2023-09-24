`timescale 1ns / 1ps

module rom_sim_bxu
#(
    parameter DATA_BITWIDTH = 8,
    parameter ADDR_BITWIDTH = 16
)
(
    input   [ADDR_BITWIDTH-1:0] addr_rd,
    output  [DATA_BITWIDTH-1:0] data_rd
);

    wire [DATA_BITWIDTH-1:0] data [0:7];
    assign data_rd = data[addr_rd[2:0]];

    assign data[0] = {12'h000, 4'b1011};    // in   >> d[]
    assign data[1] = {12'h001, 4'b0010};    // d[]  + #0x01
    assign data[2] = {12'h001, 4'b0110};    // s    + #0x001
    assign data[3] = {12'h001, 4'b0010};    // d[]  + #0x01
    assign data[4] = {12'h801, 4'b0110};    // s    - #0x001
    assign data[5] = {12'h200, 4'b0011};    // out  << d[]
    assign data[6] = {12'h020, 4'b0011};    // out  << #' '
    assign data[7] = {12'h000, 4'b0000};    // nop
    
endmodule
