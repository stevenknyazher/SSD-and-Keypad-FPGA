`timescale 1ns / 1ps

module ssd_top_part1(
    input clk,
    input [3:0] btn,
    output [6:0] seg,
    output chip_sel,
    inout [7:0] kypd
    );
    
parameter clk_freq = 125_000_000;
parameter stable_time = 10;

logic rst;

logic btn1_debounce;
logic btn1_pulse;

logic c_sel;
logic is_a_key_pressed;
logic [3:0] decoder_out;
assign rst = btn[0];

Decoder dc_inst1 (
        .clk(clk),
        .rst(rst),
        .Row(kypd[3:0]),
        .Col(kypd[7:4]),
        .DecodeOut(decoder_out),
        .is_a_key_pressed(is_a_key_pressed)
    );

disp_ctrl ssd_i (
        .disp_val(decoder_out),
        .seg_out(seg)
    );
    
debounce #(
        .clk_freq(clk_freq),
        .stable_time(stable_time)
    )
    db_inst1
    (
        .clk(clk),
        .rst(rst),
        .button(btn[1]),
        .result(btn1_debounce)
    );

single_pulse_detector #(
        .detect_type(2'b0)
    )
    pls_inst1
    (
        .clk(clk),
        .rst(rst),
        .input_signal(btn1_debounce),
        .output_pulse(btn1_pulse)
    );
    
always_latch @(posedge rst, posedge btn1_pulse) begin
    if (rst == 1) begin
        c_sel = 1'b0;
    end
    else if (btn1_pulse == 1) begin
        c_sel = ~c_sel;
    end
end

assign chip_sel = c_sel;

endmodule
