`timescale 1ns / 1ps

module buffer
#(
    parameter DATA_BITWIDTH = 8
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

    reg [DATA_BITWIDTH-1:0] data = 0;
    reg r_done_data = 1'b0;
    reg r_ready_data = 1'b0;

    assign data_out = data;
    assign done_in = r_done_data;
    assign ready_out = r_ready_data;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_done_data <= 1'b0;
            r_ready_data <= 1'b0;
        end else begin
            case ({ready_in, r_done_data, r_ready_data, done_out})
            4'b0000:    ;
            4'b0001:    ;
            4'b0010:    ;
            4'b0011:    begin
                            r_ready_data <= 1'b0;
                        end
            4'b0100:    begin
                            r_ready_data <= 1'b1;
                            r_done_data <= 1'b0;
                        end
            4'b0101:    ;
            4'b0110:    begin
                            r_done_data <= 1'b0;
                        end
            4'b0111:    begin
                            r_done_data <= 1'b0;
                            r_ready_data <= 1'b0;
                        end
            4'b1000:    begin
                            data <= data_in;
                            r_done_data <= 1'b1;
                        end
            4'b1001:    begin
                            data <= data_in;
                            r_done_data <= 1'b1;
                        end
            4'b1010:    ;
            4'b1011:    begin
                            data <= data_in;
                            r_ready_data <= 1'b0;
                            r_done_data <= 1'b1;
                        end
            4'b1100:    begin
                            r_ready_data <= 1'b1;
                        end
            4'b1101:    ;
            4'b1110:    ;
            4'b1111:    ;
            endcase
        end
    end

endmodule