
`timescale 1ns / 1ps

module sim_bxu();

    parameter DATA_BITWIDTH = 8;
    parameter CODE_BITWIDTH = 16;
    parameter ADDR_BITWIDTH = 16;

    reg clk = 0;
    reg rst_n = 0;
    initial #20 rst_n <= 1;
    always #5   clk <= ~clk;
    
    reg [7:0] data_rx = 0;
    reg ready_rx = 0;
    wire done_rx;

    wire [7:0] data_tx;
    wire ready_tx;
    reg done_tx = 0;

    wire [ADDR_BITWIDTH-1:0] code_addr;
    wire [CODE_BITWIDTH-1:0] code;

    wire [ADDR_BITWIDTH-1:0] data_addr;
    wire [DATA_BITWIDTH-1:0] data_in;
    wire [DATA_BITWIDTH-1:0] data_out;
    wire data_wr;

    assign data_tx = data_out;
    
    always begin
        #200    data_rx <= 16'hAA;
        #1      ready_rx <= 1;
        #9      ready_rx <= 0;
        #71     done_tx <= 1;
        #19     done_tx <= 0;
        #81     done_tx <= 1;
        #19     done_tx <= 0;
        #200    data_rx <= 16'hEE;
        #1      ready_rx <= 1;
        #9      ready_rx <= 0;
        #71     done_tx <= 1;
        #19     done_tx <= 0;
        #81     done_tx <= 1;
        #19     done_tx <= 0;
    end

    bxu
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .CODE_BITWIDTH(CODE_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH)
    )
    u_bxu
    (
        .clk(clk),
        .rst_n(1),

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
        
        .dbg_clk(clk)
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

    rom_sim_bxu
    #(
        .DATA_BITWIDTH(CODE_BITWIDTH),
        .ADDR_BITWIDTH(ADDR_BITWIDTH)
    )
    u_rom
    (
        .addr_rd(code_addr),
        .data_rd(code)
    );
    
endmodule