`timescale 1ns / 1ps

module PCSelect(
    input [1:0] PCSrc,
    input [31:0] PC4,
    input [31:0] ExtendOut,
    input [25:0] addr,
    output reg [31:0] PCOut
    );
    
    always @(PCSrc or PC4 or ExtendOut or addr) begin
        case (PCSrc)
            2'b00 : PCOut = PC4;
            2'b01 : PCOut = PC4 + (ExtendOut << 2);
            2'b10 : PCOut = {PC4[31:28], addr[25:0], 2'b00};
            default : PCOut = 32'h00000000; 
        endcase
    end
endmodule