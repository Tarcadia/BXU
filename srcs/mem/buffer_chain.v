`timescale 1ns / 1ps

module buffer_chain
#(
    parameter DATA_BITWIDTH = 8,
    parameter DEPTH = 16
)
(
    input   clk,
    input   rst_n,

    input   [DATA_BITWIDTH-1:0] data_in,
    input   ready_in,
    output  done_in,

    output  [DATA_BITWIDTH-1:0] data_out,
    output  ready_out,
    input   done_out
);

    genvar i;
    generate
        wire [DATA_BITWIDTH-1:0] data [0:DEPTH];
        wire ready [0:DEPTH];
        wire done [0:DEPTH];
        assign data[0] = data_in;
        assign ready[0] = ready_in;
        assign done[0] = done_in;
        assign data_out = data[DEPTH];
        assign ready_out = ready[DEPTH];
        assign done_out = done[DEPTH];
        for ( i = 0 ; i < DEPTH ; i = i + 1 ) begin : block_buffer
            buffer
            #(
                .DATA_BITWIDTH(DATA_BITWIDTH)
            )
            u_buffer
            (
                .clk(clk),
                .rst_n(rst_n),
                .data_in(data[i]),
                .ready_in(ready[i]),
                .done_in(done[i]),
                .data_out(data[i+1]),
                .ready_out(ready[i+1]),
                .done_out(done[i+1])
            );
        end
    endgenerate
    
endmodule