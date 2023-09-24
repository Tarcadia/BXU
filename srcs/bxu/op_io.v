`timescale 1ns / 1ps

module op_io
#(
    parameter DATA_BITWIDTH = 8,
    parameter CODE_BITWIDTH = 16,
    parameter ADDR_BITWIDTH = 16
)
(
    input   clk,
    input   rst_n,
    
    input   flag_op_input_done,
    input   flag_op_output_ready,

    output  io_input_done,
    output  io_output_ready,

    input   dbg_clk
);

    reg r_io_input_done = 1'b0;
    assign io_input_done = r_io_input_done;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_io_input_done <= 1'b0;
        end else begin
            r_io_input_done <= flag_op_input_done;
        end
    end

    reg r_io_output_ready = 1'b0;
    reg r_io_output_ready_delay = 1'b0;
    assign io_output_ready = r_io_output_ready & r_io_output_ready_delay;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_io_output_ready <= 1'b0;
        end else begin
            r_io_output_ready <= flag_op_output_ready;
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_io_output_ready_delay <= 1'b0;
        end else begin
            r_io_output_ready_delay <= r_io_output_ready;
        end
    end

endmodule
