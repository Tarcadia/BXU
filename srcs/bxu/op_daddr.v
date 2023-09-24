`timescale 1ns / 1ps

module op_daddr
#(
    parameter DATA_BITWIDTH = 8,
    parameter CODE_BITWIDTH = 16,
    parameter ADDR_BITWIDTH = 16,

    parameter DADDR_NOP = 2'h0,
    parameter DADDR_MOD = 2'h1,
    parameter DADDR_SET = 2'h2
)
(
    input   clk,
    input   rst_n,

    input   [1:0] flag_op_daddr,
    input   [CODE_BITWIDTH-1:0] code,
    input   [DATA_BITWIDTH-1:0] data,
    output  [ADDR_BITWIDTH-1:0] data_addr,

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


    reg [ADDR_BITWIDTH-1:0] r_data_addr = 64'h0000_0000_0000_0000;
    assign data_addr = r_data_addr;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_data_addr <= 64'h0000_0000_0000_0000;
        end else case (flag_op_daddr)
        DADDR_NOP:  ;
        DADDR_MOD:  if (_f_pn) r_data_addr <= r_data_addr - _inst11;
                    else r_data_addr <= r_data_addr + _inst11;
        DADDR_SET:  if (_f_mem && ~_f_lh) r_data_addr[7:0] <= data[7:0];
                    else if (_f_mem && _f_lh) r_data_addr[15:8] <= data[7:0];
                    else if (~_f_mem && ~_f_lh) r_data_addr[7:0] <= _inst8;
                    else if (~_f_mem && _f_lh) r_data_addr[15:8] <= _inst8;
        default:    ;
        endcase
    end

endmodule
