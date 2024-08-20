`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Akshay San
// 
// Design Name: UART
// Module Name: Transmitter
// Target Devices: xc7a100tcsg-1
// Description: 
// 
// Dependencies: Baud_gen
// 
//////////////////////////////////////////////////////////////////////////////////


module Transmitter(
       input  [7:0] Tx_pare,
       input  [3:0] control,              // No of bits, P/NP, Even/odd, Stopbits(1/2)
       input        baud_clk,
       inout        Tx_fg,                // If the flag is high then the data has been transmitted
       output       Tx_line
    );
    
    
    
    
    reg  [11:0] Tx_serial;
    reg         Tx_reg;
    wire        Tx_fg;
    wire        parity;

    always @(*)begin
        case(control[3:1])                                                       // The MSB are {No of DataBits, Parity/NoParity, No of StopBits}
            3'b000: Tx_serial = {1'b1,Tx_pare[6:0],1'b0,3'b111};                      // 7B,NP,1   
            3'b010: Tx_serial = {1'b1,parity,Tx_pare[6:0],1'b0,2'b11};                // 7B,P,1
            3'b011: Tx_serial = {2'b11,parity,Tx_pare[6:0],1'b0,1'b1};                // 7B,P,2   
            3'b001: Tx_serial = {2'b11,Tx_pare[6:0],1'b0,2'b11};                      // 7B,NP,2
            3'b100: Tx_serial = {1'b1,Tx_pare,1'b0,2'b11};                            // 8B,NP,1 
            3'b110: Tx_serial = {1'b1,parity,Tx_pare,1'b0,1'b1};                      // 8B,P,1 
            3'b111: Tx_serial = {2'b11,parity,Tx_pare,1'b0};                          // 8B,P,2 
            3'b111: Tx_serial = {2'b11,Tx_pare,1'b0,1'b1};                            // 8B,NP,2 
        endcase
    end
    assign parity  = control[0] ? (~^Tx_pare):(^Tx_pare);                            // control[0] ? odd P : even P 
    assign Tx_fg   = (Tx_serial == 12'd0) ? 1:0;
    assign Tx_line = Tx_reg;

    always @(posedge baud_clk) begin
        if(Tx_fg == 0) begin
            Tx_reg <= Tx_serial[0];
            Tx_serial <= Tx_serial >> 1;
        end
        else begin
            Tx_reg <= 1'b1;
        end
    end
endmodule
