`timescale 1ns / 1ps

module cpu_sim( );
    // input
    reg clk;
    reg Rst;
    // output
    wire [31:0] pc;
    wire [31:0] ALUResult;
    wire [31:0] pc4;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] WriteData;
    wire [5:0] op;
    wire [2:0] ALUOp;
    wire [31:0] ExtendOut;
    wire [31:0] regA;
    wire [31:0] regB;
    wire ALUSrcA;
    wire ALUSrcB;
    wire DBDataSrc;
    
    CPU cpu(
        .clk(clk),
        .Rst(Rst), 
        .pc(pc), 
        .pcIn(pc4), 
        .rs(rs), 
        .rt(rt), 
        .ReadData1(ReadData1), 
        .ReadData2(ReadData2), 
        .ALUResult(ALUResult), 
        .WriteData(WriteData),
        .op(op),
        .ALUOp(ALUOp),
        .ExtendOut(ExtendOut),
        .regA(regA),
        .regB(regB),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .DBDataSrc(DBDataSrc)
    );
     
    always #10 clk = !clk;
    
    initial begin
        clk = 0;
        Rst = 0;
        #115;
        Rst = 1;
    end

endmodule