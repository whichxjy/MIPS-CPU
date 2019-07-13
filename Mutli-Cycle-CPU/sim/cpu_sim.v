`timescale 1ns / 1ps

module CPU_sim();
    reg CLK;
    reg RST;
    wire [31:0] curPC;
    wire [31:0] nextPC;
    wire [2:0] state;
    wire InsMemRW;
    wire [5:0] Op;
    wire [2:0] ALUOp;
    wire [31:0] result;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [4:0] WriteReg;
    wire [31:0] WriteData;
    wire [31:0] resultDR;
    wire [31:0] dataB;
    wire [31:0] memOut;
    
    MultiCycleCPU MultiCycleCPU(.CLK(CLK),
                                .RST(RST),
                                .curPC(curPC),
                                .nextPC(nextPC),
                                .state(state),
                                .InsMemRW(InsMemRW),
                                .Op(Op),
                                .ALUOp(ALUOp),
                                .result(result),
                                .rs(rs),
                                .rt(rt),
                                .ReadData1(ReadData1),
                                .ReadData2(ReadData2),
                                .WriteReg(WriteReg),
                                .WriteData(WriteData),
                                .resultDR(resultDR),
                                .dataB(dataB),
                                .memOut(memOut)
                                );
    
    always #10 CLK = !CLK;
    
    initial begin
        CLK = 0;
        RST = 0;
        #115;
        RST = 1;
    end

endmodule