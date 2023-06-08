`timescale 1ns / 1ps

module disp_ctrl(
    input logic [3:0] disp_val,
    output logic [6:0] seg_out
    );
    
    always_comb begin
        case (disp_val)
            4'h0: seg_out = 7'b1111110;
            4'h1: seg_out = 7'b0110000;
            4'h2: seg_out = 7'b1101101;
            4'h3: seg_out = 7'b1111001;
            4'h4: seg_out = 7'b0110011;
            4'h5: seg_out = 7'b1011011;
            4'h6: seg_out = 7'b1011111;
            4'h7: seg_out = 7'b1110000;
            4'h8: seg_out = 7'b1111111;
            4'h9: seg_out = 7'b1110011;
            4'hA: seg_out = 7'b1110111;
            4'hb: seg_out = 7'b0011111;
            4'hC: seg_out = 7'b1001110;
            4'hd: seg_out = 7'b0111101;
            4'hE: seg_out = 7'b1001111;
            4'hF: seg_out = 7'b1000111;
        endcase
    end
endmodule
