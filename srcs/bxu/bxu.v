`timescale 1ns / 1ps

// BIT ORDER        : 01 23                 F E D C BA987654    3:0

// nop              : 00 00                 X X X X XXXXXXXX    0

// d[]+     #inst   : 01 00                 0 0 0 0 #inst       2
// d[]-     #inst   : 01 00                 1 0 0 0 #inst       2
// d[]=     #inst   : 01 01                 0 0 0 0 #inst       A
// d[]=     d[]     : 01 01                 0 0 1 0 00000000    A

// seek+    #inst   : 01 10                 0 #inst             6
// seek-    #inst   : 01 10                 1 #inst             6
// seekl=   #inst   : 01 11                 0 0 0 0 #inst       E
// seekh=   #inst   : 01 11                 0 0 0 1 #inst       E
// seekl=   d[]     : 01 11                 0 0 1 0 XXXXXXXX    E
// seekh=   d[]     : 01 11                 0 0 1 1 XXXXXXXX    E

// jmp+     #inst   : 10 00                 0 #inst             1
// jmp-     #inst   : 10 00                 1 #inst             1
// jmp=     #inst   : 10 01                 #inst               9

// jz+      #isnt   : 10 11                 0 #inst             D
// jz-      #isnt   : 10 11                 1 #inst             D
// jnz+     #inst   : 10 10                 0 #inst             5
// jnz-     #inst   : 10 10                 1 #inst             5

// in               : 11 01                 0 0 0 0 00000000    B
// out      #inst   : 11 00                 0 0 0 0 #inst       3
// out      d[]     : 11 00                 0 0 1 0 00000000    3

module bxu
#(
    parameter DATA_BITWIDTH = 8,
    parameter CODE_BITWIDTH = 16,
    parameter ADDR_BITWIDTH = 16
)
(
    input   clk,
    input   rst_n,

    output  [ADDR_BITWIDTH-1:0] code_addr,
    input   [CODE_BITWIDTH-1:0] code_in,

    output  [ADDR_BITWIDTH-1:0] data_addr,
    input   [DATA_BITWIDTH-1:0] data_in,
    output  [DATA_BITWIDTH-1:0] data_out,
    output  data_wr,

    input   [DATA_BITWIDTH-1:0] io_input_data,
    input   io_input_ready,
    output  io_input_done,

    // Reuse data_out,
    // output  [DATA_BITWIDTH-1:0] io_output_data,
    output  io_output_ready,
    input   io_output_done,

    input   dbg_clk,
    output  [1:0] dbg_flag_op_caddr,
    output  [1:0] dbg_flag_op_daddr,
    output  [1:0] dbg_flag_op_data,
    output  dbg_flag_op_data_wr,
    output  dbg_flag_op_input_done,
    output  dbg_flag_op_output_ready

);

    localparam CADDR_NOP = 2'h0;
    localparam CADDR_INC = 2'h1;
    localparam CADDR_MOD = 2'h2;
    localparam CADDR_SET = 2'h3;

    localparam DADDR_NOP = 2'h0;
    localparam DADDR_MOD = 2'h1;
    localparam DADDR_SET = 2'h2;

    localparam DATA_NOP = 2'h0;
    localparam DATA_MOD = 2'h1;
    localparam DATA_SET = 2'h2;
    localparam DATA_GET = 2'h3;

    wire [1:0] flag_op_caddr;
    wire [1:0] flag_op_daddr;
    wire [1:0] flag_op_data;
    wire flag_op_data_wr;
    wire flag_op_input_done;
    wire flag_op_output_ready;
    
    assign dbg_flag_op_caddr = flag_op_caddr;
    assign dbg_flag_op_daddr = flag_op_daddr;
    assign dbg_flag_op_data = flag_op_data;
    assign dbg_flag_op_data_wr = flag_op_data_wr;
    assign dbg_flag_op_input_done = flag_op_input_done;
    assign dbg_flag_op_output_ready = flag_op_output_ready;
    
    front
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .CODE_BITWIDTH(CODE_BITWIDTH),
        
        .CADDR_NOP(CADDR_NOP),
        .CADDR_INC(CADDR_INC),
        .CADDR_MOD(CADDR_MOD),
        .CADDR_SET(CADDR_SET),
        .DADDR_NOP(DADDR_NOP),
        .DADDR_MOD(DADDR_MOD),
        .DADDR_SET(DADDR_SET),
        .DATA_NOP(DATA_NOP),
        .DATA_MOD(DATA_MOD),
        .DATA_SET(DATA_SET),
        .DATA_GET(DATA_GET)
    )
    u_front
    (
        .clk(clk),
        .rst_n(rst_n),

        .code(code_in),
        .data(data_in),
        .data_wr(data_wr),
        .io_input_ready(io_input_ready),
        .io_input_done(io_input_done),
        .io_output_ready(io_output_ready),
        .io_output_done(io_output_done),

        .flag_op_caddr(flag_op_caddr),
        .flag_op_daddr(flag_op_daddr),
        .flag_op_data(flag_op_data),
        .flag_op_data_wr(flag_op_data_wr),
        .flag_op_input_done(flag_op_input_done),
        .flag_op_output_ready(flag_op_output_ready),

        .dbg_clk(dbg_clk)
    );

    

    op_caddr
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .CODE_BITWIDTH(CODE_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH),

        .CADDR_NOP(CADDR_NOP),
        .CADDR_INC(CADDR_INC),
        .CADDR_MOD(CADDR_MOD),
        .CADDR_SET(CADDR_SET)
    )
    u_op_caddr
    (
        .clk(clk),
        .rst_n(rst_n),

        .flag_op_caddr(flag_op_caddr),
        .code(code_in),
        .data(data_in),
        .code_addr(code_addr),

        .dbg_clk(dbg_clk)
    );

    op_daddr
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .CODE_BITWIDTH(CODE_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH),

        .DADDR_NOP(DADDR_NOP),
        .DADDR_MOD(DADDR_MOD),
        .DADDR_SET(DADDR_SET)
    )
    u_op_daddr
    (
        .clk(clk),
        .rst_n(rst_n),

        .flag_op_daddr(flag_op_daddr),
        .code(code_in),
        .data(data_in),
        .data_addr(data_addr),
        
        .dbg_clk(dbg_clk)
    );

    op_data
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .CODE_BITWIDTH(CODE_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH),

        .DATA_NOP(DATA_NOP),
        .DATA_MOD(DATA_MOD),
        .DATA_SET(DATA_SET),
        .DATA_GET(DATA_GET)
    )
    u_op_data
    (
        .clk(clk),
        .rst_n(rst_n),

        .flag_op_data(flag_op_data),
        .flag_op_data_wr(flag_op_data_wr),
        .code(code_in),
        .data(data_in),
        .in(io_input_data),
        .data_out(data_out),
        .data_wr(data_wr),

        .dbg_clk(dbg_clk)
    );

    op_io
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .CODE_BITWIDTH(CODE_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH)
    )
    u_op_io
    (
        .clk(clk),
        .rst_n(rst_n),

        .flag_op_input_done(flag_op_input_done),
        .flag_op_output_ready(flag_op_output_ready),

        .io_input_done(io_input_done),
        .io_output_ready(io_output_ready),

        .dbg_clk(dbg_clk)

    );

    ila_bxu u_ila_bxu
    (
        .clk(dbg_clk),
        .probe0(clk),
        .probe1(rst_n),
        .probe2(code_addr),
        .probe3(code_in),
        .probe4(data_addr),
        .probe5(data_in),
        .probe6(data_out),
        .probe7(data_wr),
        .probe8(io_input_data),
        .probe9(io_input_ready),
        .probe10(io_input_done),
        .probe11(io_output_ready),
        .probe12(io_output_done),
        .probe13(flag_op_caddr),
        .probe14(flag_op_daddr),
        .probe15(flag_op_data),
        .probe16(flag_op_data_wr),
        .probe17(flag_op_input_done),
        .probe18(flag_op_output_ready)

    );
    
endmodule