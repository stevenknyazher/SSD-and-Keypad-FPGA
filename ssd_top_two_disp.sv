`timescale 1ns / 1ps

module ssd_top_two_disp(
    input sysclk,
    input [3:0] btn,
    output [6:0] seg,
    output chip_sel,
    inout [7:0] kypd
    );
    
parameter clk_freq = 50_000_000;
parameter stable_time = 8;

parameter count_width = 20;
logic [count_width-1:0] count = 0;

logic rst;
assign rst = btn[0];

logic clk;
logic dig_sel;
logic is_a_key_pressed;
logic [3:0] decode_out;
logic [3:0] decode_out1;
logic [3:0] decode_out2;
logic [6:0] seg_out1;
logic [6:0] seg_out2;
logic kypd_debounce;
logic kypd_pulse;

clk_wiz_0 clk_i(
        .clk_out1(clk),
        .clk_in1(sysclk)
    );

Decoder dc_inst1 (
        .clk(clk),
        .rst(rst),
        .Row(kypd[3:0]),
        .Col(kypd[7:4]),
        .DecodeOut(decode_out),
        .is_a_key_pressed(is_a_key_pressed)
    );

disp_ctrl ssd_i1 (
        .disp_val(decode_out1),
        .seg_out(seg_out1)
    );
    
disp_ctrl ssd_i2 (
        .disp_val(decode_out2),
        .seg_out(seg_out2)
    );
    
debounce #(
        .clk_freq(clk_freq),
        .stable_time(stable_time)
    )
    db_inst1
    (
        .clk(clk),
        .rst(rst),
        .button(decode_out),
        .result(kypd_debounce)
    );

single_pulse_detector pls_inst1 (
        .clk(clk),
        .rst(rst),
        .input_signal(kypd_debounce),
        .output_pulse(kypd_pulse)
    );
    
always @(posedge rst, posedge clk) begin
    if (rst == 1) begin
        dig_sel = 1'b0;
        decode_out1 = 1'b0;
        decode_out2 = 1'b0;
    end
    else begin
        if (kypd_pulse == 1) begin
            dig_sel = ~dig_sel;
        end
        else begin
            if (!dig_sel) begin
                decode_out1 = decode_out;
            end
            else begin
                decode_out2 = decode_out;
            end
        end
    end
end

always @(posedge clk) begin
    if (rst == 1) begin
        count = 0;
    end
    else begin
        count = count + 1;
    end
end

assign chip_sel = count[count_width-1];
assign seg = (!count[count_width-1]) ? seg_out1 : seg_out2;

endmodule
