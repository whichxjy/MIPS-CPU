`timescale 1ns / 1ps

module PC(
    input CLK,
    input RST,
    input PCWre,
    input [31:0] nextPC,
    output reg [31:0] curPC
    );
    
    always @( posedge CLK or negedge RST ) begin
        if (RST == 0) begin
            curPC <= 0;
        end
        else if (PCWre) begin
            curPC <= nextPC;
        end
        else begin
            curPC <= curPC;
        end
    end
   
endmodule