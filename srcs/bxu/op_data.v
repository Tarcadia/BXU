`timescale 1ns / 1ps

module op_data
#(
    parameter DATA_BITWIDTH = 8,
    parameter CODE_BITWIDTH = 16,
    parameter ADDR_BITWIDTH = 16,

    parameter DATA_NOP = 2'h0,
    parameter DATA_MOD = 2'h1,
    parameter DATA_SET = 2'h2,
    parameter DATA_GET = 2'h3
)
(
    input   clk,
    input   rst_n,

    input   [1:0] flag_op_data,
    input   flag_op_data_wr,
    input   [CODE_BITWIDTH-1:0] code,
    input   [DATA_BITWIDTH-1:0] data,
    input   [DATA_BITWIDTH-1:0] in,
    output  [DATA_BITWIDTH-1:0] data_out,
    output  data_wr,

    input   dbg_clk,
    output  dbg_local_f_pn,
    output  dbg_local_f_mem,
    output  dbg_local_f_lh
);

    wire [11:0] _inst12;
    wire [10:0] _inst11;
    wire [7:0] _inst8;
    assign _inst12 = code[15:4];
    assign _inst11 = code[14:4];
    assign _inst8 = code[11:4];
    assign _f_pn = code[15];
    assign _f_mem = code[13];
    assign _f_lh = code[12];

    assign dbg_local_f_pn = _f_pn;
    assign dbg_local_f_mem = _f_mem;
    assign dbg_local_f_lh = _f_lh;


    reg [7:0] r_data_out = 8'h00;
    assign data_out = r_data_out;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_data_out <= 8'h00;
        end else case (flag_op_data)
        DATA_NOP:   ;
        DATA_MOD:   if (_f_pn) r_data_out <= data - _inst8;
                    else r_data_out <= data + _inst8;
        DATA_SET:   if (_f_mem) r_data_out <= data;
                    else r_data_out <= _inst8;
        DATA_GET:   r_data_out <= in;
        default:    ;
        endcase
    end

    reg r_data_wr = 1'b0;
    reg r_data_wr_delay = 1'b0;
    assign data_wr = r_data_wr & r_data_wr_delay;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_data_wr <= 1'b0;
        end else begin
            r_data_wr <= flag_op_data_wr;
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_data_wr_delay <= 1'b0;
        end else begin
            r_data_wr_delay <= r_data_wr;
        end
    end


endmodule
