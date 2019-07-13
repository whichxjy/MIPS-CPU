`timescale 1ns / 1ps

module PCSelect(
    input RST,
    input [1:0] PCSrc,
    input [31:0] curPC,
    input [31:0] ExtendImmediate,
    input [31:0] rsData,
    input [25:0] addr,
    output reg [31:0] nextPC
    );
    
    reg [31:0] pc4; // (PC + 4)
    
    always @( RST or PCSrc or curPC or ExtendImmediate or rsData or addr ) begin
        if (RST == 0) begin
            nextPC = 0;
        end
        else begin
            pc4 = curPC + 4;
            case (PCSrc)
                2'b00 : nextPC = pc4;
                2'b01 : nextPC = pc4 + (ExtendImmediate << 2);
                2'b10 : nextPC = rsData;
                2'b11 : nextPC = {pc4[31:28], addr[25:0], 2'b00};
                default : nextPC = 32'h00000000;
            endcase
        end
    end
    
endmodule