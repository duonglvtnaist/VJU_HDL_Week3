`timescale 1ns / 1ps

`include "define.vh"

module tb_adder_32_bit();

    reg [`ADDER_WIDTH-1:0] A_r, B_r;
    reg Cin_r, load_r;
    wire [`ADDER_WIDTH-1:0] Sum_w;
    wire Cout_w;
    reg CLK, RST;
    

    top_Adder_32_bit adder0(
        .CLK(CLK),
        .RST(RST),
        .A_i(A_r),
        .B_i(B_r),
        .Cin_i(Cin_r),
        .load_i(load_r),
        .Sum_o(Sum_w),
        .Cout_o(Cout_w)
    );

    parameter PERIOD = 10;
   
    always begin
       #(PERIOD/2) CLK = ~CLK;
    end

    task reset(input [7:0] num_reset);
        begin
            RST = 1'b0;
            #(PERIOD*num_reset) RST = 1'b1;
        end
    endtask


    initial begin: main_test;
        CLK = 1'b0;
        RST = 1'b1;
        A_r = 32'b0;
        B_r = 32'b0;
        Cin_r = 1'b0;
        load_r = 1'b0;
        #(10*PERIOD)
        reset(100);
        A_r = 32'd135;
        B_r = 32'd498;
        Cin_r = 1'b1;
        #(20*PERIOD) $display("Sum = %d, Cout = %d", Sum_w, Cout_w);
        load_r = 1'b1;
        A_r = 32'd45678;
        B_r = 32'd21672;
        Cin_r = 1'b0;
        #(20*PERIOD) $display("Sum = %d, Cout = %d", Sum_w, Cout_w);
        #(20*PERIOD) $finish;
    end

endmodule