`timescale 1ns / 1ps

module uart
#(
    parameter CLK_FREQ = 200_000_000,
    parameter BAUDRATE = 9600
)
(
    input   clk,
    input   rx,
    output  tx,
    input   rst_n,
    
    output  [7:0] data_rx,
    output  ready_rx,
    input   done_rx,
    
    input   [7:0] data_tx,
    input   ready_tx,
    output  done_tx,
    
    input   dbg_clk
);

    uart_rx
    #(
        .CLK_FREQ(CLK_FREQ),
        .BAUDRATE(BAUDRATE)
    )
    u_uart_rx
    (
        .clk(clk),
        .rx(rx),
        .rst_n(rst_n),
        .data_rx(data_rx),
        .ready_rx(ready_rx),
        .done_rx(done_rx),
        .dbg_clk(dbg_clk)
    );

    uart_tx
    #(
        .CLK_FREQ (CLK_FREQ),
        .BAUDRATE (BAUDRATE)
    )
    u_uart_tx
    (
        .clk(clk),
        .tx(tx),
        .rst_n(rst_n),
        .data_tx(data_tx),
        .ready_tx(ready_tx),
        .done_tx(done_tx),
        .dbg_clk(dbg_clk)
    );

endmodule
