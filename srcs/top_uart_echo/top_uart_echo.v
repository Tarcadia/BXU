`timescale 1ns / 1ps

module top_uart_echo
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
    
    wire clk_100M;  // @ 100.000000MHz;
    wire clk_50M;   // @  50.000000MHz;
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
    
    wire [7:0] data;
    wire ready;
    wire done;

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
        .data_rx(data),
        .ready_rx(ready),
        .done_rx(done),
        .data_tx(data),
        .ready_tx(ready),
        .done_tx(done),
        .dbg_clk(clk_50M)
    );
    
    // ila_0 u_ial_0(
    //     .clk(clk_50M),
    //     .probe0(uart_rx),
    //     .probe1(ready),
    //     .probe2(done),
    //     .probe3(uart_tx),
    //     .probe4(clk_uart),
    //     .probe5(0),
    //     .probe6(0),
    //     .probe7(0),
    //     .probe8(0),
    //     .probe9(0),
    //     .probe10(data),
    //     .probe11(0)
    // );
    
endmodule