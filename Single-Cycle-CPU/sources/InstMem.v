`timescale 1ns / 1ps

module InstMem(
    input [31:0] IAddr,
    input [31:0] IDataIn,
    input RW,
    output reg [31:0] IDataOut
    );
    
    reg [7:0] rom[0:300];
    
    initial begin
        $readmemb ("Project/Single-Cycle-CPU/instruction.txt", rom);
    end
    
    always@( RW or IAddr ) begin
        if (RW) begin
           IDataOut[31:24] = rom[IAddr]; 
           IDataOut[23:16] = rom[IAddr + 1]; 
           IDataOut[15:8] = rom[IAddr + 2]; 
           IDataOut[7:0] = rom[IAddr + 3]; 
        end
        
        if (!RW) begin 
            rom[IAddr] = IDataIn[31:24];
            rom[IAddr + 1] = IDataIn[23:16];
            rom[IAddr + 2] = IDataIn[15:8];
            rom[IAddr + 3] = IDataIn[7:0];
        end
    end
endmodule