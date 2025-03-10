`timescale 1ns/1ps

`include "define.vh"

module Adder_16_bit (
    input wire [15:0] A_i,
    input wire [15:0] B_i,
    input wire Cin_i,
    output wire [15:0] Sum_o,
    output wire Cout_o
);

    wire c1_w, c2_w, c3_w;

    Adder_4_bit adder0(
        .A_i(A_i[3:0]),
        .B_i(B_i[3:0]),
        .Cin_i(Cin_i),
        .Sum_o(Sum_o[3:0]),
        .Cout_o(c1_w)
    );

    Adder_4_bit adder1(
        .A_i(A_i[7:4]),
        .B_i(B_i[7:4]),
        .Cin_i(c1_w),
        .Sum_o(Sum_o[7:4]),
        .Cout_o(c2_w)
    );

    Adder_4_bit adder2(
        .A_i(A_i[11:8]),
        .B_i(B_i[11:8]),
        .Cin_i(c2_w),
        .Sum_o(Sum_o[11:8]),
        .Cout_o(c3_w)
    );

    Adder_4_bit adder3(
        .A_i(A_i[15:12]),
        .B_i(B_i[15:12]),
        .Cin_i(c3_w),
        .Sum_o(Sum_o[15:12]),
        .Cout_o(Cout_o)
    );

endmodule


module Adder_32_bit (
    input wire [`ADDER_WIDTH-1:0] A_i,
    input wire [`ADDER_WIDTH-1:0] B_i,
    input wire Cin_i,
    output wire [`ADDER_WIDTH-1:0] Sum_o,
    output wire Cout_o
);
    wire c1_w;

    Adder_16_bit adder0(
        .A_i(A_i[15:0]),
        .B_i(B_i[15:0]),
        .Cin_i(Cin_i),
        .Sum_o(Sum_o[15:0]),
        .Cout_o(c1_w)
    );

    Adder_16_bit adder1(
        .A_i(A_i[31:16]),
        .B_i(B_i[31:16]),
        .Cin_i(c1_w),
        .Sum_o(Sum_o[31:16]),
        .Cout_o(Cout_o)
    );

endmodule

module top_Adder_32_bit(
    input wire        CLK,
    input wire        RST,
    input wire [`ADDER_WIDTH-1:0] A_i,
    input wire [`ADDER_WIDTH-1:0] B_i,
    input wire Cin_i,
    input wire load_i,
    output wire [`ADDER_WIDTH-1:0] Sum_o,
    output wire Cout_o
);
    reg [`ADDER_WIDTH-1:0] A_r, B_r, Cin_r;
    wire [`ADDER_WIDTH-1:0] A_w, B_w, Cin_w;

    assign A_w = A_r;
    assign B_w = B_r;
    assign Cin_w = Cin_r;


    always @(posedge CLK or negedge RST) begin
        if (~RST) begin
            A_r <= 32'b0;
            B_r <= 32'b0;
            Cin_r <= 1'b0;
        end
        else begin
            if(load_i == 1'b1) begin
                A_r <= A_i;
                B_r <= B_i;
                Cin_r <= Cin_i;
            end
            else begin
                A_r <= A_w;
                B_r <= B_w;
                Cin_r <= Cin_w;
            end
        end
    end

    Adder_32_bit adder0(
        .A_i(A_w),
        .B_i(B_w),
        .Cin_i(Cin_w),  // Carry in of 32-bit adder
        .Sum_o(Sum_o),
        .Cout_o(Cout_o)
    );



endmodule
    