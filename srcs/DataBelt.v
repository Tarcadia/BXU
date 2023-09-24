`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Xu Ke
// 
// Create Date: 2019/07/09 22:18:18
// Design Name: Data Belt
// Module Name: DataBelt
// Project Name: project_BFU
//////////////////////////////////////////////////////////////////////////////////


module DataBelt
#(
    parameter BITSIZE = 8,
    parameter ADDSIZE = 10,
    parameter [ADDSIZE-1:0] BELTLEN = 1 << ADDSIZE
)
(
    input wire CLK,
    
    input wire SHL,
    input wire SHR,
    
    input wire [BITSIZE-1:0] DI,
    input wire WR,
    
    output wire [BITSIZE-1:0] DO
);
    
    reg [ADDSIZE-1:0] addr = 0;
    reg [BITSIZE-1:0] data [0:BELTLEN-1];
    
    assign DO = data[addr];
    
    always @(posedge WR) begin
        data[addr] <= DI;
    end
    
    always @(posedge SHL or posedge SHR) begin
        if (SHL && ~SHR)
            addr <= addr + 1;
        if (SHR && ~SHL)
            addr <= addr - 1;
    end
    
endmodule
