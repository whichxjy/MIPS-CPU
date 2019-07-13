`timescale 1ns / 1ps

module IR(
        input CLK,
        input [31:0] IRInput,
        input IRWre,
        output reg [31:0] IRInst
    );
    
    always @( posedge CLK ) begin
        if (IRWre) begin
            IRInst <= IRInput;
        end
    end

endmodule