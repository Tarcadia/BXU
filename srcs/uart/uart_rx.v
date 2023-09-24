`timescale 1ns / 1ps

function MOST;
    input A, B, C;
    begin
        MOST = A && B || B && C || C && A;
    end
endfunction

function MOST_3b;
    input [3:0] A;
    begin
        MOST_3b = MOST(A[0], A[1], A[2]);
    end
endfunction


module uart_rx
#(
    parameter CLK_FREQ = 200_000_000,
    parameter BAUDRATE = 9600
)
(
    input   clk,
    input   rx,
    input   rst_n,
    
    output  [7:0] data_rx,
    output  ready_rx,
    input   done_rx,
    
    input   dbg_clk
);

    reg r_ready_rx = 1'b0;
    assign ready_rx = r_ready_rx;
    
    wire clk_baud;
    
    reg r_baud_rst_n = 1'b0;
    reg r_baud_rst_start = 1'b0;
    
    wire w_baud_flag_start;
    wire [2:0] w_baud_flag_data [0:7];
    wire w_baud_flag_end;
    
    wire w_flag_end;
    assign w_flag_end = w_baud_flag_end | r_baud_rst_start;
    
    UART_BAUD
    #(
        .CLK_FREQ(CLK_FREQ),
        .BAUDRATE(BAUDRATE)
    )
    u_uart_baud
    (
        .clk(clk),
        .rst_n(rst_n & r_baud_rst_n),
        .clk_baud(clk_baud),
        .flag_start(w_baud_flag_start),
        .flag_data({
            w_baud_flag_data[7], w_baud_flag_data[6],
            w_baud_flag_data[5], w_baud_flag_data[4],
            w_baud_flag_data[3], w_baud_flag_data[2],
            w_baud_flag_data[1], w_baud_flag_data[0]
        }),
        .flag_end(w_baud_flag_end),
        .dbg_clk(dbg_clk)
    );

    always @(posedge w_baud_flag_end or posedge done_rx or negedge rst_n) begin
        if (~rst_n) begin
            r_ready_rx <= 1'b0;
        end else if (done_rx) begin
            r_ready_rx <= 1'b0;
        end else if (w_baud_flag_end) begin
            r_ready_rx <= 1'b1;
        end
    end
    
    always @(posedge clk or posedge w_flag_end or negedge rst_n) begin
        if (~rst_n) begin
            r_baud_rst_n <= 1'b0;
        end else if (w_flag_end) begin
            r_baud_rst_n <= 1'b0;
        end else if (~rx && ~r_baud_rst_n && ~r_ready_rx) begin
            r_baud_rst_n <= 1'b1;
        end
    end
    
    always @(posedge clk_baud or negedge r_baud_rst_n or negedge rst_n) begin
        if (~rst_n) begin
            r_baud_rst_start <= 1'b0;
        end else if (~r_baud_rst_n) begin
            r_baud_rst_start <= 1'b0;
        end else if (w_baud_flag_start && rx) begin
            r_baud_rst_start <= 1'b1;
        end
    end
    
    
    reg [2:0] r_data_sample [0:7];
    assign data_rx = {
        MOST_3b(r_data_sample[7]),
        MOST_3b(r_data_sample[6]),
        MOST_3b(r_data_sample[5]),
        MOST_3b(r_data_sample[4]),
        MOST_3b(r_data_sample[3]),
        MOST_3b(r_data_sample[2]),
        MOST_3b(r_data_sample[1]),
        MOST_3b(r_data_sample[0])
    };
    
    integer genvar_data_i;
    
    always @(posedge clk_baud or negedge rst_n) begin
        if (~rst_n) begin
            r_data_sample[7] <= 3'b111;
            r_data_sample[6] <= 3'b111;
            r_data_sample[5] <= 3'b111;
            r_data_sample[4] <= 3'b111;
            r_data_sample[3] <= 3'b111;
            r_data_sample[2] <= 3'b111;
            r_data_sample[1] <= 3'b111;
            r_data_sample[0] <= 3'b111;
        end else begin
            for (genvar_data_i = 0; genvar_data_i < 8; genvar_data_i = genvar_data_i + 1) begin
                case (w_baud_flag_data[genvar_data_i])
                3'b100: r_data_sample[genvar_data_i][2] <= rx;
                3'b010: r_data_sample[genvar_data_i][1] <= rx;
                3'b001: r_data_sample[genvar_data_i][0] <= rx;
                default:;
                endcase
            end
        end
    end
    
//    ila_0 u_ial_0(
//        .clk(dbg_clk),
//        .probe0(rx),
//        .probe1(ready_rx),
//        .probe2(done_rx),
//        .probe3(clk),
//        .probe4(clk_baud),
//        .probe5(w_baud_flag_start),
//        .probe6(w_baud_flag_end),
//        .probe7(0),
//        .probe8(r_baud_rst_start),
//        .probe9(r_baud_rst_n),
//        .probe10(data_rx),
//        .probe11({
//            w_baud_flag_data[7],
//            w_baud_flag_data[6],
//            w_baud_flag_data[5],
//            w_baud_flag_data[4],
//            w_baud_flag_data[3],
//            w_baud_flag_data[2],
//            w_baud_flag_data[1],
//            w_baud_flag_data[0]
//        })
//    );
    
endmodule
