`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Xu Ke
// 
// Create Date: 2019/07/09 22:18:18
// Design Name: Junction Block
// Module Name: JunctionBlock
// Project Name: project_BFU
//////////////////////////////////////////////////////////////////////////////////


module JunctionBlock
#(
    parameter BITSIZE = 8,
    parameter STKSIZE = 12
)
(
    input CLK,
    
    input wire [BITSIZE-1:0] D,
    output reg [BITSIZE-1:0] DO,
    output reg DT,
    output reg DSL,
    output reg DSR,
    
    input wire [3:0] C,
    output reg CSL,
    output reg CSR,
    
    input wire [BITSIZE-1:0] I,
    input wire IF,
    input wire IOVF,
    output reg IT,
    
    output reg [BITSIZE-1:0] O,
    input wire OOVF,
    output reg OT,
    
    input wire [2:0] SI,
    input wire ST,
    output wire S,
    output reg [BITSIZE-1:0] ERR
    
);
    
    reg [2:0] sta = 1;              //0:N, 1:NRM, 2:WIT, 3:FWD, 4:BCK
    reg [2:0] act = 0;              //0:N, 1:DSL, 2:DSR, 3:CSL, 4:CSR, 5:DWR, 6:OUT, 7:NUL
    
    reg [STKSIZE-1:0] stack = 0;
    reg [BITSIZE-1:0] err = 0;      //0:N, 1:STE
    
    reg [BITSIZE-1:0] data = 0;
    
    assign S = sta;
    
    always @(CLK) begin
        if (CLK) begin
            DSL <= 0;
            DSR <= 0;
            CSL <= 0;
            CSR <= 0;
            DT <= 0;
            OT <= 0;
            if (ST) begin
                sta <= SI;
                act <= 0;
                err <= 1;
            end else begin
                case(sta)
                0:  begin
                        ERR <= err;
                    end
                1:  begin
                        case(C)
                        0:  begin
                                act <= 1;
                                sta <= 1;
                            end
                        1:  begin
                                act <= 2;
                                sta <= 1;
                            end
                        2:  begin
                                DO <= D + 1;
                                act <= 5;
                                sta <= 1;
                            end
                        3:  begin
                                DO <= D - 1;
                                act <= 5;
                                sta <= 1;
                            end
                        4:  begin
                                O <= D;
                                act <= 6;
                                sta <= 1;
                            end
                        5:  begin
                                if (IF) begin
                                    DO <= I;
                                    IT <= 1;
                                    act <= 5;
                                    sta <= 1;
                                end else begin
                                    act <= 0;
                                    sta <= 2;
                                end
                            end
                        6:  begin
                                if (D != 0) begin
                                    act <= 3;
                                    sta <= 1;
                                end else begin
                                    act <= 3;
                                    stack <= 0;
                                    sta <= 3;
                                end
                            end
                        7:  begin
                                if (D == 0) begin
                                    act <= 3;
                                    sta <= 1;
                                end else begin
                                    act <= 4;
                                    stack <= 0;
                                    sta <= 4;
                                end
                            end
                        endcase
                    end
                    2:  begin
                            if (IF) begin
                                DO <= I;
                                IT <= 1;
                                act <= 5;
                                sta <= 1;
                            end else begin
                                act <= 0;
                                sta <= 2;
                            end
                        end
                    3:  begin
                            if (stack == 0 && C == 7) begin
                                act <= 3;
                                sta <= 1;
                            end else begin
                                stack <= stack + (C == 6) - (C == 7);
                                act <= 3;
                                sta <= 3;
                            end
                        end
                    4:  begin
                            if (stack == 0 && C == 6) begin
                                act <= 3;
                                sta <= 1;
                            end else begin
                                stack <= stack - (C == 6) + (C == 7);
                                act <= 4;
                                sta <= 4;
                            end
                        end
                default:begin
                        err <= 1;
                        act <= 0;
                        sta <= 0;
                    end
                endcase
            end
        end else begin
            case(act)
            0:  begin
                    DSL <= 0;
                    DSR <= 0;
                    CSL <= 0;
                    CSR <= 0;
                    DT <= 0;
                    OT <= 0;
                    IT <= 0;
                end
            1:  begin
                    DSL <= 1;
                    DSR <= 0;
                    CSL <= 1;
                    CSR <= 0;
                    DT <= 0;
                    OT <= 0;
                    IT <= 0;
                end
            2:  begin
                    DSL <= 0;
                    DSR <= 1;
                    CSL <= 1;
                    CSR <= 0;
                    DT <= 0;
                    OT <= 0;
                    IT <= 0;
                end
            3:  begin
                    DSL <= 0;
                    DSR <= 0;
                    CSL <= 1;
                    CSR <= 0;
                    DT <= 0;
                    OT <= 0;
                    IT <= 0;
                end
            4:  begin
                    DSL <= 0;
                    DSR <= 0;
                    CSL <= 0;
                    CSR <= 1;
                    DT <= 0;
                    OT <= 0;
                    IT <= 0;
                end
            5:  begin
                    DSL <= 0;
                    DSR <= 0;
                    CSL <= 1;
                    CSR <= 0;
                    DT <= 1;
                    OT <= 0;
                    IT <= 0;
                end
            6:  begin
                    DSL <= 0;
                    DSR <= 0;
                    CSL <= 1;
                    CSR <= 0;
                    DT <= 0;
                    OT <= 1;
                    IT <= 0;
                end
            default:begin
                    DSL <= 0;
                    DSR <= 0;
                    CSL <= 0;
                    CSR <= 0;
                    DT <= 0;
                    OT <= 0;
                    IT <= 0;
                end
            endcase
        end
    end
    
endmodule
