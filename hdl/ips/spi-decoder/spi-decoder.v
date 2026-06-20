// SPDX-FileCopyrightText: 2026 SpaceLab UFSC
// SPDX-License-Identifier: GPL-2.0-only

module spi_cs_decoder (
    input  wire ss0,
    input  wire ss1,
    input  wire ss2,
    output wire cs0_n,
    output wire cs1_n,
    output wire cs2_n,
    output wire cs3_n,
    output wire cs4_n,
    output wire cs5_n,
    output wire cs6_n,
    output wire cs7_n
);

    wire [2:0] ss_code;
    reg  [7:0] cs_n;

    assign ss_code = {ss2, ss1, ss0};

    always @(*) begin
        cs_n = 8'b1111_1111;

        case (ss_code)
            3'b000: cs_n[0] = 1'b0;
            3'b001: cs_n[1] = 1'b0;
            3'b010: cs_n[2] = 1'b0;
            3'b011: cs_n[3] = 1'b0;
            3'b100: cs_n[4] = 1'b0;
            3'b101: cs_n[5] = 1'b0;
            3'b110: cs_n[6] = 1'b0;
            3'b111: cs_n[7] = 1'b0;
            default: cs_n = 8'b1111_1111;
        endcase
    end

    assign cs0_n = cs_n[0];
    assign cs1_n = cs_n[1];
    assign cs2_n = cs_n[2];
    assign cs3_n = cs_n[3];
    assign cs4_n = cs_n[4];
    assign cs5_n = cs_n[5];
    assign cs6_n = cs_n[6];
    assign cs7_n = cs_n[7];

endmodule
