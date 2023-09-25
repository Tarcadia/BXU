`timescale 1ns / 1ps

module top_uart_bxu_echo
(
    sys_clk_n,
    sys_clk_p,
    uart_rx,
    uart_tx
);
    input sys_clk_n;
    input sys_clk_p;
    input uart_rx;
    output uart_tx;
    
    wire sys_clk_n;
    wire sys_clk_p;
    wire uart_rx;
    wire uart_tx;
    
    wire clk_100M;  // @ 100.000000MHz
    wire clk_50M;   // @  50.000000MHz
    wire clk_5M;    // @   5.078120MHz;
    wire clk_uart;  // @   6.914890MHz expecting 6.912MHz;
    wire flag_clk_locked;
    
    clk_wiz_0 u_clk_wiz_0
    (
        .clk_100M(clk_100M),
        .clk_50M(clk_50M),
        .clk_5M(clk_5M),
        .clk_uart(clk_uart),
        .locked(flag_clk_locked),
        .clk_in1_p(sys_clk_p),
        .clk_in1_n(sys_clk_n)
    );
    
    wire [7:0] data_rx;
    wire ready_rx;
    wire done_rx;

    wire [7:0] data_tx;
    wire ready_tx;
    wire done_tx;

    uart
    #(
        .CLK_FREQ(6_914_890),
        .BAUDRATE(38400)
    )
    u_uart
    (
        .clk(clk_uart),
        .rx(uart_rx),
        .tx(uart_tx),
        .rst_n(flag_clk_locked),
        .data_rx(data_rx),
        .ready_rx(ready_rx),
        .done_rx(done_rx),
        .data_tx(data_tx),
        .ready_tx(ready_tx),
        .done_tx(done_tx),
        .dbg_clk(clk_50M)
    );


    parameter DATA_BITWIDTH = 8;
    parameter CODE_BITWIDTH = 16;
    parameter ADDR_BITWIDTH = 16;

    wire [ADDR_BITWIDTH-1:0] code_addr;
    wire [CODE_BITWIDTH-1:0] code;

    wire [ADDR_BITWIDTH-1:0] data_addr;
    wire [DATA_BITWIDTH-1:0] data_in;
    wire [DATA_BITWIDTH-1:0] data_out;
    wire data_wr;

    assign data_tx = data_out;
    
    wire [1:0] dbg_flag_op_caddr;
    wire [1:0] dbg_flag_op_daddr;
    wire [1:0] dbg_flag_op_data;
    wire dbg_flag_op_data_wr;
    wire dbg_flag_op_input_done;
    wire dbg_flag_op_output_ready;
    
    bxu
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .CODE_BITWIDTH(CODE_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH)
    )
    u_bxu
    (
        // .clk(clk_100M),
        .clk(clk_5M),
        .rst_n(flag_clk_locked),

        .code_addr(code_addr),
        .code_in(code),
        
        .data_addr(data_addr),
        .data_in(data_in),
        .data_out(data_out),
        .data_wr(data_wr),
        
        .io_input_data(data_rx),
        .io_input_ready(ready_rx),
        .io_input_done(done_rx),
        .io_output_ready(ready_tx),
        .io_output_done(done_tx),
        
        .dbg_clk(clk_50M),
        .dbg_flag_op_caddr(dbg_flag_op_caddr),
        .dbg_flag_op_daddr(dbg_flag_op_daddr),
        .dbg_flag_op_data(dbg_flag_op_data),
        .dbg_flag_op_data_wr(dbg_flag_op_data_wr),
        .dbg_flag_op_input_done(dbg_flag_op_input_done),
        .dbg_flag_op_output_ready(dbg_flag_op_output_ready)
    );
    
    ram
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH),
        .DEPTH(16)
    )
    u_ram
    (
        .addr_rd(data_addr),
        .data_rd(data_in),
        .addr_wr(data_addr),
        .data_wr(data_out),
        .wr(data_wr)
    );

//    rom_uart_bxu_echo
    rom_a_plus_b
    #(
        .DATA_BITWIDTH(CODE_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH)
    )
    u_rom
    (
        .addr_rd(code_addr),
        .data_rd(code)
    );


//    ila_0 u_ila_0(
//        .clk(clk_50M),
//        .probe0(uart_rx),
//        .probe1(data_wr),
//        .probe2(ready_rx),
//        .probe3(dbg_flag_op_caddr[0]),
//        .probe4(dbg_flag_op_caddr[1]),
//        .probe5(dbg_flag_op_data[0]),
//        .probe6(dbg_flag_op_data[1]),
//        .probe7(uart_tx),
//        .probe8(clk_5M),
//        .probe9(clk_uart),
//        .probe10(data_out),
//        .probe11(code)
//    );

endmodule