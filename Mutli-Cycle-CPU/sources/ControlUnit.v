`timescale 1ns / 1ps

module ControlUnit(
    input CLK,
    input RST,
    input [5:0] Op,
    input zero,
    input sign,
    output reg PCWre,
    output reg ALUSrcA,
    output reg ALUSrcB,
    output reg DBDataSrc,
    output reg RegWre,
    output reg WrRegDSrc,
    output reg InsMemRW,
    output reg mRD,
    output reg mWR,
    output reg IRWre,
    output reg ExtSel,
    output reg [1:0] PCSrc,
    output reg [1:0] RegDst,
    output reg [2:0] ALUOp,
    output reg [2:0] state
    );
    
    reg [2:0] nextState;
    
    initial begin
        state = 3'b000;
    end

    always @( posedge CLK ) begin
        if (RST == 0)
            state <= 3'b000;
        else
            state <= nextState;
    end
    
    always @( state or Op or zero or sign ) begin
        case(state)
            3'b000: nextState = 3'b001;
            3'b001: begin
                if (Op == 6'b110100 || Op == 6'b110101 || Op == 6'b110110)
                    nextState = 3'b101;
                else if (Op == 6'b110000 || Op == 6'b110001)
                    nextState = 3'b010;
                else if (Op == 6'b111000 || Op == 6'b111010 || Op == 6'b111001 || Op == 6'b111111)
                    nextState = 3'b000;
                else
                    nextState = 3'b110;
            end
            3'b110: nextState = 3'b111;
            3'b111: nextState = 3'b000;
            3'b101: nextState = 3'b000;
            3'b010: nextState = 3'b011;
            3'b011: begin
                if (Op == 6'b110000)
                    nextState = 3'b000;
                else if (Op == 6'b110001)
                    nextState = 3'b100;
            end
            3'b100: nextState = 3'b000;
        endcase
        
        // PCWre
        PCWre = (nextState == 3'b000 && Op != 6'b111111) ? 1 : 0;
        
        // ALUSrcA
        ALUSrcA = (Op == 6'b011000) ? 1 : 0;
        
        // ALUSrcB
        ALUSrcB = (Op == 6'b000010 || Op == 6'b010001 || Op == 6'b010010 || Op == 6'b010011 || Op == 6'b100110 
                    || Op == 6'b110001 || Op == 6'b110000) ? 1 : 0;
        
        // DBDataSrc
        DBDataSrc = (Op == 6'b110001) ? 1 : 0;
        
        // RegWre
        RegWre = (state == 3'b111 || state == 3'b100 || (state == 3'b001 && Op == 6'b111010)) ?  1 : 0;
                    
        // WrRegDSrc
        WrRegDSrc = (Op == 6'b111010) ? 0 : 1;
        
        // InsMemRW
        InsMemRW = (state == 3'b000) ? 1 : 1'bz;
        
        // mRD
        mRD = (state == 3'b011 && Op == 6'b110001) ? 0 : 1;
        
        // mWR
        mWR = (state == 3'b011 && Op == 6'b110000) ? 0 : 1;
        
        // IRWre
        IRWre =  (state == 3'b000 || state == 3'b001) ? 1 : 0;
        
        // ExtSel
        ExtSel = (Op == 6'b010001 || Op == 6'b010011 || Op == 6'b010010) ? 0 : 1;
        
        // PCSrc
        if ((Op == 6'b110100 && zero == 1) || (Op == 6'b110101 && zero == 0) || (Op == 6'b110110 && sign == 1))
            PCSrc = 2'b01;
        else if (Op == 6'b111001)
            PCSrc = 2'b10;
        else if (Op == 6'b111000 || Op == 6'b111010)
            PCSrc = 2'b11;
        else
            PCSrc = 2'b00;
        
        // RegDst
        if (Op == 6'b111010)
            RegDst = 2'b00;
        else if (Op == 6'b000010 || Op == 6'b010001 || Op == 6'b010010 || Op == 6'b010011 || Op == 6'b100110 || Op == 6'b110001)
            RegDst = 2'b01;
        else if (Op == 6'b000000 || Op == 6'b000001 || Op == 6'b010000 || Op == 6'b100111 || Op == 6'b011000)
            RegDst = 2'b10;
            
        // ALUOp
        case(Op)
            // add
            6'b000000: ALUOp = 3'b000;
            // sub
            6'b000001: ALUOp = 3'b001;
            // addiu
            6'b000010: ALUOp = 3'b000;
            // and
            6'b010000: ALUOp = 3'b100;
            // andi
            6'b010001: ALUOp = 3'b100;
            // ori
            6'b010010: ALUOp = 3'b011;
            // xori
            6'b010011: ALUOp = 3'b111;
            // sll
            6'b011000: ALUOp = 3'b010;
            // slti
            6'b100110: ALUOp = 3'b110;
            // slt
            6'b100111: ALUOp = 3'b110;
            // sw
            6'b110000: ALUOp = 3'b000;
            // lw
            6'b110001: ALUOp = 3'b000;
            // beq
            6'b110100: ALUOp = 3'b001;
            // bne
            6'b110101: ALUOp = 3'b001;
            // bltz
            6'b110110: ALUOp = 3'b001;
        endcase
    end
    
endmodule