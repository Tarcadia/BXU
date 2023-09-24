`timescale 1ns / 1ps

module UART_BAUD
#(
    parameter CLK_FREQ = 200_000_000,
    parameter BAUDRATE = 9600
)
(
    input   clk,
    input   rst_n,
    output  clk_baud,
    output  flag_start,
    output  [23:0] flag_data,
    output  flag_end,
    
    input   dbg_clk
    );
    
    localparam CNT_PER_6T_BAUD = CLK_FREQ / (BAUDRATE * 6);
    localparam CNT_PER_3T_BAUD = CLK_FREQ / (BAUDRATE * 3);
    localparam CNT_PER_2T_BAUD = CLK_FREQ / (BAUDRATE * 2);
    localparam CNT_PER_1T_BAUD = CLK_FREQ / (BAUDRATE * 1);
    
    reg [17:0] cnt_clk = 18'b0;
    reg r_clk_baud = 1'b0;
    reg [2:0] r_flag_start = 3'b0;
    reg [23:0] r_flag_data = 24'b0;
    reg r_flag_end = 1'b0;
    
    assign clk_baud = r_clk_baud;
    assign flag_start = |r_flag_start[1:0];
    assign flag_data = r_flag_data;
    assign flag_end = r_flag_end;
    
    integer i;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_clk_baud <= 1'b0;
            cnt_clk <= 18'b0;
            r_flag_start <= 3'b0;
            r_flag_data <= 24'b0;
            r_flag_end <= 1'b0;
        end else if (~|({ r_flag_end, r_flag_data, r_flag_start })) begin
            r_clk_baud <= 1'b1;
            r_flag_start <= 3'b1;
            r_flag_data <= 24'b0;
            r_flag_end <= 1'b0;
            cnt_clk <= 18'b0;
        end else begin
            if (cnt_clk == CNT_PER_6T_BAUD) begin
                r_clk_baud <= 1'b0;
                cnt_clk <= cnt_clk + 1;
            end else if (cnt_clk == CNT_PER_3T_BAUD) begin
                r_clk_baud <= 1'b1;
                { r_flag_end, r_flag_data, r_flag_start } <= { r_flag_end, r_flag_data, r_flag_start } << 1;
                cnt_clk <= 0;
            end else begin
                cnt_clk <= cnt_clk + 1;
            end
        end
    end

endmodule
