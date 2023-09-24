`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Xu Ke
// 
// Create Date: 2019/07/09 22:18:18
// Design Name: BrainFuck Unit
// Module Name: BFU
// Project Name: project_BFU
//////////////////////////////////////////////////////////////////////////////////


module BFU
#(
    parameter BITSIZE = 8,
    parameter STKSIZE = 12,
    
    parameter DADDLEN = 10,
    parameter CADDLEN = 10,
    parameter QADDLEN = 10,  
    
    parameter [DADDLEN-1:0] DATSIZE = 1 << 10,
    parameter [CADDLEN-1:0] CODSIZE = 1 << 10,
    parameter [QADDLEN-1:0] QUESIZE = 1 << 10
)
(
    input wire CLK
);
    
    reg [BITSIZE-1:0] dat [0:DATSIZE-1];
    reg [BITSIZE-1:0] cod [0:CODSIZE-1];
    reg [BITSIZE-1:0] qui [0:QUESIZE-1];
    reg [BITSIZE-1:0] quo [0:QUESIZE-1];
    
    reg [DADDLEN-1:0] pdat = 0;
    reg [CADDLEN-1:0] pcod = 0;
    reg [QADDLEN-1:0] hqui = 0, rqui = 0;
    reg [QADDLEN-1:0] hquo = 0, rquo = 0;
    
    wire datshl, datshr, datwr;
    wire codshl, codshr;
    wire quipsh, quipop;
    wire quopsh, quopop;
    
    wire [BITSIZE-1:0] dati, dato;
    wire [BITSIZE-1:0] code;
    wire [BITSIZE-1:0] ioi, ioo;
    
    JunctionBlock #(.BITSIZE(BITSIZE), .STKSIZE(STKSIZE))
    jb
    (
        .CLK(CLK),
        
        .D(dati),
        .DO(dato),
        .DT(datwr),
        .DSL(datshl),
        .DSR(datshr),
        
        .C(code),
        .CSL(codshl),
        .CSR(codshr),
        
        .I(ioi),
        .IF(hqui != rqui),
        .IOVF(hqui + 1 == rquo),
        .IT(quipop),
        
        .O(ioo),
        .OOVF(hquo + 1 == rquo),
        .OT(quopsh)
        
    );
    
    assign dati = dat[pdat];
    assign code = cod[pcod];
    assign ioi = qui[hqui];
    
    always @(posedge datshl or posedge datshr) begin
        if (datshl && ~datshr)
            pdat <= pdat + 1;
        if (~datshl && datshr)
            pdat <= pdat - 1;
    end
    
    always @(posedge datwr) begin
        dat[pdat] <= dato;
    end
    
    always @(posedge codshl or posedge codshr) begin
        if (codshl && ~codshr)
            pcod <= pcod + 1;
        if (~codshl && codshr)
            pcod <= pcod - 1;
    end
    
    always @(posedge quipop) begin
        hqui <= hqui + 1;
    end
    
    always @(posedge quopsh) begin
        quo[rquo] <= ioo;
        rquo <= rquo + 1;
    end
    
endmodule
