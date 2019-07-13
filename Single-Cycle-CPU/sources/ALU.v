`timescale 1ns / 1ps

module ALU(
    input [2:0] ALUOp,
    input [31:0] regA,
    input [31:0] regB,
    output reg [31:0] result,
    output zero,
    output sign
    );
    
    assign zero = (result == 0) ? 1 : 0;
    assign sign = (result[31] == 0) ? 0 : 1;
    
    always @( ALUOp or regA or regB ) begin
        case (ALUOp)
            3'b000 : result = regA + regB;
            3'b001 : result = regA - regB;
            3'b010 : result = regB << regA;
            3'b011 : result = regA | regB;
            3'b100 : result = regA & regB;
            3'b101 : result = (regA < regB) ? 1 : 0;
            3'b110 : begin
                    if ((regA < regB && (regA[31] == regB[31])) || (regA[31] == 1 && regB[31] == 0))
                        result = 1;
                    else
                        result = 0;
                    end
            3'b111: result = regA ^ regB;
            default : begin
                       result = 32'h00000000;
                    end
        endcase
    end 
endmodule