`timescale 1ns / 1ps

module Extend(
    input ExtSel,
    input [15:0] immediate,
    output reg [31:0] ExtendImmediate
    );
    
    always @( ExtSel or immediate ) begin
        ExtendImmediate[15:0] = immediate;
        if (ExtSel == 0 || immediate[15] == 0)
            ExtendImmediate[31:16] = 16'h0000;
        else if (ExtSel == 1 && immediate[15] == 1)
            ExtendImmediate[31:16] = 16'hffff;
        else
            ExtendImmediate = 32'hzzzz;
    end

endmodule