`timescale 1ns / 1ps

module PC(
    input clk,
    input rst,
    input [31:0] PCIn,
    input PCWre,
    output reg [31:0] PCOut,
    output reg [31:0] PC4
    );
   
    always @(posedge clk) begin
        if (rst == 0) begin
            PCOut = 32'h00000000;
            PC4 = PCOut + 4;
        end 
        else if (PCWre == 1) begin
            PCOut = PCIn;
            PC4 = PCOut + 4;
        end     
    end 
endmodule