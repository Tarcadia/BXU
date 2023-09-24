`timescale 1ns / 1ps

module top_uart_buffer_echo
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

    buffer_chain
    #(
        .DATA_BITWIDTH(8),
        .DEPTH(16)
    )
    u_buffer
    (
        .clk(clk_5M),
        .rst_n(flag_clk_locked),
        .data_in(data_rx),
        .ready_in(ready_rx),
        .done_in(done_rx),
        .data_out(data_tx),
        .ready_out(ready_tx),
        .done_out(done_tx)
    );
    
//    ila_0 u_ial_0(
//        .clk(clk_50M),
//        .probe0(uart_rx),
//        .probe1(uart_tx),
//        .probe2(ready_rx),
//        .probe3(done_rx),
//        .probe4(ready_tx),
//        .probe5(done_tx),
//        .probe6(0),
//        .probe7(0),
//        .probe8(clk_5M),
//        .probe9(clk_uart),
//        .probe10(data_rx),
//        .probe11(data_tx)
//    );
    
endmodule