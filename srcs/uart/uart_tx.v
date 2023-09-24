`timescale 1ns / 1ps

module uart_tx
#(
    parameter CLK_FREQ = 200_000_000,
    parameter BAUDRATE = 9600
)
(
    input   clk,
    output  tx,
    input   rst_n,
    
    input   [7:0] data_tx,
    input   ready_tx,
    output  done_tx,
    
    input   dbg_clk
);

    localparam CLK_PER_2T_BAUD = CLK_FREQ / (BAUDRATE * 2);
    localparam CLK_PER_BAUD = CLK_FREQ / BAUDRATE;
    
    reg r_done_tx = 1'b0;
    assign done_tx = r_done_tx;



    reg [17:0] cnt_clk = 18'h000;
    reg [3:0] cnt_tx = 4'h0;
    reg tx_clk = 1'b0;
    reg [7:0] tx_buf = 8'h00;
    reg tx_en = 1'b0;
    reg tx_out = 1'b1;
    
    assign tx = tx_out;
    always @(posedge ready_tx or posedge done_tx or negedge rst_n) begin
        if (~rst_n) begin
            tx_en <= 1'b0;
        end else if (tx_en & done_tx) begin
            tx_en <= 1'b0;
        end else if (~tx_en & ready_tx) begin
            tx_buf <= data_tx;
            tx_en <= 1'b1;
        end
    end
    
    always @(posedge clk or negedge tx_en or negedge rst_n) begin
        if (~rst_n) begin
            cnt_clk <= 18'h000;
            cnt_tx <= 4'h0;
            tx_clk <= 1'b0;
        end else if (~tx_en) begin
            cnt_clk <= 18'h000;
            cnt_tx <= 4'h0;
            tx_clk <= 1'b0;
        end else begin
            if (cnt_clk == CLK_PER_BAUD - 1) begin
                cnt_clk <= 18'h000;
                cnt_tx <= cnt_tx + 1;
            end else begin
                cnt_clk <= cnt_clk + 1;
            end
            if (cnt_clk == 1) begin
                tx_clk <= 1'b1;
            end else if (cnt_clk == CLK_PER_2T_BAUD) begin
                tx_clk <= 1'b0;
            end
        end
    end
    
    always @(posedge tx_clk or negedge ready_tx or negedge rst_n) begin
        if (~rst_n) begin
            r_done_tx <= 1'b0;
        end else if (~ready_tx) begin
            r_done_tx <= 1'b0;
        end else if (cnt_tx == 4'hA) begin
            r_done_tx <= 1'b1;
        end
    end
    
    always @(posedge tx_clk or negedge rst_n) begin
        if (~rst_n) begin
            tx_out <= 1;
        end else begin
            case (cnt_tx)
            4'h0:       tx_out <= 1'b0;
            4'h1:       tx_out <= tx_buf[0];
            4'h2:       tx_out <= tx_buf[1];
            4'h3:       tx_out <= tx_buf[2];
            4'h4:       tx_out <= tx_buf[3];
            4'h5:       tx_out <= tx_buf[4];
            4'h6:       tx_out <= tx_buf[5];
            4'h7:       tx_out <= tx_buf[6];
            4'h8:       tx_out <= tx_buf[7];
            default:    tx_out <= 1'b1;
            endcase
        end
    end
    
endmodule
