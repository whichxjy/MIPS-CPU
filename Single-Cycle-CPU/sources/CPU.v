`timescale 1ns / 1ps

module CPU(clk, Rst, pc, pcIn, rs, rt, ReadData1, ReadData2, ALUResult, WriteData, op, ALUOp, ExtendOut, regA, regB, ALUSrcA, ALUSrcB, DBDataSrc);
    input clk;
    input Rst;

    output wire [31:0] pc;
    wire [31:0] pc4;
    output wire [31:0] pcIn;

    wire [31:0] inst;
    
    wire [31:0] instIn;
    assign instIn = 32'h00000000;
    
    output wire [5:0] op;
    output wire [4:0] rs;
    output wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] sa;
    wire [15:0] immediate;
    wire [25:0] address;

    wire PCWre;
    output wire ALUSrcA;
    output wire ALUSrcB;
    output wire DBDataSrc;
    wire RegWre;
    wire InsMemRW;
    wire mRD;
    wire mWR;
    wire RegDst;
    wire ExtSel;
    wire [1:0] PCSrc;
    output wire [2:0] ALUOp;
    
    wire [31:0] DataOut;

    wire [4:0] writeReg;
    output wire [31:0] ReadData1;
    output wire [31:0] ReadData2;
    output wire [31:0] WriteData;
    
    assign writeReg = (RegDst == 0) ? rt : rd;
    assign WriteData = (DBDataSrc == 0) ? ALUResult : DataOut;

    output wire [31:0] ExtendOut;

    output wire [31:0] regA;
    output wire [31:0] regB;
    output wire [31:0] ALUResult;
    wire Zero;
    
    assign regA = (ALUSrcA == 0) ? ReadData1 : sa;
    assign regB = (ALUSrcB == 0) ? ReadData2 : ExtendOut;

    PCSelect PCSelect(
         .PCSrc(PCSrc),
         .PC4(pc4),
         .ExtendOut(ExtendOut),
         .addr(address),
         .PCOut(pcIn)
    );
    
    PC PC( 
        .clk(clk),
        .rst(Rst),
        .PCIn(pcIn),
        .PCWre(PCWre),
        .PCOut(pc),
        .PC4(pc4)
    );

    InstMem instMem( 
        .Iaddr(pc),
        .IDataIn(instIn),
        .RW(InsMemRW),
        .IDataOut(inst)
    );

    InstDecode instDecode( 
        .inst(inst),
        .op(op),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .sa(sa),
        .immediate(immediate),
        .address(address)
    );
    
    Extend extend(
        .ExtSel(ExtSel),
        .ExtIn(immediate),
        .ExtOut(ExtendOut)
    );

    RegFile regFile(
        .clk(clk),
        .rst(Rst),
        .ReadReg1(rs),
        .ReadReg2(rt),
        .WriteReg(writeReg),
        .WriteData(WriteData),
        .WE(RegWre),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    ALU ALU(
        .ALUOp(ALUOp),
        .regA(regA),
        .regB(regB),
        .result(ALUResult),
        .zero(Zero)
    );

    ControlUnit controlUnit(
        .Op(op),
        .zero(Zero),
        .PCWre(PCWre),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .DBDataSrc(DBDataSrc), 
        .RegWre(RegWre), 
        .InsMemRW(InsMemRW),
        .mRD(mRD), 
        .mWR(mWR), 
        .RegDst(RegDst), 
        .ExtSel(ExtSel),
        .PCSrc(PCSrc),
        .ALUOp(ALUOp)
    );

    DataMem dataMem(
        .clk(clk),
        .Daddr(ALUResult),
        .DataIn(ReadData2),
        .mRD(mRD),
        .mWR(mWR),
        .DataOut(DataOut)
    );

endmodule