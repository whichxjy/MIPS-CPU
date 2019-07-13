`timescale 1ns / 1ps

module ControlUnit(
    input [5:0] Op,
    input zero,
    output PCWre,
    output ALUSrcA,
    output reg ALUSrcB,
    output DBDataSrc,
    output reg RegWre,
    output InsMemRW,
    output mRD,
    output mWR,
    output reg RegDst,
    output ExtSel,
    output reg [1:0] PCSrc,
    output reg [2:0] ALUOp
    );
    
     assign PCWre = (Op == 6'b111111) ? 0 : 1;
     assign ALUSrcA = (Op == 6'b011000) ? 1 : 0;
     assign DBDataSrc = (Op == 6'b100111) ? 1 : 0;
     assign mRD = (Op == 6'b100111) ? 0 : 1;
     assign mWR = (Op == 6'b100110) ? 0 : 1;
     assign ExtSel = (Op == 6'b010000 || Op == 6'b010010) ? 0 : 1;
     assign InsMemRW = 1;
    
    always @(Op or zero) begin
        case(Op)
            // add rd, rs, rt
            6'b000000: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            // sub rd, rs, rt
            6'b000001: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b001;
            end
            // addiu rt, rs, immediate
            6'b000010: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            // andi rt, rs, immediate
            6'b010000: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b100;
            end
            // and rd, rs, rt
            6'b010001: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b100;
            end
            // ori rt, rs, immediate
            6'b010010: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b011;
            end
            // or rd, rs, rt
            6'b010011: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b011;
            end
            // sll rd, rt, sa
            6'b011000: begin
                ALUSrcB = 0;
                RegWre = 1;
                RegDst = 1;
                PCSrc = 2'b00;
                ALUOp = 3'b010;
            end
            // slti rt, rs, immediate
            6'b011100: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b110;
            end
            // sw rt, immediate(rs)
           6'b100110: begin
                ALUSrcB = 1;
                RegWre = 0;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            // lw rt, immediate(rs)
            6'b100111: begin
                ALUSrcB = 1;
                RegWre = 1;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            // beq rs, rt, immediate
            6'b110000: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = (zero == 1) ? 2'b01 : 2'b00;
                ALUOp = 3'b001;
            end
            // bne rs, rt, immediate
            6'b110001: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = (zero == 0) ? 2'b01 : 2'b00;
                ALUOp = 3'b001;
            end
            // bltz rs, immediate
            6'b110010: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = (zero == 0) ? 2'b01 : 2'b00;
                ALUOp = 3'b110;
            end
            // j addr
            6'b111000: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = 2'b10;
                ALUOp = 3'b000;
            end
            // halt
            6'b111111: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
            // default
            default: begin
                ALUSrcB = 0;
                RegWre = 0;
                RegDst = 0;
                PCSrc = 2'b00;
                ALUOp = 3'b000;
            end
        endcase
    end 
endmodule