`timescale 1ns / 1ps

module RegFile(
    input clk,
    input rst,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    input WE,
    output [31:0] ReadData1,
    output [31:0] ReadData2
    );
    
    reg [31:0] regFile[31:1];
    integer i;
    
    assign ReadData1 = (ReadReg1 == 0) ? 0 : regFile[ReadReg1];
    assign ReadData2 = (ReadReg2 == 0) ? 0 : regFile[ReadReg2];
    
    always @ (negedge clk or negedge rst) begin
    if (rst == 0) begin
        for(i = 1; i < 32; i = i + 1)
            regFile[i] <= 0;
        end
    else if (WE == 1 && WriteReg != 0)
        regFile[WriteReg] <= WriteData;
    end
endmodule