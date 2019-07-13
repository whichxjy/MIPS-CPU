`timescale 1ns / 1ps

module MultiCycleCPU(
    input CLK,
    input RST,
    output [31:0] curPC,
    output [31:0] nextPC,
    output [2:0] state,
    output InsMemRW,
    output [5:0] Op,
    output [2:0] ALUOp,
    output [31:0] result,
    output [4:0] rs,
    output [4:0] rt,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    output reg [4:0] WriteReg,
    output [31:0] WriteData,
    output [31:0] resultDR,
    output [31:0] dataB,
    output [31:0] memOut
    );
    
    wire PCWre;
    wire ALUSrcA;
    wire ALUSrcB;
    wire DBDataSrc;
    wire RegWre;
    wire WrRegDSrc;
    wire mRD;
    wire mWR;
    wire IRWre;
    wire ExtSel;
    wire [1:0] PCSrc;
    wire [1:0] RegDst;
    wire [2:0] ALUOp;

    wire [31:0] inst;
    wire [31:0] IRInst;

    wire [31:0] instIn;
    assign instIn = 32'h00000000;

    wire zero;
    wire sign;

    wire [4:0] rd;
    wire [4:0] sa;
    wire [15:0] immediate;
    wire [25:0] addr;

    wire [31:0] ExtendImmediate;

    ControlUnit ControlUnit(.CLK(CLK),
                            .RST(RST),
                            .Op(Op),
                            .zero(zero),
                            .sign(sign),
                            .PCWre(PCWre),
                            .ALUSrcA(ALUSrcA),
                            .ALUSrcB(ALUSrcB),
                            .DBDataSrc(DBDataSrc),
                            .RegWre(RegWre),
                            .WrRegDSrc(WrRegDSrc),
                            .InsMemRW(InsMemRW),
                            .mRD(mRD),
                            .mWR(mWR),
                            .IRWre(IRWre),
                            .ExtSel(ExtSel),
                            .PCSrc(PCSrc),
                            .RegDst(RegDst),
                            .ALUOp(ALUOp),
                            .state(state)
                            );
                            
                            
     Extend Extend(.ExtSel(ExtSel),
                   .immediate(immediate),
                   .ExtendImmediate(ExtendImmediate)
                   );
 
                            
    PCSelect PCSelect(.RST(RST),
                      .PCSrc(PCSrc),
                      .curPC(curPC),
                      .ExtendImmediate(ExtendImmediate),
                      .rsData(ReadData1),
                      .addr(addr),
                      .nextPC(nextPC)
                      );
                      
    PC PC(.CLK(CLK),
          .RST(RST),
          .PCWre(PCWre),
          .nextPC(nextPC),
          .curPC(curPC)
          );
          
    InstMem InstMem(.IAddr(curPC),
                    .IDataIn(instIn),
                    .RW(InsMemRW),
                    .IDataOut(inst)
                    );
                    
    IR IR(.CLK(CLK),
          .IRInput(inst),
          .IRWre(IRWre),
          .IRInst(IRInst)
          );

    InstDecode InstDecode(.inst(IRInst),
                          .op(Op),
                          .rs(rs),
                          .rt(rt),
                          .rd(rd),
                          .sa(sa),
                          .immediate(immediate),
                          .addr(addr)
                          );
    
    always @( RegDst or rt or rd ) begin
        case(RegDst)
            2'b00: WriteReg = 5'b11111; // 31
            2'b01: WriteReg = rt;
            2'b10: WriteReg = rd;
        endcase
    end
    
    assign WriteData =  WrRegDSrc ? dataDB : (curPC + 4);

    wire [31:0] ReadData2;
    
    RegFile RegFile(.CLK(CLK),
                    .RST(RST),
                    .ReadReg1(rs),
                    .ReadReg2(rt),
                    .WriteReg(WriteReg),
                    .WriteData(WriteData),
                    .WE(RegWre),
                    .ReadData1(ReadData1),
                    .ReadData2(ReadData2)
                    );
    
    wire [31:0] dataA;
                  
    TempReg ADR(.CLK(CLK),
                .DataIn(ReadData1),
                .DataOut(dataA)
                );
                
    TempReg BDR(.CLK(CLK),
                .DataIn(ReadData2),
                .DataOut(dataB)
                );
                
    ALU ALU(.ALUSrcA(ALUSrcA),
            .ALUSrcB(ALUSrcB),
            .ReadData1(dataA),
            .ReadData2(dataB),
            .sa(sa),
            .extend(ExtendImmediate),
            .ALUOp(ALUOp),
            .result(result),
            .zero(zero),
            .sign(sign)
            );
   
    TempReg ALUoutDR(.CLK(CLK),
                     .DataIn(result),
                     .DataOut(resultDR)
                     );

    DataMem DataMem(.CLK(CLK),
                    .DAddr(resultDR),
                    .DataIn(dataB),
                    .mRD(mRD),
                    .mWR(mWR),
                    .DataOut(memOut)
                    );

    wire [31:0] DBIn, dataDB;
    assign DBIn = DBDataSrc ? memOut : result;
                    
    TempReg DBDR(.CLK(CLK),
                 .DataIn(DBIn),
                 .DataOut(dataDB)
                 );

endmodule