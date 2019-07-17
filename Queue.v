`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Xu Ke
// 
// Create Date: 2019/07/09 22:18:18
// Design Name: Queue
// Module Name: Queue
// Project Name: project_BFU
//////////////////////////////////////////////////////////////////////////////////


module Queue
#(
    parameter BITSIZE = 8,
    parameter ADDSIZE = 10,
    parameter [ADDSIZE-1:0] QUELEN = 1 << ADDSIZE
)
(
    input wire CLK,
    
    input wire PUS,
    input wire POP,
    
    input wire [BITSIZE-1:0] DI,
    output wire [BITSIZE-1:0] DO,
    
    output wire DF,
    output wire OVF
);
    
    reg [ADDSIZE-1:0] head = 0;
    reg [ADDSIZE-1:0] rear = 0;
    reg [BITSIZE-1:0] data [0:QUELEN-1];
    
    assign DO = data[head];
    assign DF = ~(head == rear);
    assign OVF = (head == rear + 1);
    
    always @(posedge PUS) begin
        data[rear] <= DI;
        rear <= rear + 1;
    end
    
    always @(posedge POP) begin
        head <= head + 1;
    end
endmodule
