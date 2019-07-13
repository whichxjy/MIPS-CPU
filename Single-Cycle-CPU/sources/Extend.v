`timescale 1ns / 1ps

module Extend(
    input ExtSel,
    input [15:0] ExtIn, //Input data
    output reg [31:0] ExtOut // Extended data
    );
    
    always @(ExtSel or ExtIn) begin
        ExtOut[15:0] = ExtIn;
        if (ExtSel == 0 || ExtIn[15] == 0)
            ExtOut[31:16] = 16'h0000;
        else if (ExtSel == 1 && ExtIn[15] == 1)
            ExtOut[31:16] = 16'hffff;
        else
            ExtOut = 32'hzzzz;           
    end 
endmodule