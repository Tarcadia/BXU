`timescale 1ns / 1ps

module front
#(
    parameter DATA_BITWIDTH = 8,
    parameter CODE_BITWIDTH = 16,

    parameter CADDR_NOP = 2'h0,
    parameter CADDR_INC = 2'h1,
    parameter CADDR_MOD = 2'h2,
    parameter CADDR_SET = 2'h3,

    parameter DADDR_NOP = 2'h0,
    parameter DADDR_MOD = 2'h1,
    parameter DADDR_SET = 2'h2,

    parameter DATA_NOP = 2'h0,
    parameter DATA_MOD = 2'h1,
    parameter DATA_SET = 2'h2,
    parameter DATA_GET = 2'h3
)
(
    input   clk,
    input   rst_n,
    
    input   [CODE_BITWIDTH-1:0] code,
    input   [DATA_BITWIDTH-1:0] data,
    input   data_wr,
    input   io_input_ready,
    input   io_input_done,
    input   io_output_ready,
    input   io_output_done,

    output  [1:0] flag_op_caddr,        // nop inc mod set
    output  [1:0] flag_op_daddr,        // nop mod set
    output  [1:0] flag_op_data,         // nop mod set get
    output  flag_op_data_wr,
    output  flag_op_input_done,
    output  flag_op_output_ready,

    input   dbg_clk,
    output  dbg_local_op_nop,
    output  dbg_local_op_d,
    output  dbg_local_op_d_mod,
    output  dbg_local_op_d_set,
    output  dbg_local_op_s,
    output  dbg_local_op_s_mod,
    output  dbg_local_op_s_set,
    output  dbg_local_op_j,
    output  dbg_local_op_j_mod,
    output  dbg_local_op_j_set,
    output  dbg_local_op_jc,
    output  dbg_local_op_jc_z,
    output  dbg_local_op_jc_nz,
    output  dbg_local_op_i,
    output  dbg_local_op_o

);

    wire flag_cond_zero;
    assign flag_cond_zero = ~(|data);

    wire [3:0] code_op4;
    wire [2:0] code_op3;
    assign code_op4 = code[3:0];
    assign code_op3 = code[2:0];
    assign code_op3x = code[3];
    
    assign _op_nop      = (code_op4 == 4'b0000);
    assign _op_d        = (code_op3 == 3'b010);
    assign _op_d_mod    = (code_op3x == 1'b0 && _op_d);
    assign _op_d_set    = (code_op3x == 1'b1 && _op_d);
    assign _op_s        = (code_op3 == 3'b110);
    assign _op_s_mod    = (code_op3x == 1'b0 && _op_s);
    assign _op_s_set    = (code_op3x == 1'b1 && _op_s);
    assign _op_j        = (code_op3 == 3'b001);
    assign _op_j_mod    = (code_op3x == 1'b0 && _op_j);
    assign _op_j_set    = (code_op3x == 1'b1 && _op_j);
    assign _op_jc       = (code_op3 == 3'b101);
    assign _op_jc_z     = (code_op3x == 1'b1 && _op_jc);
    assign _op_jc_nz    = (code_op3x == 1'b0 && _op_jc);
    assign _op_i        = (code_op4 == 4'b1011);
    assign _op_o        = (code_op4 == 4'b0011);

    assign dbg_local_op_nop     = _op_nop;
    assign dbg_local_op_d       = _op_d;
    assign dbg_local_op_d_mod   = _op_d_mod;
    assign dbg_local_op_d_set   = _op_d_set;
    assign dbg_local_op_s       = _op_s;
    assign dbg_local_op_s_mod   = _op_s_mod;
    assign dbg_local_op_s_set   = _op_s_set;
    assign dbg_local_op_j       = _op_j;
    assign dbg_local_op_j_mod   = _op_j_mod;
    assign dbg_local_op_j_set   = _op_j_set;
    assign dbg_local_op_jc      = _op_jc;
    assign dbg_local_op_jc_z    = _op_jc_z;
    assign dbg_local_op_jc_nz   = _op_jc_nz;
    assign dbg_local_op_i       = _op_i;
    assign dbg_local_op_o       = _op_o;


    assign flag_op_caddr = (
        (_op_nop)                                               ? CADDR_INC : (
        (_op_d)                                                 ? CADDR_INC : (
        (_op_s)                                                 ? CADDR_INC : (
        (_op_j_mod)                                             ? CADDR_MOD : (
        (_op_j_set)                                             ? CADDR_SET : (
        (_op_jc_z && flag_cond_zero)                            ? CADDR_MOD : (
        (_op_jc_z && ~flag_cond_zero)                           ? CADDR_INC : (
        (_op_jc_nz && ~flag_cond_zero)                          ? CADDR_MOD : (
        (_op_jc_nz && flag_cond_zero)                           ? CADDR_INC : (
        (_op_i && io_input_ready && ~io_input_done)             ? CADDR_INC : (
        (_op_o && ~io_output_ready && ~io_output_done)          ? CADDR_INC : (
                                                                  CADDR_NOP
    ))))))))))));

    assign flag_op_daddr = (
        (_op_s_mod)                                             ? DADDR_MOD : (
        (_op_s_set)                                             ? DADDR_SET : (
                                                                  DADDR_NOP
    )));

    assign flag_op_data = (
        (_op_d_mod)                                             ? DATA_MOD : (
        (_op_d_set)                                             ? DATA_SET : (
        (_op_i && io_input_ready && ~io_input_done)             ? DATA_GET : (
        (_op_o && ~io_output_ready && ~io_output_done)          ? DATA_SET : (
                                                                  DATA_NOP
    )))));

    assign flag_op_data = (
        (_op_d_mod)                                             ? DATA_MOD : (
        (_op_d_set)                                             ? DATA_SET : (
        (_op_i && io_input_ready && ~io_input_done)             ? DATA_GET : (
        (_op_o && ~io_output_ready && ~io_output_done)          ? DATA_SET : (
                                                                  DATA_NOP
    )))));

    assign flag_op_data_wr = (
        (_op_d)                                                 ? 1'b1 : (
        (_op_i && io_input_ready && ~io_input_done)             ? 1'b1 : (
                                                                  1'b0
    )));

    assign flag_op_input_done = (
        (_op_i && io_input_ready && ~io_input_done)             ? 1'b1 : (
        (io_input_done && io_input_ready)                       ? 1'b1 : (
                                                                  1'b0
    )));

    assign flag_op_output_ready = (
        (_op_o && ~io_output_ready && ~io_output_done)          ? 1'b1 : (
        (io_output_ready && ~io_output_done)                    ? 1'b1 : (
                                                                  1'b0
    )));
    
//    assign flag_op_caddr = (
//        (_op_nop)                                               ? CADDR_INC : (
//        (_op_d && ~data_wr)                                     ? CADDR_INC : (
//        (_op_s && ~data_wr)                                     ? CADDR_INC : (
//        (_op_j_mod)                                             ? CADDR_MOD : (
//        (_op_j_set)                                             ? CADDR_SET : (
//        (_op_jc_z && ~data_wr && flag_cond_zero)                ? CADDR_MOD : (
//        (_op_jc_z && ~data_wr && ~flag_cond_zero)               ? CADDR_INC : (
//        (_op_jc_nz && ~data_wr && ~flag_cond_zero)              ? CADDR_MOD : (
//        (_op_jc_nz && ~data_wr && flag_cond_zero)               ? CADDR_INC : (
//        (_op_i && ~data_wr
//            && io_input_ready && ~io_input_done)                ? CADDR_INC : (
//        (_op_o && ~data_wr
//            && ~io_output_ready && ~io_output_done)             ? CADDR_INC : (
//                                                                  CADDR_NOP
//    ))))))))))));

//    assign flag_op_daddr = (
//        (_op_s_mod && ~data_wr)                                 ? DADDR_MOD : (
//        (_op_s_set && ~data_wr)                                 ? DADDR_SET : (
//                                                                  DADDR_NOP
//    )));

//    assign flag_op_data = (
//        (_op_d_mod && ~data_wr)                                 ? DATA_MOD : (
//        (_op_d_set && ~data_wr)                                 ? DATA_SET : (
//        (_op_i && ~data_wr
//            && io_input_ready && ~io_input_done)                ? DATA_GET : (
//        (_op_o && ~data_wr
//            && ~io_output_ready && ~io_output_done)             ? DATA_SET : (
//                                                                  DATA_NOP
//    )))));

//    assign flag_op_data = (
//        (_op_d_mod && ~data_wr)                                 ? DATA_MOD : (
//        (_op_d_set && ~data_wr)                                 ? DATA_SET : (
//        (_op_i && ~data_wr
//            && io_input_ready && ~io_input_done)                ? DATA_GET : (
//        (_op_o && ~data_wr
//            && ~io_output_ready && ~io_output_done)             ? DATA_SET : (
//                                                                  DATA_NOP
//    )))));

//    assign flag_op_data_wr = (
//        (_op_d && ~data_wr)                                     ? 1'b1 : (
//        (_op_i && ~data_wr
//            && io_input_ready && ~io_input_done)                ? 1'b1 : (
//                                                                  1'b0
//    )));

//    assign flag_op_input_done = (
//        (_op_i && ~data_wr
//            && io_input_ready && ~io_input_done)                ? 1'b1 : (
//        (io_input_done && io_input_ready)                       ? 1'b1 : (
//                                                                  1'b0
//    )));

//    assign flag_op_output_ready = (
//        (_op_o && ~data_wr
//            && ~io_output_ready && ~io_output_done)             ? 1'b1 : (
//        (io_output_ready && ~io_output_done)                    ? 1'b1 : (
//                                                                  1'b0
//    )));
    
endmodule
